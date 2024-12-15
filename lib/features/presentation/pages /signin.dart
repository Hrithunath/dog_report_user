import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stray_dog_report/core/validator.dart';
import 'package:stray_dog_report/features/data/provider/auth.dart';
import 'package:stray_dog_report/features/presentation/pages%20/forgot_password.dart';
import 'package:stray_dog_report/features/presentation/pages%20/home.dart';
import 'package:stray_dog_report/features/presentation/pages%20/home_screen.dart';
import 'package:stray_dog_report/features/presentation/pages%20/signup.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_button.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_snackbar.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_text.dart';
import 'package:stray_dog_report/features/presentation/widget/custom_textformfeild.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the stream is active
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is signed in, navigate to the HomePage
        if (snapshot.hasData && snapshot.data != null) {
          return const HomePage();
        }

        // If the user is not signed in, navigate to the Signin page
        return Signin();
      },
    );
  }
}

class Signin extends StatelessWidget {
  Signin({super.key});
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextCustom(
              text: 'Welcome to Dog Report',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            const TextCustom(
              text: 'Sign in to continue',
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
                      keyboardType: TextInputType.text,
                      controller: passWordController,
                      label: 'Password',
                      validator: (value) => Validator.validatePassword(value),
                    ),
                  ],
                ),
              ),
            ),
            ButtonCustomized(
              text: "Sign in",
              color: Colors.blue,
              width: 140,
              height: 50,
              borderRadius: 50,
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  try {
                    await context.read<AuthProviders>().signin(
                          emailController.text.trim(),
                          passWordController.text.trim(),
                        );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomePage()));
                  } catch (e) {
                    showSnackBarMessage(
                        context, 'Error signing in: $e', Colors.red);
                  }
                }
              },
            ),
            const TextCustom(text: 'OR'),
            const SizedBox(height: 15),
            TextCustom(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ForgotPassword())),
              text: 'Forgot Password?',
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextCustom(text: 'Don’t have a account?'),
                TextCustom(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Signup())),
                  text: 'Register',
                  color: Colors.blue,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
