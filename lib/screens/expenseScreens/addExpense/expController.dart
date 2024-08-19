// lib/controllers/expense_controller.dart

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/firestore/firestoreService.dart';

class ExpenseController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  var selectedDate = Rx<DateTime?>(null);
  var selectedIcon = Rx<String?>(null);
  final FirestoreService _firestoreService = FirestoreService();

  void selectDate(DateTime? date) {
    selectedDate.value = date;
  }

  void selectIcon(String? icon) {
    selectedIcon.value = icon;
  }

  Future<void> saveExpense() async {
    if (formKey.currentState!.validate()) {
      if (selectedDate.value == null) {
        Get.snackbar('Error', 'Please select a date.');
        return;
      }
      if (selectedIcon.value == null) {
        Get.snackbar('Error', 'Please select an icon.');
        return;
      }

      String expName = nameController.text.trim();
      double amount = double.parse(amountController.text.trim());
      String imageUrl = selectedIcon.value!;
      DateTime lastPaymentDate = selectedDate.value!;

      try {
        await _firestoreService.saveExpense(
          expName,
          amount,
          imageUrl,
          lastPaymentDate,
        );
        Get.snackbar('Success', 'Expense saved successfully.');
      } catch (e) {
        Get.snackbar('Error', 'Failed to save expense: $e');
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
