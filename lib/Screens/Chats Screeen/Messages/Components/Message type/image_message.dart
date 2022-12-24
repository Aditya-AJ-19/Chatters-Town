import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageMessage extends StatelessWidget {
  final Message message;
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: responsiveHeight(kDefaultPadding)),
          constraints: BoxConstraints(
            maxWidth: SizeConfig.screenWidth * 0.50,
            maxHeight: responsiveHeight(260),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsiveHeight(10)),
            child: CachedNetworkImage(
              imageUrl: message.text,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: SizedBox(
            height: responsiveHeight(10),
            child: Text(
              DateFormat.Hm().format(message.timesent),
              style: TextStyle(
                fontSize: responsiveHeight(10),
                color: Colors.white60,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
