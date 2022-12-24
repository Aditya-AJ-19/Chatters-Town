import 'package:chatters_town/Screens/Add%20User/UI/add_user.dart';
import 'package:chatters_town/Screens/Authentication/UI/login_screen.dart';
import 'package:chatters_town/Screens/Authentication/UI/signup_screen.dart';
import 'package:chatters_town/Screens/Authentication/UI/user_info_screen.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/message_screen.dart';
import 'package:chatters_town/Screens/Group%20Screen/Screens/group_message_screen.dart';
import 'package:chatters_town/Screens/main_home_screen.dart';
import 'package:chatters_town/Screens/signin_out.dart';
import 'package:flutter/material.dart';

import 'Screens/Group Screen/Screens/creat_group_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SigninOrSignupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SigninOrSignupScreen(),
      );
    case LogInScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LogInScreen(),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case UserInfoScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final email = arguments['email'];
      final pass = arguments["pass"];
      return MaterialPageRoute(
        builder: (context) => UserInfoScreen(
          email: email,
          password: pass,
        ),
      );
    case MainHomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MainHomeScreen(),
      );
    case MessageScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final profilepic = arguments["prifilepic"];
      final reciverid = arguments["reciverid"];
      return MaterialPageRoute(
        builder: (context) => MessageScreen(
          name: name,
          profilepic: profilepic,
          reciverid: reciverid,
        ),
      );
    case AddUser.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddUser(),
      );
    case CreatGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreatGroupScreen(),
      );
    case GroupMessageScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final groupinfo = arguments['groupInfo'];
      return MaterialPageRoute(
        builder: (context) => GroupMessageScreen(groupInfo: groupinfo,),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text(
              "Page not fount",
            ),
          ),
        ),
      );
  }
}
