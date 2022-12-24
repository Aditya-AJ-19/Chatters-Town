import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/Message%20type/gif_message_screen.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/Message%20type/video/video_player_item.dart';
import 'package:chatters_town/Utlis/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/Message%20type/audio_message_screen.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/Message%20type/image_message.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/Message%20type/text_message_screen.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';

class MessageLayout extends StatelessWidget {
  final Message message;
  final String reciverId;

  const MessageLayout({
    Key? key,
    required this.message,
    required this.reciverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget messageContent(Message message) {
      switch (message.type) {
        case MessageEnum.text:
          return TextMessage(message: message, reciverId: reciverId);
        case MessageEnum.audio:
          return AudioMessage(message: message, reciverId: reciverId);
        case MessageEnum.gif:
          return GIFMessage(message: message);
        case MessageEnum.video:
          return VideoPlayerItem(message: message);
        case MessageEnum.image:
          return ImageMessage(message: message);
        default:
          return const SizedBox();
      }
    }

    return Row(
      mainAxisAlignment: message.senderid == reciverId
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (message.senderid == reciverId) ...[
          CircleAvatar(
            radius: responsiveHeight(12),
            backgroundImage: const AssetImage("assets/images/user_2.png"),
          ),
          SizedBox(
            width: responsiveHeight(kDefaultPadding / 2.5),
          ),
        ],
        Padding(
          padding: EdgeInsets.only(bottom: responsiveHeight(20)),
          child: messageContent(message),
        ),
        if (message.senderid != reciverId)
          MessageStatusDot(
            status: message.isseen,
          ),
      ],
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final bool status;
  const MessageStatusDot({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dotColor(bool status) {
      if (status) {
        return kPrimaryColor;
      } else {
        return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.2);
      }
    }

    return Container(
      margin: EdgeInsets.only(left: responsiveHeight(kDefaultPadding / 2)),
      height: responsiveHeight(12),
      width: responsiveHeight(12),
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status ? Icons.done_all : Icons.done,
        size: responsiveHeight(8),
        color: Colors.white,
      ),
    );
  }
}
