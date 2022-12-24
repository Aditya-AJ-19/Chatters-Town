import 'package:chatters_town/Common%20features/primary_button.dart';
import 'package:chatters_town/Screens/Authentication/UI/login_screen.dart';
import 'package:chatters_town/Screens/Authentication/UI/signup_screen.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';

class SigninOrSignupScreen extends StatelessWidget {
  static const routeName = '/Signin-signout';
  const SigninOrSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: responsiveHeight(kDefaultPadding)),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              "assets/images/chatters_app_logo_3.png",
              height: responsiveHeight(460),
              fit: BoxFit.cover,
            ),
            const Spacer(),
            PrimaryButton(
              text: "Sign In",
              press: (() {
                Navigator.pushNamed(context, LogInScreen.routeName);
              }),
            ),
            SizedBox(
              height: responsiveHeight(kDefaultPadding * 1.5),
            ),
            PrimaryButton(
              text: "Sign Up",
              color: Theme.of(context).colorScheme.tertiary,
              press: (() {
                Navigator.pushNamed(context, SignUpScreen.routeName);
              }),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      )),
    );
  }
}
