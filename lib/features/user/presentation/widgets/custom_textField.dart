import 'package:flutter/material.dart';
import 'package:learning_management_system/core/utils/validations.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool Function(String) validate;
  const CustomTextField({
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.validate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.blue.shade800,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        prefixIcon: Icon(icon, color: Colors.blue.shade800),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade800),
        ),
      ),

      validator: (value) {
        if (hintText == "Enter your email") {
          return Validations.validateEmail(value!) ? null : "Invalid email";
        } else if (hintText == "Enter your password") {
          return Validations.validatePassword(value!)
              ? null
              : "Password must contains letters and numbers";
        } else if (hintText == "Enter your username") {
          return Validations.validateUserName(value)
              ? null
              : "Must be more than 3 characters";
        }
        return null;
      },
    );
  }
}
