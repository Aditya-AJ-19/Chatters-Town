import 'package:flutter/material.dart';

import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:intl/intl.dart';

class TextMessage extends StatelessWidget {
  final Message message;
  final String reciverId;
  const TextMessage({
    Key? key,
    required this.message,
    required this.reciverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: responsiveWidth(210), maxHeight: responsiveHeight(100), minHeight: responsiveHeight(45)),
      margin: EdgeInsets.only(top: responsiveHeight(kDefaultPadding/2.5)),
      padding: EdgeInsets.only(left: responsiveHeight(kDefaultPadding * 0.95), right: responsiveHeight(kDefaultPadding * 0.95), top: responsiveHeight(kDefaultPadding / 2.2)),
      decoration: BoxDecoration(
        color:
            kPrimaryColor.withOpacity(message.senderid == reciverId ? 0.2 : 1),
        borderRadius: BorderRadius.circular(responsiveHeight(30)),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: responsiveWidth(210),),
          margin: EdgeInsets.only(bottom: responsiveHeight(5)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: responsiveHeight(5)),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.senderid != reciverId
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: responsiveHeight(10),
                child: Text(
                  DateFormat.Hm().format(message.timesent),
                  style: TextStyle(fontSize: responsiveHeight(10), color: Colors.white60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
