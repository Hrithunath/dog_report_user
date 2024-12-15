import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_dog_report/core/validator.dart';
import 'package:stray_dog_report/features/data/provider/auth.dart';
import 'package:stray_dog_report/features/presentation/pages%20/signin.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_button.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_snackbar.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_text.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_textformfeild.dart';
import 'package:stray_dog_report/main.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextCustom(text: 'Recovery Password'),
            const SizedBox(
              height: 10,
            ),
            const TextCustom(
                text:
                    'Please, enter your email address. You will receive a link to create a new password via email'),
            Column(
              children: [
                Textformfeildcustom(
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  label: 'Email',
                  validator: (value) => Validator.validateEmail(value),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            ButtonCustomized(
              text: "Continue",
              color: Colors.blue,
              width: 140,
              height: 50,
              borderRadius: 50,
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  try {
                    await context
                        .read<AuthProviders>()
                        .resetPassword(emailController.text.trim());
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => Signin()));
                  } catch (e) {
                    showSnackBarMessage(
                        context, 'Error Reset Password: $e', Colors.red);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
