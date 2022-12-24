import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';

import 'package:chatters_town/Models/group_model.dart';
import 'package:intl/intl.dart';

class GroupCard extends StatelessWidget {
  final GroupModel groupInfo;
  final VoidCallback press;
  const GroupCard({
    Key? key,
    required this.groupInfo,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: NetworkImage(groupInfo.groupPic),
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
                      groupInfo.name,
                      style: TextStyle(
                        fontSize: responsiveHeight(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        groupInfo.lastMessage,
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
                DateFormat.Hm().format(groupInfo.timeSent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
