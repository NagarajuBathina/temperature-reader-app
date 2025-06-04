import 'package:flutter/material.dart';
import 'package:usb_arduino/app/constants.dart';

class CustomText extends StatefulWidget {
  final String text;
  const CustomText({super.key, required this.text});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: const TextStyle(
          color: mTextColor, fontWeight: FontWeight.bold, fontSize: 25),
    );
  }
}
