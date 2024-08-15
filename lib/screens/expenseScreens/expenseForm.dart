import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/expenseScreens/expController.dart';

import '../../widgets/appColors.dart';

class ExpenseForm extends StatefulWidget {
  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final List<Map<String, String>> icons = [
    {'icon': 'lib/assets/electricity-bill.png', 'label': 'Electricity'},
    {'icon': 'lib/assets/maintenance.png', 'label': 'Water'},
    {'icon': 'lib/assets/bill.png', 'label': 'Natural Gas'},
    {'icon': 'lib/assets/web.png', 'label': 'Internet'},
    {'icon': 'lib/assets/accounting-book.png', 'label': 'Education'},
    {'icon': 'lib/assets/battery.png', 'label': 'Transport'},
    {'icon': 'lib/assets/purchase.png', 'label': 'Shopping'},
    {'icon': 'lib/assets/health.png', 'label': 'Health'},
    {'icon': 'lib/assets/infulencer.png', 'label': 'Entertainment'},
    {'icon': 'lib/assets/debt.png', 'label': 'Other'},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpenseController());
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: deviceWidth,
      height: deviceHeight,
      decoration: BoxDecoration(
        gradient: AppColors.debtCardColors,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(10, 10),
              bottom: Radius.elliptical(10, 10),
            ),
          ),
          elevation: 22,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'ADD EXPENSE',
                      style: GoogleFonts.adamina(
                        color: AppColors.color2,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      controller: controller.nameController,
                      labelText: 'Expense Name',
                      hintText: 'Enter the expense name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an expense name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      controller: controller.amountController,
                      labelText: 'Amount',
                      hintText: 'Enter the amount',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => Text(
                                controller.selectedDate.value == null
                                    ? 'No date chosen!'
                                    : 'Date: ${DateFormat.yMd().format(controller.selectedDate.value!)}',
                              )),
                        ),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              controller.selectDate(pickedDate);
                            }
                          },
                          child: Text(
                            'Choose Date',
                            style: TextStyle(
                              color: AppColors.color1,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Obx(() => DropdownButton<String>(
                          value: controller.selectedIcon.value,
                          hint: const Text('Select an icon'),
                          items: icons.map((iconData) {
                            return DropdownMenuItem<String>(
                              value: iconData['icon'],
                              child: Row(
                                children: [
                                  Image.asset(iconData['icon']!,
                                      height: 24, width: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    iconData['label']!,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: controller.selectIcon,
                        )),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            if (controller.selectedDate.value == null) {
                              Get.snackbar('Error', 'Please choose a date.');
                            } else if (controller.selectedIcon.value == null ||
                                controller.selectedIcon.value!.isEmpty) {
                              Get.snackbar('Error', 'Please select an icon.');
                            } else {
                              Get.snackbar('Success', 'Processing...');
                              // Continue with form submission
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: AppColors.color2,
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.color2,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.color1, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.color1, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.color2, width: 3),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
