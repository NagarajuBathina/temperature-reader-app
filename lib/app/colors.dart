import 'package:flutter/material.dart';

// Color assignments
Color mOrangeColor = const Color(0xFFFF5C01); // For FF5C01
Color mSecondaryColor = const Color.fromARGB(255, 73, 79, 96); // For 373D4B
Color mPrimaryColor = const Color.fromARGB(255, 35, 40, 55); // For 171B26
Color mWhiteColor = Colors.white;
Color mBlackColor = Colors.black;
Color mGreyColor = Colors.grey;
Color mGreenColor = Colors.green;
Color mRed = Colors.red;

// Define your ThemeData globally
final ThemeData appTheme = ThemeData(
    primaryColor: mPrimaryColor, // Set primary color globally
    // ignore: deprecated_member_use
    accentColor: mSecondaryColor, // Set accent color globally
    textTheme: TextTheme(
        // ignore: deprecated_member_use
        bodyText1: TextStyle(color: mWhiteColor) // Set text color globally
        ),
    iconTheme: IconThemeData(color: mWhiteColor),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(iconColor: MaterialStatePropertyAll(mWhiteColor))),
    buttonTheme: ButtonThemeData(
        buttonColor: mWhiteColor, // Set button color globally
        textTheme: ButtonTextTheme.primary));
