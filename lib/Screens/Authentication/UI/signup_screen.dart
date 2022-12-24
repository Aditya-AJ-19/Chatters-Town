import 'package:chatters_town/Screens/Authentication/Controller/auth_controller.dart';
import 'package:chatters_town/Screens/Authentication/UI/user_info_screen.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const routeName = '/signup-screen';
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signinWithEmail() {
    if (formkey.currentState!.validate()) {
      debugPrint("Form is validate");
      String email = emailController.text.trim();
      String pass = passwordController.text.trim();
      ref.read(authControllerProvider).creatNewUser(context, email, pass);
      Navigator.pushNamed(context, UserInfoScreen.routeName,arguments: {
        "email":emailController.text,
        "pass":passwordController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: responsiveHeight(kDefaultPadding * 1.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Spacer(),
              SizedBox(
                height: responsiveHeight(200),
                child: Center(
                    child: Image.asset(
                  "assets/images/chatters_app_logo_2.png",
                  fit: BoxFit.cover,
                )),
              ),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: responsiveHeight(50),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              Text(
                "Please Sign up to continue",
                style: TextStyle(
                  fontSize: responsiveHeight(15),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              SizedBox(
                height: responsiveHeight(20),
              ),
              Container(
                width: double.infinity,
                height: responsiveHeight(300),
                padding: EdgeInsets.symmetric(horizontal: responsiveHeight(10)),
                // color: kPrimaryColor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // color: Theme.of(context).backgroundColor,
                  color: kTertiaryColor.withOpacity(0.5),
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          // fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              responsiveWidth(20),
                              responsiveHeight(15),
                              responsiveWidth(20),
                              responsiveHeight(15)),
                          hintText: "Your Email Address",
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(responsiveWidth(30)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: responsiveHeight(25),
                      ),
                      TextFormField(
                        autofocus: false,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          // fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: Icon(
                            Icons.key_outlined,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              responsiveWidth(20),
                              responsiveHeight(15),
                              responsiveWidth(20),
                              responsiveHeight(15)),
                          hintText: "Your Password",
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(responsiveWidth(30)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: responsiveHeight(30),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveHeight(13)),
                        color: kPrimaryColor,
                        minWidth: responsiveHeight(200),
                        onPressed: () {
                          signinWithEmail();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsiveHeight(15))),
                        child: const Text("Sign Up"),
                      )
                    ],
                  ),
                ),
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
