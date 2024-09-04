import 'package:get/get.dart';

class SavingsService extends GetxService {
  // Bu metod, tasarruf miktarını hesaplar
  Map<String, double?> calculateSavings(
      double targetPercentage, double highestSpending) {
    double savings = (highestSpending * (targetPercentage / 100));
    return {
      'savings': savings,
    };
  }

  // Bu metod, en yüksek harcama yapılan kategoriyi bulur
  String findHighestSpendingCategory(Map<String, double> expenses) {
    return expenses.entries
        .where((entry) => entry.key != 'Income')
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String getSavingsMessage(
      String highestCategory,
      double highestSpending,
      double totalExpenses,
      double targetPercentage,
      double savings,
      double monthsToGoal) {
    if (highestSpending == 0) {
      return 'You have no expenses recorded in $highestCategory category.';
    } else if (savings == 0) {
      return 'Reducing your spending in $highestCategory category by ${targetPercentage.toStringAsFixed(1)}% does not result in significant savings.';
    } else {
      return 'Your $highestCategory spending is ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
          'By reducing it by ${targetPercentage.toStringAsFixed(1)}%, you can save an extra \$${savings.toStringAsFixed(2)} per month. '
          'With this change, you will reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
    }
  }
}
