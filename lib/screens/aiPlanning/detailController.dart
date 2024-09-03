import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:my_app/screens/aiPlanning/userData.dart';

class DetailController extends GetxController {
  final UserInputs _userInputs = UserInputs();
  RxMap<String, double?> expenses = <String, double?>{}.obs;
  var plans = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      final electricity = await _userInputs.getTotalElectricityAmount();
      final water = await _userInputs.getTotalWaterAmount();
      final nGas = await _userInputs.getTotalNaturalGasAmount();
      final net = await _userInputs.getTotalInternetAmount();
      final rent = await _userInputs.getTotalRentAmount();
      final edu = await _userInputs.getTotalEducationAmount();
      final tport = await _userInputs.getTotalTransportAmount();
      final shop = await _userInputs.getTotalShoppingAmount();
      final health = await _userInputs.getTotalHealthAmount();
      final income = await _userInputs.getTotalIncomesAmount();
      final ent = await _userInputs.getTotalEntertainmentAmount();
      final oth = await _userInputs.getTotalOtherAmount();
      expenses.value = {
        'Electricity': electricity,
        'Water': water,
        'Natural Gas': nGas,
        'Internet': net,
        'Rent': rent,
        'Education': edu,
        'Transport': tport,
        'Shopping': shop,
        'Health': health,
        'Entertainment': ent,
        'Other': oth,
        'Income': income
      };
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  Map<String, double?> calculateSavings(
      double targetSavingsPercentage, String category, double amount) {
    double? amount = expenses[category];
    if (amount == null) {
      return {'savings': 0.0};
    }

    double savings = amount * (targetSavingsPercentage / 100);
    return {'savings': savings};
  }

  double totalExpenses() {
    double total = 0.0;
    expenses.forEach((category, amount) {
      if (amount != null && category != 'Income') {
        total += amount;
      }
    });
    return total;
  }
}
