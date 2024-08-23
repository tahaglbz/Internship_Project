// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/auth/firestore/firestoreService.dart';

Future<void> showAmountDialog(
    BuildContext context, String symbol, double coinPrice) async {
  final TextEditingController amountController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Amount for $symbol'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              final double newAmount =
                  double.tryParse(amountController.text.trim()) ?? 0.0;
              final double newValueInUsd = newAmount * coinPrice;

              try {
                await firestoreService.updateAssetAmount(
                  symbol,
                  newAmount,
                  newValueInUsd,
                );
                Get.back();
              } catch (e) {
                // Handle any errors that may occur
                print('Error updating asset amount: $e');
              }
            },
          ),
        ],
      );
    },
  );
}
