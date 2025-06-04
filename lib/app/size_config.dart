import 'package:flutter/material.dart';

class Sizeconfig {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double blockSizeHorizontal(BuildContext context, double percent) {
    return screenWidth(context) * percent / 100;
  }

  static double bloackSizeVertical(BuildContext context, double percent) {
    return screenHeight(context) * percent / 100;
  }
}
