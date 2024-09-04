import 'package:get/get.dart';

class SavingsService extends GetxService {
  Map<String, double?> calculateSavings(
      double targetPercentage, double highestSpending) {
    // Calculate the savings amount by reducing the highest spending by the target percentage
    double savings = (highestSpending * (targetPercentage / 100));

    return {
      'savings': savings,
    };
  }

  String findHighestSpendingCategory(Map<String, double> expenses) {
    return expenses.entries
        .where((entry) => entry.key != 'Income')
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
