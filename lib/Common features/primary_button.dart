import 'package:chatters_town/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(kDefaultPadding * 0.75),
  });

  final String text;
  final VoidCallback press;
  final color;
  final EdgeInsets padding;
  final width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      padding: padding,
      color: color,
      minWidth: width,
      onPressed: press,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
