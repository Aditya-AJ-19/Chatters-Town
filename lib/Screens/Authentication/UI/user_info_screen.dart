import 'dart:io';
import 'package:chatters_town/Common%20features/save_file_to_firebase.dart';
import 'package:chatters_town/Screens/Authentication/Controller/auth_controller.dart';
import 'package:chatters_town/Screens/Authentication/repositary/auth_repositary.dart';
import 'package:chatters_town/Utlis/app_utils.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const routeName = '/UserInfo-screen';
  final String email;
  final String password;
  const UserInfoScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  // final auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController username = TextEditingController();
  String? userid;
  File? image;
  String? profilepicture;

  // void selectImage() async {
  //   profilepicture = await ref
  //       .read(filePickerProvider)
  //       .selectImage(cropimage: cropSquareImage);
  //   setState(() {});
  // }

  void selectImage(bool isCroop) async {
    userid = FirebaseAuth.instance.currentUser!.uid.toString();
    image = await pickImageFromGallery(isCroop);
    profilepicture = await ref
        .read(commonFirebaseStorageRepositoryProvider)
        .storeFileToFirebase(
            "Users/${FirebaseAuth.instance.currentUser!.uid}", image!);
    debugPrint("Download url = $profilepicture");
    setState(() {});
  }

  Future<bool> checkusername() {
    return ref.read(authRepositoryProvider).usernameCheck(username.text);
  }

  void saveuser() {
    String firstName = firstname.text.trim();
    String lastName = lastname.text.trim();
    String userNmae = username.text.trim();
    String number1 = number.text.trim();
    ref.read(authControllerProvider).saveUserInfo(
          context,
          firstName,
          lastName,
          number1,
          profilepicture!,
          userid!,
          userNmae,
          widget.email,
          widget.password,
        );
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
                "Your Information",
                style: TextStyle(
                  fontSize: responsiveHeight(35),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              Text(
                "Please Fil all the information",
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
                height: responsiveHeight(500),
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
                      Container(
                        margin: EdgeInsets.only(bottom: responsiveHeight(10)),
                        width: double.infinity,
                        height: 100,
                        child: Center(
                          child: Stack(
                            children: [
                              profilepicture == null
                                  ? CircleAvatar(
                                      radius: responsiveHeight(55),
                                      backgroundImage: const NetworkImage(
                                          "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png"),
                                    )
                                  : CircleAvatar(
                                      radius: responsiveHeight(55),
                                      backgroundImage: NetworkImage(profilepicture!)),
                              Positioned(
                                right: -5,
                                bottom: -5,
                                child: IconButton(
                                  onPressed: () => selectImage(true),
                                  icon: const Icon(Icons.add_a_photo),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        controller: firstname,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter first name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstname.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          // fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              responsiveWidth(20),
                              responsiveHeight(15),
                              responsiveWidth(20),
                              responsiveHeight(15)),
                          hintText: "Your First Name",
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
                        height: responsiveHeight(20),
                      ),
                      TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        controller: lastname,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter last name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          lastname.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          // fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              responsiveWidth(20),
                              responsiveHeight(15),
                              responsiveWidth(20),
                              responsiveHeight(15)),
                          hintText: "Your Last Name",
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
                        height: responsiveHeight(20),
                      ),
                      TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter username";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          // fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              responsiveWidth(20),
                              responsiveHeight(15),
                              responsiveWidth(20),
                              responsiveHeight(15)),
                          hintText: "UserName",
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
                      TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        controller: number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter number";
                          }
                          if (value.length < 10) {
                            return "Enter Valid number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          number.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          // fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              responsiveWidth(20),
                              responsiveHeight(15),
                              responsiveWidth(20),
                              responsiveHeight(15)),
                          hintText: "Phone Number",
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
                        onPressed: () async {
                          final valid = await checkusername();
                          if (!valid) {
                            showSnackBar(
                                context: context,
                                content: "username already exist");
                          } else if (formkey.currentState!.validate()) {
                            debugPrint("Form is validate");
                            saveuser();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsiveHeight(15))),
                        child: const Text("Welcome"),
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
