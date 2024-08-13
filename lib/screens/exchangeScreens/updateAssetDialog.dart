// lib/screens/exchangeScreens/updateAssetDialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/screens/exchangeScreens/assetController.dart';

void showUpdateDia(BuildContext context, String assetName) {
  final TextEditingController amountCont = TextEditingController();
  String? selectedIcon;
  final AssetController assetController = Get.find();
  final List<Map<String, String>> icons = [
    {'icon': 'lib/assets/ingots.png', 'label': 'Gold'},
    {'icon': 'lib/assets/turkish-lira.png', 'label': 'TL'},
    {'icon': 'lib/assets/euro-currency-symbol.png', 'label': 'EUR'},
    {'icon': 'lib/assets/dollar-symbol.png', 'label': 'USD'},
    {'icon': 'lib/assets/stock.png', 'label': 'Stock'},
    {'icon': 'lib/assets/money.png', 'label': 'Other'},
  ];

  // lib/screens/exchangeScreens/updateAssetDialog.dart

  void showUpdateDia(BuildContext context, String oldAssetName) {
    final TextEditingController assetnameCont = TextEditingController();
    final TextEditingController amountCont = TextEditingController();
    String? selectedIcon;
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
                decoration:
                    const InputDecoration(hintText: 'Enter New Asset Name'),
                controller: assetnameCont,
              ),
              const SizedBox(height: 20),
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
                  (context as Element).markNeedsBuild();
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                      onPressed: () => Get.back(), child: const Text('Cancel')),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 8, 1, 134)),
                    onPressed: () async {
                      final newAssetName = assetnameCont.text.trim();
                      final amountText = amountCont.text.trim();
                      final amount = double.tryParse(amountText) ?? 0.0;

                      if (newAssetName.isNotEmpty &&
                          amount > 0 &&
                          selectedIcon != null) {
                        try {
                          await assetController.updateAsset(
                            oldAssetName,
                            newAssetName,
                            amount,
                            selectedIcon!,
                          );
                          Get.snackbar('Success', 'Asset updated successfully!',
                              snackPosition: SnackPosition.BOTTOM);
                          Navigator.of(context).pop();
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
}
