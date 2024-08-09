// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final usernameController = TextEditingController();

  Future<void> signUp() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordConfirmController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      if (passwordController.text == passwordConfirmController.text) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
          Get.snackbar('Succes', 'Signing Up...');
          Get.toNamed('/login');
          Get.offAllNamed('/login');
        } on FirebaseAuthException catch (e) {
          Get.snackbar('Error', e.message ?? 'An error occured');
        }
      } else {
        Get.snackbar('Error', 'Please fill all fields');
      }
    }
  }
}
