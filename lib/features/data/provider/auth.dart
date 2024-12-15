import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProviders extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthProviders() {
    // Listens to authentication state changes
    auth.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  // Signup function to create a new user
  // Signup function to create a new user
  Future<void> signup(String email, String password, String name) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // If the user was created successfully, save minimal user data in Firestore
      if (userCredential.user != null) {
        await firestore.collection('userss').doc(userCredential.user?.uid).set({
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("User signed up successfully");
      }
    } catch (e) {
      // Print the error and rethrow it for higher-level handling
      print("Error during signup: $e");
      rethrow;
    }
  }

  // Signin function to authenticate an existing user
  Future<void> signin(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print("User signed in successfully");
    } catch (e) {
      // Print the error and rethrow it
      print("Error during signin: $e");
      rethrow;
    }
  }

  // Signout function to log the user out
  Future<void> signout() async {
    try {
      await auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error during signout: $e");
      rethrow;
    }
  }

  // Check if user is signed in
  bool isSignin() {
    return auth.currentUser != null;
  }

  // Get the current signed-in user's email
  String? currentUserEmail() {
    return auth.currentUser?.email;
  }

  // Send a password reset email to the user
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent");
    } catch (e) {
      print("Error during password reset: $e");
      rethrow;
    }
  }
}
