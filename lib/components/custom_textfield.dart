import 'package:flutter/material.dart';
import 'package:usb_arduino/utils/validators.dart';

import '../app/constants.dart';

class CustomTextField extends StatefulWidget {
  final String? initialValue;
  final String? labelText, hintText;
  final TextEditingController? controller;
  final List<String? Function(String?)>? validators;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final bool obscureText;
  final bool readOnly;
  final Function()? onTap;
  final Widget? prefixicon, suffixicon;
  final String? prefixText;
  final int? maxLines, maxLength;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Color? color;
  final Gradient? gradient;
  final String? titleText;
  final double? width;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.controller,
    this.validators,
    this.onChanged,
    this.onSaved,
    this.obscureText = false,
    this.readOnly = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onTap,
    this.prefixicon,
    this.suffixicon,
    this.prefixText,
    this.maxLines = 1,
    this.maxLength = 128,
    this.color,
    this.gradient,
    this.titleText,
    this.width,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.titleText!,
          style: const TextStyle(
              color: mTextColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: mFillColor,
          ),
          child: TextFormField(
            readOnly: widget.readOnly,
            focusNode: widget.focusNode,
            initialValue: widget.initialValue,
            controller: widget.controller,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            onTap: widget.onTap,
            maxLines: widget.maxLines,
            textInputAction: widget.textInputAction,
            maxLength: widget.maxLength,
            style: const TextStyle(color: mTextColor),
            validator: (value) => Validator.compose(value, widget.validators),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 5, left: 10),
              filled: true,
              fillColor: mTransparent,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: mHintTextColor, fontSize: 18),
              labelText: widget.labelText,
              prefixIcon: widget.prefixicon,
              suffixIcon: widget.suffixicon,
              prefixText: widget.prefixText,
              prefixStyle: const TextStyle(color: mTitleColor, fontSize: 16),
              errorMaxLines: 2,
              counter: const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

class OutlinedDropdown<T> extends StatelessWidget {
  final T? value;
  final String? labelText, hintText;
  final List<String? Function(String?)>? validators;
  final Function(T?)? onChanged;
  final Function(T?)? onSaved;
  final Function()? onTap;
  final Widget? prefixIcon, suffixIcon;
  final String? prefixText;
  final List<DropdownMenuItem<T>>? items;
  final Color? color;
  final Gradient? gradient;
  final String? titleText;
  final double? width;

  const OutlinedDropdown({
    super.key,
    this.value,
    this.labelText,
    this.hintText,
    this.validators,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.items,
    this.gradient,
    this.titleText,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color selectedColor = (value != null) ? mWhiteColor : mBlackColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleText!,
              style: const TextStyle(
                color: mTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: DropdownButtonFormField<T>(
                dropdownColor: const Color(0xFF2B2C2E),
                value: value,
                validator: (value) {
                  if (T == String) {
                    return Validator.compose(value as String?, validators);
                  }
                  return null;
                },
                onChanged: onChanged,
                onSaved: onSaved,
                onTap: onTap,
                items: items,
                style: const TextStyle(color: mWhiteColor),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                  labelText: labelText,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                      color: mHintTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  prefixText: prefixText,
                  prefixStyle:
                      const TextStyle(color: mTitleColor, fontSize: 16),
                  errorMaxLines: 2,
                  counter: const SizedBox.shrink(),
                ),
                isExpanded: true,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
