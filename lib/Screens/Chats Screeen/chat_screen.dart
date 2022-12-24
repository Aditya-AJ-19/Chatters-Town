import 'package:chatters_town/Screens/Add%20User/UI/add_user.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Components/chat_card.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Controllers/chat_controller.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Messages/message_screen.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatters_town/Models/chats_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatcontrollerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var chatContactdata = snapshot.data![index];
                return ChatCard(
                  chat: chatContactdata,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      MessageScreen.routeName,
                      arguments: {
                        "name": chatContactdata.name,
                        "prifilepic": chatContactdata.profilePic,
                        "reciverid": chatContactdata.contactId,
                      },
                    );
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddUser.routeName);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
    );
  }
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
