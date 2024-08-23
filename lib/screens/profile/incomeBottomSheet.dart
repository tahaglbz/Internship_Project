import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/firestore/firestoreService.dart';

Future<void> showIncomeBottomSheet(BuildContext context) async {
  TextEditingController textController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final FirestoreService firestoreService = Get.find<FirestoreService>();

  return await showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Enter Income Name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Income Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    String incomeName = textController.text.trim();
                    double amount =
                        double.tryParse(amountController.text.trim()) ?? 0.0;
                    DateTime updatedDate = DateTime.now();

                    print("Income Name: $incomeName");
                    print("Amount: $amount");
                    print("Updated Date: $updatedDate");

                    if (incomeName.isNotEmpty && amount > 0) {
                      await firestoreService.saveIncome(
                          incomeName, amount, updatedDate);
                      Get.snackbar('Success', 'Income added successfully');
                      Get.offAllNamed('/profile');
                    } else {
                      Get.snackbar(
                          'Error', 'Please enter valid income name and amount');
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
