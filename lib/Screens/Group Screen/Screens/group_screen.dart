import 'package:chatters_town/Models/group_model.dart';
import 'package:chatters_town/Screens/Group%20Screen/Controller/group_controller.dart';
import 'package:chatters_town/Screens/Group%20Screen/Screens/creat_group_screen.dart';
import 'package:chatters_town/Screens/Group%20Screen/Screens/group_message_screen.dart';
import 'package:chatters_town/Screens/Group%20Screen/components/group_card.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder<List<GroupModel>>(
        stream: ref.read(groupControllerprovider).getGroups(),
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
              var groupinfo = snapshot.data![index];
              return GroupCard(
                groupInfo: groupinfo,
                press: () {
                  Navigator.pushNamed(
                    context,
                    GroupMessageScreen.routeName,
                    arguments: {
                      'groupInfo':groupinfo,
                    }
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreatGroupScreen.routeName);
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.people_alt,
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
    title: const Text("Groups"),
    // backgroundColor: kPrimaryColor,
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.search),
      ),
    ],
  );
}
