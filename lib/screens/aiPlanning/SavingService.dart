import 'package:get/get.dart';

class SavingsService extends GetxService {
  Map<String, double?> calculateSavings(
      double targetPercentage, double highestSpending) {
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
      switch (highestCategory) {
        case 'Electricity':
          return 'Your electricity bill makes up ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'By reducing it by ${targetPercentage.toStringAsFixed(1)}%, you can save \$${savings.toStringAsFixed(2)} per month. '
              'This would help you reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Water':
          return 'Water usage is ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'By cutting it by ${targetPercentage.toStringAsFixed(1)}%, you can save \$${savings.toStringAsFixed(2)} monthly. '
              'This puts you on track to reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Natural Gas':
          return 'Natural gas accounts for ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'Reducing it by ${targetPercentage.toStringAsFixed(1)}% would save you \$${savings.toStringAsFixed(2)} per month, '
              'helping you reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Internet':
          return 'Internet costs represent ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'Cutting back by ${targetPercentage.toStringAsFixed(1)}% can save you \$${savings.toStringAsFixed(2)} per month. '
              'You\'ll achieve your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months with this adjustment.';
        case 'Rent':
          return 'Rent takes up ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'A ${targetPercentage.toStringAsFixed(1)}% reduction could save you \$${savings.toStringAsFixed(2)} per month, '
              'bringing you closer to your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Education':
          return 'Education expenses are ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your spending. '
              'Reducing these by ${targetPercentage.toStringAsFixed(1)}% can save you \$${savings.toStringAsFixed(2)} monthly. '
              'You\'ll reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months with this saving.';
        case 'Transport':
          return 'Transportation costs make up ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'A ${targetPercentage.toStringAsFixed(1)}% cutback could save you \$${savings.toStringAsFixed(2)} per month. '
              'This adjustment will help you reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Shopping':
          return 'Shopping accounts for ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'Reducing it by ${targetPercentage.toStringAsFixed(1)}% would save you \$${savings.toStringAsFixed(2)} monthly, '
              'bringing you closer to your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Health':
          return 'Health-related expenses are ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your spending. '
              'By reducing them by ${targetPercentage.toStringAsFixed(1)}%, you can save \$${savings.toStringAsFixed(2)} per month, '
              'helping you reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Entertainment':
          return 'Entertainment makes up ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'Cutting back by ${targetPercentage.toStringAsFixed(1)}% could save you \$${savings.toStringAsFixed(2)} monthly. '
              'This will help you reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Other':
          return 'Miscellaneous expenses account for ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your spending. '
              'By reducing these by ${targetPercentage.toStringAsFixed(1)}%, you can save \$${savings.toStringAsFixed(2)} per month. '
              'You\'ll reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months with this adjustment.';
        default:
          return 'Your $highestCategory spending is ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'By reducing it by ${targetPercentage.toStringAsFixed(1)}%, you can save an extra \$${savings.toStringAsFixed(2)} per month. '
              'With this change, you will reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
      }
    }
  }
}
