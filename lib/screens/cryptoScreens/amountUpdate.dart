// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/auth/firestore/firestoreService.dart';

void showAmountDialog(BuildContext context, String symbol) {
  final TextEditingController amountCont = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: Text('Update Asset Amount'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Please enter new amount'),
            const SizedBox(height: 10),
            TextField(
              controller: amountCont,
              decoration: const InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color.fromARGB(255, 8, 1, 134),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    double newAmount;
                    try {
                      newAmount = double.parse(amountCont.text.trim());
                      await firestoreService.updateAsset(symbol, newAmount);
                      Get.back();
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Invalid amount entered.'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 8, 1, 134),
                      foregroundColor: Colors.white),
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
