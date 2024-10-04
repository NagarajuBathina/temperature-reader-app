import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usb_arduino/app/colors.dart';
import 'package:usb_arduino/dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: appTheme, home: const DashboardScreen());
  }
}

class GradientBackgroundColor extends StatelessWidget {
  final Widget child;
  const GradientBackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        mSecondaryColor,
        mPrimaryColor,
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: child,
    );
  }
}
