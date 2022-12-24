import 'package:chatters_town/Models/user_model.dart';
import 'package:chatters_town/Screens/Authentication/Controller/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:chatters_town/Screens/Chats%20Screeen/Messages/Components/body.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageScreen extends ConsumerWidget {
  static const routeName = '/Message-screen';
  final String name;
  final String reciverid;
  final String profilepic;

  const MessageScreen({
    Key? key,
    required this.name,
    required this.reciverid,
    required this.profilepic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppBar buildAppbar({
      required BuildContext context,
      required String name,
      required String profilepic,
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
              backgroundImage: NetworkImage(profilepic),
            ),
            SizedBox(
              width: responsiveWidth(kDefaultPadding * 0.75),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: responsiveHeight(16),
                  ),
                ),
                SizedBox(
                  width: responsiveHeight(40),
                  child: StreamBuilder<UserModel>(
                      stream: ref
                          .watch(authControllerProvider)
                          .userDataById(reciverid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                              debugPrint("No connection");
                          return const SizedBox();
                        }
                        if (!snapshot.hasData) {
                          debugPrint("No data");
                          debugPrint("name = ${snapshot.data!.firstname}");
                          return const SizedBox();
                        }
                        return Text(
                          snapshot.data!.isOnline ? "Online" : "Offline",
                          style: TextStyle(
                            fontSize: responsiveHeight(12),
                          ),
                        );
                      }),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
      );
    }

    return Scaffold(
      appBar: buildAppbar(
        context: context,
        name: name,
        profilepic: profilepic,
      ),
      body: Mbody(
        reciverId: reciverid,
        isGroupChat: false,
      ),
    );
  }
}
