// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/widgets/appColors.dart';
import 'detailController.dart';
import 'package:my_app/screens/aiPlanning/SavingService.dart';

class PlanDetails extends StatelessWidget {
  final DetailController detailController = Get.put(DetailController());
  final SavingsService savingsService = Get.put(SavingsService());

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    double appBarHeight = deviceWidth * 0.28;

    final Map<String, dynamic>? plan = Get.arguments as Map<String, dynamic>?;

    if (plan == null) {
      return const Scaffold(
        body: Center(child: Text('No plan details available.')),
      );
    }

    String aim = plan['aim'] ?? 'No Aim';
    double price = plan['price'] ?? 0.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () => Get.toNamed('/planning'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            aim,
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: AppColors.defaultColor,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16.0),
          Text(
            'Price: \$${price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          const Divider(
            color: AppColors.defaultColor,
            thickness: 2,
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: context.deviceHeight * 0.18,
            child: Obx(() {
              final expenses = detailController.expenses;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 2,
                ),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final category = expenses.keys.elementAt(index);
                  final amount = expenses[category] ?? 0.0;
                  return _buildCategoryCard(
                      category, '\$${amount.toStringAsFixed(2)}');
                },
              );
            }),
          ),
          const SizedBox(height: 8.0),
          const Divider(
            color: AppColors.defaultColor,
            thickness: 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'Plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(() {
            final expenses = detailController.expenses;
            final Map<String, double> nonNullableExpenses = {
              for (var entry in expenses.entries)
                if (entry.value != null) entry.key: entry.value!
            };

            final double totalExpenses = nonNullableExpenses.values
                .fold(0.0, (sum, amount) => sum + amount);

            final String highestCategory =
                savingsService.findHighestSpendingCategory(nonNullableExpenses);
            final double highestSpending =
                nonNullableExpenses[highestCategory] ?? 0.0;

            const double targetPercentage = 10.0;

            final savingsData = savingsService.calculateSavings(
              targetPercentage,
              highestSpending,
            );

            final savings = savingsData['savings'] ?? 0.0;
            final monthsToGoal =
                savings > 0 ? price / savings : double.infinity;

            final savingsMessage = savingsService.getSavingsMessage(
              highestCategory,
              highestSpending,
              totalExpenses,
              targetPercentage,
              savings,
              monthsToGoal,
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                savingsMessage,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, String value) {
    Color background =
        category == 'Income' ? Colors.green[700]! : Colors.red[700]!;
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: background,
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 1.0),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
