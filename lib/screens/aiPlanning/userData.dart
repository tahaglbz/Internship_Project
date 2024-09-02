// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInputs {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Future<double?> getTotalAmountByImageUrl(String imageUrl) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .collection('expense')
          .where('imageUrl', isEqualTo: imageUrl)
          .get();

      double totalAmount = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        totalAmount += (data['amount'] as num).toDouble();
      }

      return totalAmount;
    } catch (e) {
      return null;
    }
  }

  Future<double?> getTotalElectricityAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/electricity-bill.png');
  }

  Future<double?> getTotalWaterAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/maintenance.png');
  }

  Future<double?> getTotalNaturalGasAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/bill.png');
  }

  Future<double?> getTotalInternetAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/web.png');
  }

  Future<double?> getTotalRentAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/mortgage.png');
  }

  Future<double?> getTotalEducationAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/accounting-book.png');
  }

  Future<double?> getTotalTransportAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/battery.png');
  }

  Future<double?> getTotalShoppingAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/purchase.png');
  }

  Future<double?> getTotalHealthAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/health.png');
  }

  Future<double?> getTotalEntertainmentAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/influencer.png');
  }

  Future<double?> getTotalOtherAmount() async {
    return await getTotalAmountByImageUrl('lib/assets/debt.png');
  }

  Future<double?> getTotalIncomesAmount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .collection('incomes')
        .get();

    double totalIncome = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      totalIncome += (data['newAmount'] as num).toDouble();
    }

    return totalIncome;
  }
}
