import 'package:cached_video_player/cached_video_player.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VideoPlayerItem extends StatefulWidget {
  final Message message;
  const VideoPlayerItem({super.key, required this.message});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    videoPlayerController = CachedVideoPlayerController.network(widget.message.text)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: responsiveHeight(kDefaultPadding)),
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.60),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            CachedVideoPlayer(videoPlayerController),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  if (isPlay) {
                    videoPlayerController.pause();
                  } else {
                    videoPlayerController.play();
                  }

                  setState(() {
                    isPlay = !isPlay;
                  });
                },
                icon: Icon(isPlay ? Icons.pause_circle : Icons.play_circle),
              ),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: SizedBox(
                height: responsiveHeight(10),
                child: Text(
                  DateFormat.Hm().format(widget.message.timesent),
                  style: TextStyle(
                    fontSize: responsiveHeight(10),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
