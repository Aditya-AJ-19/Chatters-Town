import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Components/chat_card.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/message_screen.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  static const routeName = '/AddUser-screen';
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool isSearched = false;
  static String suserName = "";
  final TextEditingController username = TextEditingController();

  // void searchUser(String username) async {
  //   final result = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .where('username', isEqualTo: username)
  //       .get();
  //   var data = result.docs.map((e) => ChatContact.fromMap(e.data()));
  //   searchuser = data.first;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: responsiveHeight(15), vertical: responsiveHeight(20)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveHeight(5),
                  vertical: responsiveHeight(10),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveHeight(30)),
                  color: Theme.of(context).primaryColor,
                ),
                width: SizeConfig.screenWidth,
                height: responsiveHeight(55),
                child: Row(
                  children: [
                    SizedBox(
                      width: responsiveWidth(285),
                      child: TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Username");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: responsiveHeight(10),
                            bottom: responsiveHeight(10),
                          ),
                          hintText: "Enter username for search",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: responsiveHeight(5),
                    ),
                    InkWell(
                        onTap: () {
                          if (username.text != "") {
                            isSearched = true;
                            suserName = username.text;
                            setState(() {});
                          }
                        },
                        child: const Icon(Icons.search)),
                    SizedBox(
                      width: responsiveHeight(5),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: responsiveHeight(10),
              ),
              SizedBox(
                  height: responsiveHeight(70),
                  width: SizeConfig.screenWidth,
                  child: isSearched
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where('username', isEqualTo: suserName)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.docs.first.data();
                              var name = "${data['firstname']} ${data['lastname']}";
                              var profilepic = "${data['profilepicture']}";
                              var uid = "${data['userid']}";
                              var timesent = DateTime.now();
                              return ChatCard(
                                  chat: ChatContact(
                                    name: name,
                                    profilePic: profilepic,
                                    contactId: uid,
                                    timeSent: timesent,
                                    lastMessage: "hello",
                                  ),
                                  press: () {
                                    Navigator.pushNamed(
                                        context, MessageScreen.routeName,
                                        arguments: {
                                          "name": name,
                                          "prifilepic": profilepic,
                                          "reciverid": uid,
                                          "isonline": true,
                                        });
                                  });
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text("Error"),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                      : const Center(
                          child: Text("No user found!"),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
