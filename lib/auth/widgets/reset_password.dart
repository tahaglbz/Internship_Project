import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authservice.dart';

void showResetPassDia(BuildContext context) {
  final AuthService _authService = Get.put(AuthService());
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
            child: Text(
          'Reset Password',
          style: TextStyle(color: Color.fromARGB(255, 8, 1, 134)),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Please enter your mail adress'),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _authService.emailController,
              decoration: const InputDecoration(
                  hintText: 'email',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 1, 134),
                  ))),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 8, 1, 134)),
              )),
          ElevatedButton(
              onPressed: () async {
                final String email = _authService.emailController.text.trim();
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);
                  Get.snackbar('Sent', 'Reset email sent');
                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-email' ||
                      e.email == null ||
                      e.email == "") {
                    Get.snackbar('Wrong', 'Please enter valid email');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 8, 1, 134),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset Password'))
        ],
      );
    },
  );
}
