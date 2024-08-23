// lib/services/data_service.dart

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<double> getTotalCredit() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('credit')
          .get();

      double totalCredit = 0.0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final remaining = data['remaining'] as double?;
        final monthlyPayment = data['monthlyPayment'] as double?;
        final paid = data['paid'] as int?;

        if (remaining != null && monthlyPayment != null && paid != null) {
          final paidCredit = monthlyPayment * paid;
          totalCredit += remaining + paidCredit;
        }
      }

      return totalCredit;
    } catch (e) {
      print("Error in getTotalCredit: $e");
      rethrow;
    }
  }

  Future<double> getTotalRemainingCredit() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('credit')
          .get();

      double totalRemaining = 0.0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final remaining = data['remaining'] as double?;

        if (remaining != null) {
          totalRemaining += remaining;
        }
      }

      return totalRemaining;
    } catch (e) {
      print("Error in getTotalRemainingCredit: $e");
      rethrow;
    }
  }

  Future<double> getTotalPaidCredit() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('credit')
          .get();

      double totalPaidCredit = 0.0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final monthlyPayment = data['monthlyPayment'] as double?;
        final paid = data['paid'] as int?;

        if (monthlyPayment != null && paid != null) {
          totalPaidCredit += monthlyPayment * paid;
        }
      }

      return totalPaidCredit;
    } catch (e) {
      print("Error in getTotalPaidCredit: $e");
      rethrow;
    }
  }

  Future<double> getUnpaidExpensesTotal() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('expense')
          .where('paid', isEqualTo: false)
          .get();

      double totalAmount = 0.0;
      for (var doc in querySnapshot.docs) {
        totalAmount += (doc.data()['amount'] as num).toDouble();
      }
      return totalAmount;
    } catch (e) {
      print("Error in getUnpaidExpensesTotal: $e");
      rethrow;
    }
  }

  Future<double> getPaidExpensesTotal() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('expense')
          .where('paid', isEqualTo: true)
          .get();

      double totalAmount = 0.0;
      for (var doc in querySnapshot.docs) {
        totalAmount += (doc.data()['amount'] as num).toDouble();
      }
      return totalAmount;
    } catch (e) {
      print("Error in getPaidExpensesTotal: $e");
      rethrow;
    }
  }

  Future<double> getTotalExpenses() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('expense')
          .get();

      double totalAmount = 0.0;
      for (var doc in querySnapshot.docs) {
        totalAmount += (doc.data()['amount'] as num).toDouble();
      }
      return totalAmount;
    } catch (e) {
      print("Error in getTotalExpenses: $e");
      rethrow;
    }
  }

  Future<double> getCoinValue() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('assets')
          .get();

      double totalAmount = 0.0;
      for (var doc in querySnapshot.docs) {
        totalAmount += (doc.data()['amount'] as num).toDouble();
      }
      return totalAmount;
    } catch (e) {
      print("Error in getTotalCoin: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCoinData() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('assets')
          .get();

      double totalValue = 0.0;
      final List<Map<String, dynamic>> coinData = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final symbol = data['symbol'] as String?;
        final usdValue = data['usdValue'] as double?;

        if (symbol != null && usdValue != null) {
          totalValue += usdValue;
          coinData.add({
            'symbol': symbol,
            'usdValue': usdValue,
          });
        }
      }

      return {'totalValue': totalValue, 'coinData': coinData};
    } catch (e) {
      print("Error fetching coin data: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getExchangeData() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('exchangeAsset') // Corrected the collection name
          .get();

      double totalValue = 0.0;
      final List<Map<String, dynamic>> exchangeData = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final assetName = data['assetName'] as String?;
        final valueInUsd = data['valueInUsd'] as double?;

        if (assetName != null && valueInUsd != null) {
          totalValue += valueInUsd;
          exchangeData.add({
            'assetName': assetName,
            'valueInUsd': valueInUsd,
          });
        }
      }

      return {'totalValue': totalValue, 'exchangeData': exchangeData};
    } catch (e) {
      print("Error fetching exchange data: $e");
      rethrow;
    }
  }
}
