class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  // final bool isonline;

  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
    // required this.isonline,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      // 'isonline': isonline,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactId: map['contactId'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
      // isonline: map['isonline'] ?? false,
    );
  }
}

List chatsData = [
  ChatContact(
    name: "Jenny Wilson",
    profilePic: "https://www.digicatapult.org.uk/wp-content/uploads/2021/11/DC_square_People_juergen-600x600-c-default.jpg",
    contactId: "1",
    timeSent: DateTime.now(),
    lastMessage: "Hope you are doing well...",
    // isonline: false,
  ),
];

// List chatsData = [
//   Chat(
//     name: "Jenny Wilson",
//     lastMessage: "Hope you are doing well...",
//     image: "assets/images/user.png",
//     time: "3m ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Esther Howard",
//     lastMessage: "Hello Abdullah! I am...",
//     image: "assets/images/user_2.png",
//     time: "8m ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Ralph Edwards",
//     lastMessage: "Do you have update...",
//     image: "assets/images/user_3.png",
//     time: "5d ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Jacob Jones",
//     lastMessage: "You’re welcome :)",
//     image: "assets/images/user_4.png",
//     time: "5d ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Albert Flores",
//     lastMessage: "Thanks",
//     image: "assets/images/user_5.png",
//     time: "6d ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Jenny Wilson",
//     lastMessage: "Hope you are doing well...",
//     image: "assets/images/user.png",
//     time: "3m ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Esther Howard",
//     lastMessage: "Hello Abdullah! I am...",
//     image: "assets/images/user_2.png",
//     time: "8m ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Ralph Edwards",
//     lastMessage: "Do you have update...",
//     image: "assets/images/user_3.png",
//     time: "5d ago",
//     isActive: false,
//   ),
// ];
