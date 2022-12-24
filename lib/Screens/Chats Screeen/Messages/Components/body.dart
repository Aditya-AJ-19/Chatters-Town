import 'package:chatters_town/Screens/Group%20Screen/Controller/group_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Controllers/chat_controller.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/chat_input_field_screen.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/messages.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';

class Mbody extends ConsumerStatefulWidget {
  final String reciverId;
  final bool isGroupChat;

  const Mbody({
    Key? key,
    required this.reciverId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<Mbody> createState() => _MbodyState();
}

class _MbodyState extends ConsumerState<Mbody> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveHeight(kDefaultPadding),
            ),
            child: StreamBuilder(
                stream: widget.isGroupChat
                    ? ref
                        .read(groupControllerprovider)
                        .messageStream(widget.reciverId)
                    : ref
                        .watch(chatcontrollerProvider)
                        .messageStream(widget.reciverId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    messageController
                        .jumpTo(messageController.position.maxScrollExtent);
                  });
                  return ListView.builder(
                    controller: messageController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Message message = snapshot.data![index];
                      if (!message.isseen &&
                          message.recieverid ==
                              FirebaseAuth.instance.currentUser!.uid) {
                        ref.read(chatcontrollerProvider).chatMessageSeen(
                              context,
                              widget.reciverId,
                              message.messageid,
                            );
                      }
                      return MessageLayout(
                        message: message,
                        reciverId: widget.reciverId,
                      );
                    },
                  );
                }),
          ),
        ),
        ChatInputField(
          reciverId: widget.reciverId,
          isGroupchat: widget.isGroupChat,
        ),
      ],
    );
  }
}
