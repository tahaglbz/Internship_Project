// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/firestore/firestoreService.dart';

class LoanController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final bankNameController = TextEditingController();
  final remainingDebt = TextEditingController();
  final creditAim = TextEditingController();
  final monthlyPayment = TextEditingController();

  var selectedDate = Rx<DateTime?>(null);
  var selectedIcon = Rx<String?>(null);
  var selectedInstalment = Rx<int>(1);
  final FirestoreService _firestoreService = FirestoreService();

  void selectDate(DateTime? date) {
    selectedDate.value = date;
  }

  void selectIcon(String? icon) {
    selectedIcon.value = icon;
  }

  Future<void> saveCredit() async {
    if (formKey.currentState!.validate()) {
      String bankName = bankNameController.text.trim();
      String aim = creditAim.text.trim();
      double remaining = double.parse(remainingDebt.text.trim());
      double monthlyPaymentValue =
          double.tryParse(monthlyPayment.text.trim()) ?? 0.0;
      int instalment = selectedInstalment.value;
      String imageUrl = selectedIcon.value!;
      DateTime lastPaymentDate = selectedDate.value!;

      try {
        await _firestoreService.saveCredit(
          bankName,
          aim,
          remaining,
          monthlyPaymentValue,
          instalment,
          imageUrl,
          lastPaymentDate,
        );
        Get.snackbar('Success', 'Credit saved successfully.');
      } catch (e) {
        Get.snackbar('Error', 'Failed to save credit: $e');
      }
    }
  }

  @override
  void onClose() {
    bankNameController.dispose();
    remainingDebt.dispose();
    creditAim.dispose();
    monthlyPayment
        .dispose(); // Bu satırı ekledim, çünkü monthlyPayment bir TextEditingController
    super.onClose();
  }
}
