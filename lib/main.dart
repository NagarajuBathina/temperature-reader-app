import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usb_arduino/app/theme.dart';
import 'package:usb_arduino/screens/login_screen.dart';

import './utils/routes.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      routes: routes,
      initialRoute: LoginScreen.routeName,
    );
  }
}

// class GradientBackgroundColor extends StatelessWidget {
//   final Widget child;
//   const GradientBackgroundColor({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [
//         mSecondaryColor,
//         mPrimaryColor,
//       ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
//       child: child,
//     );
//   }
// }
