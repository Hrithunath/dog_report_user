import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: color,
    ),
  );
}
