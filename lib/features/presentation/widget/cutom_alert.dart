import 'package:flutter/material.dart';

Future<void> showAlertDialog(BuildContext context, String title, String content,
    VoidCallback onConfirm) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text("Remove"),
          ),
        ],
      );
    },
  );
}
