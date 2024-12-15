import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_dog_report/features/data/provider/auth.dart';
import 'package:stray_dog_report/features/presentation/pages%20/signin.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_button.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_snackbar.dart';
import 'package:stray_dog_report/features/presentation/widget/cutom_alert.dart';

class Acount extends StatelessWidget {
  const Acount({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonCustomized(
          text: "Sign out",
          color: Colors.blue,
          width: 140,
          height: 50,
          borderRadius: 50,
          onPressed: () async {},
        ),
      ],
    );
  }
}
