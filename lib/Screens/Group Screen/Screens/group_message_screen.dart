import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatters_town/Models/group_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';

class GroupMessageScreen extends ConsumerWidget {
  static const routeName = '/group-message-screen';
  final GroupModel groupInfo;

  const GroupMessageScreen({
    Key? key,
    required this.groupInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppBar buildAppbar({
      required GroupModel groupInfo,
    }) {
      return AppBar(
        leadingWidth: responsiveHeight(35),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: responsiveHeight(20)),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(groupInfo.groupPic),
            ),
            SizedBox(
              width: responsiveWidth(kDefaultPadding * 0.75),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupInfo.name,
                  style: TextStyle(
                    fontSize: responsiveHeight(16),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: buildAppbar(
        groupInfo: groupInfo,
      ),
      body: Mbody(
        reciverId: groupInfo.groupId,
        isGroupChat: true,
      ),
    );
  }
}
