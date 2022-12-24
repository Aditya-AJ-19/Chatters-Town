import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(bool isCrop) async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedImage == null) {
    return null;
  }

  if (isCrop) {
    final file = File(pickedImage.path);
    return cropSquareImage(file);
  } else {
    return File(pickedImage.path);
  }
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickVideo != null) {
      video = File(pickVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

Future<File> cropSquareImage(File imageFile) async {
  final CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ],
    // uiSettings: [
    //   AndroidUiSettings(
    //       toolbarTitle: 'Cropper',
    //       toolbarColor: Colors.deepOrange,
    //       toolbarWidgetColor: Colors.white,
    //       initAspectRatio: CropAspectRatioPreset.original,
    //       lockAspectRatio: false),
    //   IOSUiSettings(
    //     title: 'Cropper',
    //   ),
    // ],
  );

  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    return imageFile;
  }
}

// Future<GiphyGif?> pickGIF(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     gif = await Giphy.getGif(
//       context: context,
//       apiKey: 'IdkqA3NOqNRGWrNsaLlCIxcz3u8ySDE8',
//     );
//   } catch (e) {
//     showSnackBar(context: context, content: e.toString());
//   }
//   return gif;
// }

Future<GiphyGif?> pickGif(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await GiphyGet.getGif(
      context: context,
      apiKey: 'IdkqA3NOqNRGWrNsaLlCIxcz3u8ySDE8',
    );
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}
