import 'package:chatters_town/Screens/Authentication/Controller/auth_controller.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogInScreen extends ConsumerStatefulWidget {
  static const routeName = '/Login-screen';
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  void login() {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    ref
        .read(authControllerProvider)
        .signinWithEmailandPass(context, email, password);
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
                "Login",
                style: TextStyle(
                  fontSize: responsiveHeight(50),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              Text(
                "Please log in to continue",
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
                        controller: emailcontroller,
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
                          emailcontroller.text = value!;
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
                        controller: passwordcontroller,
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
                          passwordcontroller.text = value!;
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
                          if (formkey.currentState!.validate()) {
                            login();
                          }
                          
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsiveHeight(15))),
                        child: const Text("Log in"),
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
