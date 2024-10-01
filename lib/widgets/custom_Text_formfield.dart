import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentapp_provider_hive/styles/styles.dart';

// ignore: must_be_immutable
class CustomTextFormfield extends StatelessWidget {
  TextEditingController controller;
  String? hintText;
  String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  CustomTextFormfield(
      {super.key,
      required this.controller,
      this.validator,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
          filled: false,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          errorStyle: const TextStyle(color: Colors.red),
        ),
        style: const TextStyle(color: iconsColor),
        validator: validator,
        inputFormatters: inputFormatters);
  }
}
