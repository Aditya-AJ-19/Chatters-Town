import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatCard extends ConsumerWidget {
  ChatContact chat;
  VoidCallback press;
  ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsiveHeight(kDefaultPadding),
          vertical: responsiveHeight(kDefaultPadding * 0.75),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: responsiveHeight(25),
                  backgroundImage: NetworkImage(chat.profilePic),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsiveHeight(kDefaultPadding)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: TextStyle(
                        fontSize: responsiveHeight(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(
                DateFormat.Hm().format(chat.timeSent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
