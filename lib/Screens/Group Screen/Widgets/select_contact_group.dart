import 'package:chatters_town/Models/chats_model.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/Controllers/chat_controller.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedGroupContacts = StateProvider<List<ChatContact>>((ref) => []);

class SelectContactGroup extends ConsumerStatefulWidget {
  const SelectContactGroup({super.key});

  @override
  ConsumerState<SelectContactGroup> createState() => _SelectContactGroupState();
}

class _SelectContactGroupState extends ConsumerState<SelectContactGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, ChatContact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.notifier)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatContact>>(
      stream: ref.read(chatcontrollerProvider).chatContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var chatContactdata = snapshot.data![index];
              return InkWell(
                onTap: () => selectContact(index, chatContactdata),
                child: Padding(
                  padding: EdgeInsets.only(bottom: responsiveHeight(8)),
                  child: ListTile(
                    title: Text(
                      chatContactdata.name,
                      style: TextStyle(
                        fontSize: responsiveHeight(18),
                      ),
                    ),
                    leading: selectedContactsIndex.contains(index)
                        ? const Icon(Icons.done)
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
