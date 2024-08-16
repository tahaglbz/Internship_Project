import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final bankNameController = TextEditingController();
  final remainingDebt = TextEditingController();
  final creditAim = TextEditingController();
  var selectedDate = Rx<DateTime?>(null);
  var selectedIcon = Rx<String?>(null);
  var selectedInstalment = Rx<int>(1);
  final monthlyPayment = TextEditingController();

  void selectDate(DateTime? date) {
    selectedDate.value = date;
  }

  void selectIcon(String? icon) {
    selectedIcon.value = icon;
  }

  @override
  void onClose() {
    bankNameController.dispose();
    remainingDebt.dispose();
    creditAim.dispose();
    super.onClose();
  }
}
