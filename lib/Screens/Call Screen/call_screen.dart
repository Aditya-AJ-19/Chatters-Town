import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) => callCard(context),
        itemCount: chatsData.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
    );
  }
}

Widget callCard(BuildContext context) {
  return InkWell(
    // onTap: press,
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
                backgroundImage: const NetworkImage(
                    "https://www.kindpng.com/picc/m/21-214439_free-high-quality-person-icon-default-profile-picture.png"),
              ),
            //   if (chat.isActive)
            //     Positioned(
            //       right: 0,
            //       bottom: 0,
            //       child: Container(
            //         height: responsiveHeight(16),
            //         width: responsiveHeight(16),
            //         decoration: BoxDecoration(
            //             color: kPrimaryColor,
            //             shape: BoxShape.circle,
            //             border: Border.all(
            //               color: Theme.of(context).scaffoldBackgroundColor,
            //               width: responsiveHeight(3),
            //             )),
            //       ),
            //     ),
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
                    "Aditya",
                    style: TextStyle(
                      fontSize: responsiveHeight(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(Icons.call)
        ],
      ),
    ),
  );
}

AppBar buildAppBar() {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: const Text("Chats"),
    // backgroundColor: kPrimaryColor,
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.search),
      ),
    ],
  );
}
