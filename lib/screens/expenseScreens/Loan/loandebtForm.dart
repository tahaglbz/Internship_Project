// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:my_app/screens/expenseScreens/Loan/loanController.dart';

import '../../../widgets/appColors.dart';

class LoanDebt extends StatefulWidget {
  const LoanDebt({super.key});

  @override
  State<LoanDebt> createState() => _LoanDebtState();
}

class _LoanDebtState extends State<LoanDebt> {
  final List<Map<String, String>> icons = [
    {'icon': 'lib/assets/category/user.png', 'label': 'Personal'},
    {'icon': 'lib/assets/category/atm-card.png', 'label': 'Credit Card'},
    {'icon': 'lib/assets/category/car.png', 'label': 'Car'},
    {'icon': 'lib/assets/category/homeCredit.png', 'label': 'Home'},
    {'icon': 'lib/assets/category/business.png', 'label': 'Business'},
    {'icon': 'lib/assets/category/educationCredit.png', 'label': 'Education'},
    {'icon': 'lib/assets/category/farmer.png', 'label': 'Farmer'},
    {'icon': 'lib/assets/category/investment.png', 'label': 'Investment'},
    {'icon': 'lib/assets/category/credit.png', 'label': 'Exchange'},
    {'icon': 'lib/assets/money.png', 'label': 'Other'},
  ];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final controller = Get.put(LoanController());
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOAN DEBT',
                          style: GoogleFonts.adamina(
                            color: AppColors.color2,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: controller.bankNameController,
                          hintText: 'Enter the bank name',
                          labelText: 'Bank Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the bank name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: controller.creditAim,
                          hintText: 'Enter credit purpose',
                          labelText: 'Credit Purpose',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter purpose';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        Obx(() => DropdownButton<String>(
                              value: controller.selectedIcon.value,
                              hint: const Text('Select a credit category'),
                              items: icons.map((iconData) {
                                return DropdownMenuItem<String>(
                                  value: iconData['icon'],
                                  child: Row(
                                    children: [
                                      Image.asset(iconData['icon']!,
                                          height: 24, width: 24),
                                      const SizedBox(width: 8),
                                      Text(iconData['label']!),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: controller.selectIcon,
                            )),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: controller.remainingDebt,
                          hintText: 'Enter remaining debt',
                          labelText: 'Remaining Debt',
                          keyboardType: const TextInputType.numberWithOptions(),
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter remaining debt';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'How many instalment are left?',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.color2),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(() => NumberPicker(
                              minValue: 1,
                              maxValue: 120,
                              axis: Axis.horizontal,
                              selectedTextStyle: TextStyle(
                                  color: AppColors.color1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                              value: controller.selectedInstalment.value,
                              onChanged: (value) {
                                controller.selectedInstalment.value = value;
                              },
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildTextField(
                          controller: controller.monthlyPayment,
                          hintText: 'enter monthly payment',
                          labelText: 'Monthly Payment',
                          keyboardType: const TextInputType.numberWithOptions(),
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter monthly payment';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => Text(
                                    controller.selectedDate.value == null
                                        ? 'No date chosen!'
                                        : 'Date: ${DateFormat.yMd().format(controller.selectedDate.value!)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
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
                                'Choose final payment',
                                style: TextStyle(
                                  color: AppColors.color2,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.color1,
                          ),
                          onPressed: () {
                            controller.saveCredit();
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ]),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
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
