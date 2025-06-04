import 'package:flutter/material.dart';
import 'package:usb_arduino/app/constants.dart';

ThemeData theme() {
  return ThemeData(
      scaffoldBackgroundColor: mBackgroundColor,
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity);
}

InputDecorationTheme inputDecorationTheme() {
  return const InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}

TextTheme textTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: mSubtitleColor),
    bodyMedium: TextStyle(color: mSubtitleColor),
  );
}
