import 'package:flutter/material.dart';
import 'package:usb_arduino/app/constants.dart';
import 'package:usb_arduino/app/size_config.dart';

class CustomButton extends StatefulWidget {
  final String buttonText;
  final Function()? onTap;
  final bool isloading;
  const CustomButton(
      {super.key,
      required this.buttonText,
      this.onTap,
      required this.isloading});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: Sizeconfig.screenHeight(context) * 0.065,
        decoration: BoxDecoration(
          color: mPrimaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(mPrimaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: widget.isloading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: mBlackColor,
                ))
              : Text(
                  widget.buttonText,
                  style: const TextStyle(
                      color: Color(0xFF030E1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
        ));
  }
}
