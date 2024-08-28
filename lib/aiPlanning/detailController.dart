import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:my_app/aiPlanning/userData.dart';

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
      final ent = await _userInputs.getTotalEntertainmentAmount();
      final other = await _userInputs.getTotalOtherAmount();
      final income = await _userInputs.getTotalIncomesAmount();

      expenses.value = {
        'Electricity': electricity,
        'Water': water,
        'N Gas': nGas,
        'Internet': net,
        'Rent': rent,
        'Education': edu,
        'Transport': tport,
        'Shopping': shop,
        'Health': health,
        'Fun': ent,
        'Other': other,
        'Income': income
      };
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  List<Map<String, dynamic>> get expensesList {
    return expenses.entries.map((e) {
      return {
        'category': e.key,
        'amount': e.value,
      };
    }).toList();
  }

  void fetchCredits() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('savePlan')
        .get();
    plans.assignAll(snapshot.docs);
  }
}
