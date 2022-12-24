import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';

class VideoMessage extends StatelessWidget {
  final Message message;
  const VideoMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: responsiveHeight(kDefaultPadding)),
      width: SizeConfig.screenWidth * 0.60,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(responsiveHeight(8)),
              child: Image.asset("assets/images/Video Place Here.png"),
            ),
            Container(
              height: responsiveHeight(25),
              width: responsiveHeight(25),
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                size: responsiveHeight(16),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
