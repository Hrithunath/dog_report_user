import 'package:flutter/material.dart';

class Textformfeildcustom extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  IconData prefixIcon;
  IconData sufixIcon;
  final bool enabled;
  Textformfeildcustom({
    super.key,
    this.label,
    this.prefixIcon = Icons.search,
    this.sufixIcon = Icons.search,
    this.hintText,
    this.keyboardType,
    this.controller,
    this.validator,
    this.fillColor,
    this.onChanged,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: enabled,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 235, 233, 233)),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        hintText: hintText,
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 175, 165, 165)),
        prefixIcon: Icon(prefixIcon),
        fillColor: fillColor,
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                color: Color.fromARGB(255, 192, 42, 219), width: 1.0)),
      ),
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
    );
  }
}
