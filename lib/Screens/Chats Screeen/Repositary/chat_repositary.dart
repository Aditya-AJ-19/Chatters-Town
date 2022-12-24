import 'dart:io';
import 'package:chatters_town/Common%20features/save_file_to_firebase.dart';
import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Models/user_model.dart';
import 'package:chatters_town/Utlis/app_utils.dart';
import 'package:chatters_town/Utlis/message_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositaryProvider = Provider(
  (ref) => ChatRepositary(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class ChatRepositary {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepositary({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userdata = await firestore
            .collection("Users")
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userdata.data()!);
        contacts.add(
          ChatContact(
            name: "${user.firstname} ${user.lastname}",
            profilePic: user.profilepicture,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String reciverId) {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverId)
        .collection('message')
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

  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      // For reciever
      var recieverChatContact = ChatContact(
        name: "${senderUserData.firstname} ${senderUserData.lastname}",
        profilePic: senderUserData.profilepicture,
        contactId: senderUserData.userid,
        timeSent: timeSent,
        lastMessage: text,
      );

      debugPrint("Send message function is run 2");

      await firestore
          .collection('Users')
          .doc(recieverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(recieverChatContact.toMap());

      // For Sender
      var senderChatContact = ChatContact(
        name: "${recieverUserData!.firstname} ${recieverUserData.lastname}",
        profilePic: recieverUserData.profilepicture,
        contactId: recieverUserData.userid,
        timeSent: timeSent,
        lastMessage: text,
      );

      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverId)
          .set(senderChatContact.toMap());
    }

    debugPrint("Save data to contactsub collection function is run");
  }

  _saveDataToMessageSubCollection({
    required String reciverId,
    required String text,
    required DateTime timesent,
    required String messageId,
    required MessageEnum messageType,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderid: auth.currentUser!.uid,
      recieverid: reciverId,
      text: text,
      type: messageType,
      messageid: messageId,
      timesent: timesent,
      isseen: false,
    );

    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(reciverId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      // for sender
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(reciverId)
          .collection('message')
          .doc(messageId)
          .set(message.toMap());
      // for reciever
      await firestore
          .collection('Users')
          .doc(reciverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('message')
          .doc(messageId)
          .set(message.toMap());
    }

    debugPrint("save data to messagesub collection function is run");
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String reciverId,
    required UserModel senderUser,
    required bool isGroupChat,
  }) async {
    try {
      var timesent = DateTime.now();
      UserModel? reciverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('Users').doc(reciverId).get();
        reciverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
        senderUser,
        reciverUserData,
        text,
        timesent,
        reciverId,
        isGroupChat,
      );

      _saveDataToMessageSubCollection(
        reciverId: reciverId,
        text: text,
        timesent: timesent,
        messageType: MessageEnum.text,
        messageId: messageId,
        isGroupChat: isGroupChat,
      );
      debugPrint("Send message function is run");
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String reciverId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageType,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageType.type}/${senderUserData.userid}/$reciverId/$messageId',
            file,
          );

      UserModel? reciverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('Users').doc(reciverId).get();
        reciverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactmessage;

      switch (messageType) {
        case MessageEnum.image:
          contactmessage = '📷 Photo';
          break;
        case MessageEnum.video:
          contactmessage = '📸 Video';
          break;
        case MessageEnum.audio:
          contactmessage = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactmessage = 'GIF';
          break;
        default:
          contactmessage = 'GIF';
      }

      _saveDataToContactSubCollection(
        senderUserData,
        reciverUserData,
        contactmessage,
        timeSent,
        reciverId,
        isGroupChat,
      );

      _saveDataToMessageSubCollection(
        reciverId: reciverId,
        text: imageUrl,
        timesent: timeSent,
        messageId: messageId,
        messageType: messageType,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String reciverId,
    required UserModel senderUser,
    required bool isGroupChat,
  }) async {
    try {
      var timesent = DateTime.now();
      UserModel? reciverUserData;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('Users').doc(reciverId).get();
        reciverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();

      _saveDataToContactSubCollection(
        senderUser,
        reciverUserData,
        "GIF",
        timesent,
        reciverId,
        isGroupChat,
      );
      
      _saveDataToMessageSubCollection(
        reciverId: reciverId,
        text: gifUrl,
        timesent: timesent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String reciverId,
    required String messageId,
  }) async {
    try {
      // for sender
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(reciverId)
          .collection('message')
          .doc(messageId)
          .update({"isseen": true});
      // for reciever
      await firestore
          .collection('Users')
          .doc(reciverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('message')
          .doc(messageId)
          .update({"isseen": true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
