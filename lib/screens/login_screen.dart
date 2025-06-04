import 'package:flutter/material.dart';
import 'package:usb_arduino/app/constants.dart';
import 'package:usb_arduino/app/size_config.dart';
import 'package:usb_arduino/components/custom_button.dart';
import 'package:usb_arduino/components/custom_text.dart';
import 'package:usb_arduino/components/custom_textfield.dart';
import 'package:usb_arduino/screens/dashboard_page.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginscreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(text: 'Login'),
            SizedBox(height: Sizeconfig.screenHeight(context) * 0.06),
            const CustomTextField(
                titleText: 'Mobile Number', hintText: 'Enter mobile number'),
            SizedBox(height: Sizeconfig.screenHeight(context) * 0.04),
            CustomButton(
              buttonText: 'Send OTP',
              isloading: false,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const DashboardScreen();
                },
              )),
            ),
            SizedBox(height: Sizeconfig.screenHeight(context) * 0.04),
            const Align(
              child: CustomText(text: 'Login'),
            )
          ],
        ),
      )),
    );
  }
}
