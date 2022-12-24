import 'dart:io';
import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Models/group_model.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatters_town/Screens/Group%20Screen/Repository/group_repository.dart';

final groupControllerprovider = Provider(
  (ref) {
    final groupRepository = ref.read(groupRepositoryProvider);
    return GroupController(groupRepository: groupRepository, ref: ref);
  },
);

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void creatGroup(BuildContext context, String name, File profilepic,
      List<ChatContact> contact) {
    groupRepository.creatGroup(
      context,
      name,
      profilepic,
      contact,
    );
  }

  Stream<List<GroupModel>> getGroups() {
    return groupRepository.getgroups();
  }

  Stream<List<Message>> messageStream(String groupId) {
    return groupRepository.getGroupChatStream(groupId);
  }
}
