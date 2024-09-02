// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showAmountBottomSheet(BuildContext context, Function(String) onSubmit) {
  TextEditingController amountController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter New Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newAmount = amountController.text;
                if (newAmount.isNotEmpty) {
                  onSubmit(newAmount);
                  Navigator.of(context).pop(); // BottomSheet'i kapat
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}
