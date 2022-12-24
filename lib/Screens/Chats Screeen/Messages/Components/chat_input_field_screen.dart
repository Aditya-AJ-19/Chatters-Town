import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:chatters_town/Screens/Chats%20Screeen/Controllers/chat_controller.dart';
import 'package:chatters_town/Utlis/app_utils.dart';
import 'package:chatters_town/Utlis/message_enum.dart';
import 'package:chatters_town/Utlis/size_config.dart';
import 'package:chatters_town/constants.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String reciverId;
  final bool isGroupchat; 

  const ChatInputField({
    Key? key,
    required this.reciverId,
    required this.isGroupchat,
  }) : super(key: key);

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  bool isShowSendButton = false;
  bool isShowEmojiContainer = false;
  bool isRecordinginit = false;
  bool isRecording = false;
  final TextEditingController _messagecontroller = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic permission not allowed");
    }
    await _soundRecorder!.openRecorder();
    isRecordinginit = true;
  }

  void sendtextMessage() async {
    if (isShowSendButton) {
      debugPrint("reciverId = ${widget.reciverId}");
      ref.watch(chatcontrollerProvider).sendTextMessage(
            context,
            _messagecontroller.text.trim(),
            widget.reciverId,
            widget.isGroupchat,
          );
      setState(() {
        _messagecontroller.text = "";
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecordinginit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(
          file: File(path),
          messageEnum: MessageEnum.audio,
        );
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage({
    required File file,
    required MessageEnum messageEnum,
  }) {
    ref.read(chatcontrollerProvider).sendFileMessage(
          context: context,
          file: file,
          reciverId: widget.reciverId,
          messageEnum: messageEnum,
          isGroupChat: widget.isGroupchat
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(false);
    if (image != null) {
      sendFileMessage(
        file: image,
        messageEnum: MessageEnum.image,
      );
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(
        file: video,
        messageEnum: MessageEnum.video,
      );
    }
  }

  void sendGIFMessage({
    required String gifUrl,
  }) {
    ref.read(chatcontrollerProvider).sendGIFMessage(
          context,
          gifUrl,
          widget.reciverId,
          widget.isGroupchat,
        );
  }

  void selectGIF() async {
    final gif = await pickGif(context);
    if (gif != null) {
      sendGIFMessage(gifUrl: gif.url!);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboardcontainer() => focusNode.unfocus();

  void toggleEmojiKeybordContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboardcontainer();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    _messagecontroller.dispose();
    _soundRecorder!.closeRecorder();
    isRecordinginit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveHeight(kDefaultPadding),
            vertical: responsiveHeight(kDefaultPadding / 2),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                color: const Color(0xFF087949).withOpacity(0.08),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: responsiveHeight(kDefaultPadding * 0.75)),
                    height: responsiveHeight(50),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(responsiveHeight(40)),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: toggleEmojiKeybordContainer,
                          child: Icon(
                            Icons.sentiment_satisfied_alt_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          ),
                        ),
                        SizedBox(
                          width: responsiveHeight(kDefaultPadding / 5),
                        ),
                        GestureDetector(
                          onTap: selectGIF,
                          child: Icon(
                            Icons.gif,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          ),
                        ),
                        SizedBox(
                          width: responsiveHeight(kDefaultPadding / 5),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: focusNode,
                            controller: _messagecontroller,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  isShowSendButton = true;
                                });
                              } else {
                                setState(() {
                                  isShowSendButton = false;
                                });
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "Type message",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: selectVideo,
                          child: Icon(
                            Icons.attach_file_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          ),
                        ),
                        SizedBox(
                          width: responsiveHeight(kDefaultPadding / 4),
                        ),
                        GestureDetector(
                          onTap: selectImage,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: responsiveHeight(10),
                ),
                GestureDetector(
                  onTap: sendtextMessage,
                  child: Container(
                    height: responsiveHeight(45),
                    width: responsiveHeight(45),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            BorderRadius.circular(responsiveHeight(25))),
                    child: Center(
                      child: Icon(
                        isShowSendButton
                            ? Icons.send
                            : isRecording
                                ? Icons.close
                                : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: responsiveHeight(287),
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messagecontroller.text =
                          _messagecontroller.text + emoji.emoji;
                    });

                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
