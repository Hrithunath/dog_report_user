import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_dog_report/core/validator.dart';
import 'package:stray_dog_report/features/data/provider/auth.dart';
import 'package:stray_dog_report/features/presentation/pages%20/home.dart';
import 'package:stray_dog_report/features/presentation/pages%20/home_screen.dart';
import 'package:stray_dog_report/features/presentation/pages%20/signin.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_button.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_snackbar.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_text.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_textformfeild.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextCustom(
              text: 'Let’s Get Started',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            const TextCustom(
              text: 'Create a new Account ',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Textformfeildcustom(
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      label: 'Full Name',
                      validator: (value) => Validator.validateUsername(value),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Textformfeildcustom(
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      label: 'Email',
                      validator: (value) => Validator.validateEmail(value),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Textformfeildcustom(
                      prefixIcon: Icons.lock,
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordController,
                      label: 'Password',
                      validator: (value) => Validator.validatePassword(value),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Textformfeildcustom(
                        prefixIcon: Icons.lock,
                        keyboardType: TextInputType.emailAddress,
                        controller: passwordAgainController,
                        label: 'Password Again',
                        validator: (value) => Validator.validateAgainPassword(
                            value, passwordController.text)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonCustomized(
              text: "Sign up",
              color: Colors.blue,
              width: 140,
              height: 50,
              borderRadius: 50,
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  try {
                    // Pass the name to the signup method
                    await context.read<AuthProviders>().signup(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          nameController.text.trim(), // Added name parameter
                        );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomePage()));
                  } catch (e) {
                    showSnackBarMessage(
                        context, 'Error signing up: $e', Colors.red);
                  }
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextCustom(text: 'Have an account?'),
                TextCustom(
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Signin())),
                    text: 'Sign in'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
