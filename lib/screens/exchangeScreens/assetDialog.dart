import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/auth/firestore/firestoreService.dart';

void showAssetDialog(BuildContext context) {
  final TextEditingController assetnameCont = TextEditingController();
  final TextEditingController amountCont = TextEditingController();
  String? selectedIcon;
  final firestoreService = FirestoreService(); // Initialize FirestoreService
  final List<Map<String, String>> icons = [
    {'icon': 'lib/assets/ingots.png', 'label': 'Gold'},
    {'icon': 'lib/assets/turkish-lira.png', 'label': 'TL'},
    {'icon': 'lib/assets/euro-currency-symbol.png', 'label': 'EUR'},
    {'icon': 'lib/assets/dollar-symbol.png', 'label': 'USD'},
    {'icon': 'lib/assets/stock.png', 'label': 'Stock'},
    {'icon': 'lib/assets/money.png', 'label': 'Other'},
  ];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: Text('Add Assets'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter Asset Name',
              ),
              controller: assetnameCont,
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter Amount'),
              keyboardType: const TextInputType.numberWithOptions(),
              controller: amountCont,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedIcon,
              hint: const Text('Select an icon'),
              items: icons.map((iconData) {
                return DropdownMenuItem<String>(
                  value: iconData['icon'],
                  child: Row(
                    children: [
                      Image.asset(iconData['icon']!, height: 24, width: 24),
                      const SizedBox(width: 8),
                      Text(iconData['label']!),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                selectedIcon = value;
                // Rebuild the dialog to reflect the selected icon
                (context as Element).markNeedsBuild();
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.lightGreen),
                    )),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  onPressed: () async {
                    final assetName = assetnameCont.text.trim();
                    final amountText = amountCont.text.trim();
                    final amount = double.tryParse(amountText) ?? 0.0;

                    if (assetName.isNotEmpty &&
                        amount > 0 &&
                        selectedIcon != null) {
                      try {
                        await firestoreService.saveExcAsset(
                          assetName,
                          amount,
                          selectedIcon!,
                        );
                        Get.snackbar('Success', 'Asset added successfully!',
                            snackPosition: SnackPosition.BOTTOM);
                        Navigator.of(context).pop();
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to add asset: $e',
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    } else {
                      Get.snackbar('Error', 'Please fill in all fields',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: const Text(
                    'Add Asset',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
