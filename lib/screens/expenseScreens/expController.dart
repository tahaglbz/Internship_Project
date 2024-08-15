import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  var selectedDate = Rx<DateTime?>(null);
  var selectedIcon = Rx<String?>(null);

  void selectDate(DateTime? date) {
    selectedDate.value = date;
  }

  void selectIcon(String? icon) {
    selectedIcon.value = icon;
  }

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
