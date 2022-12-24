import 'dart:io';

import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Models/user_model.dart';
import 'package:chatters_town/Screens/Authentication/repositary/auth_repositary.dart';
import 'package:chatters_town/Utlis/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatters_town/Screens/Chats%20Screeen/Repositary/chat_repositary.dart';

final chatcontrollerProvider = Provider((ref) {
  final chatRepositary = ref.watch(chatRepositaryProvider);
  return ChatController(chatRepositary: chatRepositary, ref: ref);
});

class ChatController {
  final ChatRepositary chatRepositary;
  final ProviderRef ref;

  ChatController({
    required this.chatRepositary,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepositary.getChatContact();
  }

  Stream<List<Message>> messageStream(String reciverId) {
    return chatRepositary.getChatStream(reciverId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String reciverId,
    bool isGroupChat,
  ) async {
    var userdata = await ref.read(authRepositoryProvider).readUser();
    UserModel? user;
    if (userdata.data() != null) {
      user = UserModel.fromMap(userdata.data()!);
    }
    chatRepositary.sendTextMessage(
        context: context,
        text: text,
        reciverId: reciverId,
        senderUser: user!,
        isGroupChat: isGroupChat);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String reciverId,
    required MessageEnum messageEnum,
    required bool isGroupChat,
  }) async {
    var userdata = await ref.read(authRepositoryProvider).readUser();
    UserModel? user;
    if (userdata.data() != null) {
      user = UserModel.fromMap(userdata.data()!);
    }
    chatRepositary.sendFileMessage(
        context: context,
        file: file,
        reciverId: reciverId,
        senderUserData: user!,
        ref: ref,
        messageType: messageEnum,
        isGroupChat: isGroupChat);
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String reciverId,
    bool isGroupChat,
  ) async {
    var userdata = await ref.read(authRepositoryProvider).readUser();
    UserModel? user;
    if (userdata.data() != null) {
      user = UserModel.fromMap(userdata.data()!);
    }
    int index = gifUrl.lastIndexOf('-') + 1;
    String urlMiddlePart = gifUrl.substring(index);
    String newUrl = 'https://i.giphy.com/media/$urlMiddlePart/200.gif';

    chatRepositary.sendGIFMessage(
      context: context,
      gifUrl: newUrl,
      reciverId: reciverId,
      senderUser: user!,
      isGroupChat: isGroupChat,
    );
  }

  void chatMessageSeen(
    BuildContext context,
    String reciverId,
    String messageId,
  ) {
    chatRepositary.setChatMessageSeen(
        context: context, reciverId: reciverId, messageId: messageId);
  }
}
