// ignore_for_file: file_names, avoid_print

import 'package:get/get.dart';
import 'detailController.dart';

class PlanDetailsController extends GetxController {
  final DetailController _detailController = Get.find<DetailController>();

  RxMap<String, double?> savingsPlan = <String, double?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavingsPlan();
  }

  Future<void> fetchSavingsPlan() async {
    try {
      await _detailController.fetchExpenses();

      double targetSavingsPercentage = 20.0; // Hedef tasarruf oranı

      Map<String, double?> plan = {};
      _detailController.expenses.forEach((category, amount) {
        if (category != 'Income' && amount != null) {
          var savingsData = _detailController.calculateSavings(
              targetSavingsPercentage, category, amount);
          plan[category] = savingsData['savings'];
        }
      });

      savingsPlan.value = plan;
    } catch (e) {
      print("Error fetching savings plan: $e");
    }
  }

  Map<String, double?> getPlanDetails() {
    return Map.fromEntries(savingsPlan.entries);
  }
}
