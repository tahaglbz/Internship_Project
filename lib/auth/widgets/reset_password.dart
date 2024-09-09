// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/appColors.dart';
import '../authservice.dart';

Future<void> showResetPasswordBottomSheet(BuildContext context) async {
  final AuthService _authService = Get.put(AuthService());

  return await showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(
                color: AppColors.defaultColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              'Please enter your email address',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _authService.emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.defaultColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.defaultColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final String email =
                        _authService.emailController.text.trim();
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      Get.snackbar('Sent', 'Reset email sent');
                      Navigator.of(context).pop();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-email' ||
                          e.email == null ||
                          e.email!.isEmpty) {
                        Get.snackbar('Error', 'Please enter a valid email');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.defaultColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reset Password'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
