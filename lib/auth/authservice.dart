// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isObscure = true.obs;

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }

  Future<void> signWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCred =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = userCred.user;
        if (user != null) {
          // Store user info in Firestore if necessary
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'name': user.displayName,
          });
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with Google: $e');
    }
  }

  Future<void> signUp() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordConfirmController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      if (passwordController.text == passwordConfirmController.text) {
        try {
          final signInMethods =
              await _auth.fetchSignInMethodsForEmail(emailController.text);
          if (signInMethods.isNotEmpty) {
            Get.snackbar('Error', 'Email is already in use');
            return;
          }

          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          final User? user = userCredential.user;

          if (user != null) {
            // Add user to Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'email': emailController.text,
              'username': usernameController.text,
              // Add any other fields you want to store
            });
            Get.snackbar('Success', 'Signing Up...');
            Get.offAllNamed('/login'); // Navigate to the login page
          }
        } on FirebaseAuthException catch (e) {
          Get.snackbar('Error', e.message ?? 'An error occurred');
        }
      } else {
        Get.snackbar('Error', 'Passwords do not match');
      }
    } else {
      Get.snackbar('Error', 'Please fill all fields');
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.toNamed('/mainmenu');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    }
  }
}
