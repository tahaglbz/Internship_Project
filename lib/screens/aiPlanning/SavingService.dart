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
              'Consider turning off lights and appliances when not in use, and investing in energy-efficient bulbs and appliances. '
              'This would help you reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Water':
          return 'Water usage is ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'By cutting it by ${targetPercentage.toStringAsFixed(1)}%, you can save \$${savings.toStringAsFixed(2)} monthly. '
              'Try shorter showers, fixing leaks, and using water-efficient fixtures. '
              'This puts you on track to reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Natural Gas':
          return 'Natural gas accounts for ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'Reducing it by ${targetPercentage.toStringAsFixed(1)}% would save you \$${savings.toStringAsFixed(2)} per month. '
              'Lowering your thermostat in winter and insulating your home can help reduce costs. '
              'This adjustment will help you reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Internet':
          return 'Internet costs represent ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'Cutting back by ${targetPercentage.toStringAsFixed(1)}% can save you \$${savings.toStringAsFixed(2)} per month. '
              'Consider switching to a lower-cost plan or negotiating with your provider for a better rate. '
              'You\'ll achieve your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months with this adjustment.';
        case 'Rent':
          return 'Rent takes up ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'A ${targetPercentage.toStringAsFixed(1)}% reduction could save you \$${savings.toStringAsFixed(2)} per month. '
              'You might consider finding a roommate or moving to a less expensive place to reduce rent costs. '
              'This would bring you closer to your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Education':
          return 'Education expenses are ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your spending. '
              'Reducing these by ${targetPercentage.toStringAsFixed(1)}% can save you \$${savings.toStringAsFixed(2)} monthly. '
              'Consider applying for scholarships, using second-hand books, or taking online courses to cut down on costs. '
              'You\'ll reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months with this saving.';
        case 'Transport':
          return 'Transportation costs make up ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'A ${targetPercentage.toStringAsFixed(1)}% cutback could save you \$${savings.toStringAsFixed(2)} per month. '
              'Consider using public transport, carpooling, or biking instead of driving to save on fuel costs. '
              'This adjustment will help you reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Shopping':
          return 'Shopping accounts for ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your expenses. '
              'Reducing it by ${targetPercentage.toStringAsFixed(1)}% would save you \$${savings.toStringAsFixed(2)} monthly. '
              'Try sticking to a shopping list, avoiding impulse buys, and taking advantage of sales and discounts. '
              'This will help you reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Health':
          return 'Health-related expenses are ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your spending. '
              'By reducing them by ${targetPercentage.toStringAsFixed(1)}%, you can save \$${savings.toStringAsFixed(2)} per month. '
              'Consider opting for generic medications, utilizing preventive care, and maintaining a healthy lifestyle to reduce costs. '
              'You\'ll reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months with this saving.';
        case 'Entertainment':
          return 'Entertainment makes up ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'Cutting back by ${targetPercentage.toStringAsFixed(1)}% could save you \$${savings.toStringAsFixed(2)} monthly. '
              'Consider opting for free or low-cost entertainment options, such as public events or streaming services instead of going out. '
              'This will help you reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
        case 'Other':
          return 'Miscellaneous expenses account for ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your spending. '
              'By reducing these by ${targetPercentage.toStringAsFixed(1)}%, you can save \$${savings.toStringAsFixed(2)} per month. '
              'Review these expenses to identify areas where you can cut back, such as subscriptions or impulse buys. '
              'You\'ll reach your goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months with this adjustment.';
        default:
          return 'Your $highestCategory spending is ${(highestSpending / totalExpenses * 100).toStringAsFixed(1)}% of your total expenses. '
              'By reducing it by ${targetPercentage.toStringAsFixed(1)}%, you can save an extra \$${savings.toStringAsFixed(2)} per month. '
              'With this change, you will reach your savings goal in ${monthsToGoal.isFinite ? monthsToGoal.toStringAsFixed(0) : '∞'} months.';
      }
    }
  }
}
