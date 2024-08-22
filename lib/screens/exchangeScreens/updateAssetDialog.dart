// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/screens/exchangeScreens/assetController.dart';

void showUpdateDia(BuildContext context, String oldAssetName, double oldAmount,
    String oldIcon) {
  final TextEditingController amountCont =
      TextEditingController(text: oldAmount.toString());
  String? selectedIcon = oldIcon;
  final AssetController assetController = Get.find();
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
          child: Text('Update Asset'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Asset Name',
                enabled: false,
              ),
              controller: TextEditingController(text: oldAssetName),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter New Amount'),
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
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  onPressed: () async {
                    final amountText = amountCont.text.trim();
                    final amount = double.tryParse(amountText) ?? 0.0;

                    if (amount > 0 && selectedIcon != null) {
                      try {
                        await assetController.updateAsset(
                          oldAssetName,
                          oldAssetName,
                          amount,
                          selectedIcon!,
                        );
                        Get.snackbar('Success', 'Asset updated successfully!',
                            snackPosition: SnackPosition.BOTTOM);
                        Get.back();
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to update asset: $e',
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    } else {
                      Get.snackbar('Error', 'Please fill in all fields',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: const Text(
                    'Update Asset',
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
