import 'package:get/get.dart';

class SavingsService extends GetxService {
  Map<String, double?> calculateSavings(double targetPercentage,
      String highestCategory, double highestSpending, double totalExpenses) {
    // Check if totalExpenses is greater than zero to avoid division by zero
    if (totalExpenses <= 0) {
      return {
        'savings': 0.0,
        'monthsToGoal': 0.0,
      };
    }

    // Calculate the savings amount by reducing the highest spending by the target percentage
    double savings = (highestSpending * (targetPercentage / 100));
    double adjustedTotalExpenses = totalExpenses - highestSpending + savings;

    // Assume a savings goal
    double savingsGoal = 1000.0; // Replace with the actual savings goal
    double currentSavings = totalExpenses - adjustedTotalExpenses;

    // Calculate the number of months to reach the savings goal
    double monthsToGoal = (savingsGoal - currentSavings) / savings;

    return {
      'savings': savings,
      'monthsToGoal': monthsToGoal > 0 ? monthsToGoal : 0.0,
    };
  }

  String findHighestSpendingCategory(Map<String, double> expenses) {
    return expenses.entries
        .where((entry) => entry.key != 'Income' && entry.value != null)
        .reduce((a, b) => a.value! > b.value! ? a : b)
        .key;
  }
}
