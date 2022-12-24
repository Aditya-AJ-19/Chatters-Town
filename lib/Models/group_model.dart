class GroupModel {
  final String groupId;
  final String name;
  final String lastMessage;
  final String groupPic;
  final String senderId;
  final List<String> membersid;
  final DateTime timeSent;
  
  GroupModel({
    required this.groupId,
    required this.name,
    required this.lastMessage,
    required this.groupPic,
    required this.senderId,
    required this.membersid,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'senderId': senderId,
      'membersid': membersid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'] ?? '',
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      senderId: map['senderId'] ?? '',
      membersid: List<String>.from(map['membersid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
