import 'package:flutter/material.dart';
import 'package:usb_arduino/screens/dashboard_page.dart';
import 'package:usb_arduino/screens/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen()
};
