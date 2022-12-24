import 'package:chatters_town/Utlis/message_enum.dart';

class Message {
  final String senderid;
  final String recieverid;
  final String text;
  final MessageEnum type;
  final String messageid;
  final DateTime timesent;
  final bool isseen;
  
  Message({
    required this.senderid,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.messageid,
    required this.timesent,
    required this.isseen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderid': senderid,
      'recieverid': recieverid,
      'text': text,
      'type': type.type,
      'messageid': messageid,
      'timesent': timesent.millisecondsSinceEpoch,
      'isseen': isseen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderid: map['senderid'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      messageid: map['messageid'] ?? '',
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent']),
      isseen: map['isseen'] ?? false,
    );
  }
}
