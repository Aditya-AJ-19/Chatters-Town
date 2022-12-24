import 'package:chatters_town/Screens/Authentication/Controller/auth_controller.dart';
import 'package:chatters_town/Screens/signin_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatters_town/Common%20features/primary_button.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: responsiveHeight(295),
            child: FutureBuilder(
              future: ref.watch(authControllerProvider).readUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var docData = snapshot.data as DocumentSnapshot;

                  debugPrint("User = ${docData['username']}");
                  return SizedBox(
                    height: responsiveHeight(295),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: responsiveHeight(25),
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: responsiveHeight(65),
                              backgroundImage:
                                  NetworkImage("${docData['profilepicture']}"),
                            ),
                            Positioned(
                              right: responsiveHeight(0),
                              bottom: responsiveHeight(0),
                              child: Container(
                                width: responsiveHeight(35),
                                height: responsiveHeight(35),
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: responsiveHeight(20),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: responsiveHeight(15),
                        ),
                        Text(
                          "${docData['firstname']} ${docData['lastname']}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: responsiveHeight(25),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: responsiveHeight(5),
                        ),
                        Text(
                          "${docData['username']}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: responsiveHeight(15),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: responsiveHeight(10),
                        ),
                        PrimaryButton(
                          press: () {},
                          text: "Edit",
                          width: responsiveHeight(90),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveHeight(10),
                            vertical: responsiveHeight(5),
                          ),
                        ),
                        SizedBox(
                          height: responsiveHeight(10),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ProfileListTile(
                  icon: Icons.person_outline,
                  text: "Account",
                  hasNavigation: true,
                ),
                ProfileListTile(
                  icon: Icons.settings_outlined,
                  text: "Settings",
                  hasNavigation: true,
                ),
                ProfileListTile(
                  icon: Icons.help_outline,
                  text: "help & Support",
                  hasNavigation: true,
                ),
                InkWell(
                  onTap: () { FirebaseAuth.instance.signOut();
                    if (FirebaseAuth.instance.currentUser == null) {
                      debugPrint("No User Found");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninOrSignupScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: ProfileListTile(
                    icon: Icons.exit_to_app,
                    text: "Logout",
                    hasNavigation: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    centerTitle: true,
    title: const Text("Profile"),
  );
}

class ProfileListTile extends StatelessWidget {
  String text;
  bool hasNavigation;
  final IconData icon;
  ProfileListTile({
    Key? key,
    required this.text,
    required this.hasNavigation,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsiveHeight(35)).copyWith(
        bottom: responsiveHeight(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: responsiveHeight(20)),
      height: responsiveHeight(55),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveHeight(30)),
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: responsiveHeight(27),
          ),
          SizedBox(
            width: responsiveWidth(20),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: responsiveHeight(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (hasNavigation)
            Icon(
              Icons.arrow_forward_ios,
              size: responsiveHeight(25),
            ),
        ],
      ),
    );
  }
}
