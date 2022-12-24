import 'dart:io';

import 'package:chatters_town/Screens/Group%20Screen/Controller/group_controller.dart';
import 'package:chatters_town/Screens/Group%20Screen/Widgets/select_contact_group.dart';
import 'package:chatters_town/Utlis/app_utils.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/creat-group';
  const CreatGroupScreen({super.key});

  @override
  ConsumerState<CreatGroupScreen> createState() => _CreatGroupScreenState();
}

class _CreatGroupScreenState extends ConsumerState<CreatGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  File? profilepicture;

  void selectImage(bool isCroop) async {
    // userid = FirebaseAuth.instance.currentUser!.uid.toString();
    profilepicture = await pickImageFromGallery(isCroop);
    // profilepicture = await ref
    //     .read(commonFirebaseStorageRepositoryProvider)
    //     .storeFileToFirebase(
    //         "Users/${FirebaseAuth.instance.currentUser!.uid}", image!);
    // debugPrint("Download url = $profilepicture");
    setState(() {});
  }

  void creatGroup() {
    if (groupNameController.text.trim().isNotEmpty && profilepicture != null) {
      ref.read(groupControllerprovider).creatGroup(
            context,
            groupNameController.text.trim(),
            profilepicture!,
            ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.notifier).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Creat Group"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: responsiveHeight(20), vertical: responsiveHeight(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: responsiveHeight(10),
              width: SizeConfig.screenWidth,
            ),
            Stack(
              children: [
                profilepicture == null
                    ? CircleAvatar(
                        radius: responsiveHeight(55),
                        backgroundImage: const NetworkImage(
                            "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png"),
                      )
                    : CircleAvatar(
                        radius: responsiveHeight(55),
                        // backgroundImage: NetworkImage(profilepicture!),
                        backgroundImage: FileImage(profilepicture!),
                      ),
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
            SizedBox(
              height: responsiveHeight(20),
            ),
            TextFormField(
              autofocus: false,
              keyboardType: TextInputType.text,
              controller: groupNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter first name";
                }
                return null;
              },
              onSaved: (value) {
                groupNameController.text = value!;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
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
                hintText: "Enter Group Name",
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(responsiveWidth(30)),
                ),
              ),
            ),
            SizedBox(
              height: responsiveHeight(20),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Select Contacts",
                style: TextStyle(
                  fontSize: responsiveHeight(18),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: responsiveHeight(10),
            ),
            const SelectContactGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: creatGroup,
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
