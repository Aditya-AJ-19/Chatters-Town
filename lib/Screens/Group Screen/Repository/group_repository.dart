import 'dart:io';
import 'package:chatters_town/Common%20features/save_file_to_firebase.dart';
import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Models/group_model.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Utlis/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void creatGroup(BuildContext context, String name, File profilepic,
      List<ChatContact> contact) async {
    try {
      List<String> uids = [];
      for (var i = 0; i < contact.length; i++) {
        uids.add(contact[i].contactId);
      }
      var groupId = const Uuid().v1();
      String groupPicUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('group/$groupId', profilepic);
      GroupModel group = GroupModel(
        groupId: groupId,
        name: name,
        lastMessage: '',
        groupPic: groupPicUrl,
        senderId: auth.currentUser!.uid,
        membersid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );
      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<GroupModel>> getgroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        var group = GroupModel.fromMap(document.data());
        if (group.membersid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timesent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }
  
}
