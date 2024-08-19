// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/auth/firestore/firestoreService.dart';

FirestoreService firestoreService = FirestoreService();

Future<void> showPaymentDialog(BuildContext context, String userId, String aim,
    double amount, VoidCallback onConfirmed) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Payment'),
        content: const Text('Did you paid?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              await firestoreService.updateCredit(userId, aim, amount);
              onConfirmed();
              Get.back();
            },
          ),
        ],
      );
    },
  );
}
