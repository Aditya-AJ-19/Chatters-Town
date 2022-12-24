import 'package:chatters_town/Screens/Call%20Screen/call_screen.dart';
import 'package:chatters_town/Screens/Chats%20Screeen/chat_screen.dart';
import 'package:chatters_town/Screens/Group%20Screen/Screens/group_screen.dart';
import 'package:chatters_town/Screens/profile%20page/profile_screen.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:flutter/material.dart';

class MainHomeScreen extends StatefulWidget {
  static const routeName = '/mainHome-Screen';
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;
  final screens = [
    const ChatScreen(),
    const GroupScreen(),
    const CallScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.message), label: "Chats"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Groups"),
          const BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: responsiveHeight(15),
              backgroundImage: const AssetImage("assets/images/user_2.png"),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
