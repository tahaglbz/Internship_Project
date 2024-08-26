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
            Text(
              'Enter New Amount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newAmount = amountController.text;
                if (newAmount.isNotEmpty) {
                  onSubmit(newAmount);
                  Navigator.of(context).pop(); // BottomSheet'i kapat
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}
