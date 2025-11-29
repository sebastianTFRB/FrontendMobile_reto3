import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final IconData? icon;
  final Widget? suffixIcon;

  const CustomInput({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.icon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.red) : null,
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.3), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2),
        ),
      ),
    );
  }
}
