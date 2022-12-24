import 'package:audioplayers/audioplayers.dart';
import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatters_town/Models/message_model.dart';
import 'package:chatters_town/Utlis/size_config.dart';

class AudioMessage extends StatefulWidget {
  final Message message;
  final String reciverId;
  const AudioMessage({
    Key? key,
    required this.message,
    required this.reciverId,
  }) : super(key: key);

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Duration dura = const Duration();
  Duration posi = const Duration();

  String formateTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void initState() {
    super.initState();

    // Listen to Audio Duration
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
        dura = event;
      });
    });

    // Listen to Position change
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
        posi = event;
      });
    });

    audioPlayer.setSourceUrl(widget.message.text);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: responsiveHeight(5)),
      width: responsiveHeight(SizeConfig.screenWidth * 0.65),
      height: responsiveHeight(35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveHeight(20)),
        color: kPrimaryColor
            .withOpacity(widget.message.senderid != widget.reciverId ? 1 : 0.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.white,
              thumbColor: Colors.white,
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {},
            ),
          ),
          IconButton(
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.play(UrlSource(widget.message.text));
              }

              setState(() {
                isPlaying = !isPlaying;
              });
            },
            icon: isPlaying
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
          ),
          Text(
            formateTime(dura),
            style: TextStyle(
              fontSize: responsiveHeight(12),
            ),
          ),
        ],
      ),
    );
  }
}
