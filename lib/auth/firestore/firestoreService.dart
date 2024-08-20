// lib/services/firestore_service.dart

// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Get a stream of all assets
  Stream<List<Map<String, dynamic>>> getAssets() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Get a single asset by symbol
  Future<Map<String, dynamic>?> getAsset(String symbol) async {
    final doc = await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .get();
    return doc.exists ? doc.data() : null;
  }

  Stream<List<Map<String, dynamic>>> getExcAssetsStream() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getExpenseStream() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('expense')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getCreditStream() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('credit')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> saveAsset(String symbol, double amount, String imageUrl) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .set({'symbol': symbol, 'amount': amount, 'imageUrl': imageUrl});
  }

  Future<void> saveExcAsset(
      String assetName, double amount, String assetIconPath) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset') // Make sure this is the same
        .doc(assetName)
        .set({
      'amount': amount,
      'assetName': assetName,
      'assetIconPath': assetIconPath,
    });
  }

  Future<void> deleteAsset(String symbol) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .delete();
  }

  Future<void> saveExpense(String expName, double amount, String imageUrl,
      DateTime lastPaymentDate) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('expense')
        .doc(expName)
        .set({
      'expName': expName,
      'amount': amount,
      'imageUrl': imageUrl,
      'lastPaymentDate': lastPaymentDate.toIso8601String(),
      'paid': false
    });
  }

  Future<void> markAsPaidExpense(String expName) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('expense')
        .doc(expName)
        .update({
      'paid': true,
      'paymentDate': DateTime.now().toIso8601String(), // Ödeme tarihini ekle
    });
  }

  Future<void> saveCredit(
      String bankName,
      String aim,
      double remaining,
      double monthlyPayment,
      int instalment,
      String imageUrl,
      DateTime lastPaymentDate) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('credit')
        .doc(aim)
        .set({
      'bankName': bankName,
      'aim': aim,
      'imageUrl': imageUrl,
      'lastPaymentDate': lastPaymentDate.toIso8601String(),
      'remaining': remaining,
      'monthlyPayment': monthlyPayment,
      'instalment': instalment,
    });
  }

  Future<void> deleteAssetEx(String assetName) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset')
        .doc(assetName)
        .delete();
  }

  Future<void> deleteExpense(String expName) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('expense')
        .doc(expName)
        .delete();
  }

  Future<void> deleteCredit(String aim) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('credit')
        .doc(aim)
        .delete();
  }

  Future<void> updateAssetEx(String oldAssetName, String newAssetName,
      double newAmount, String iconPath) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset')
        .doc(oldAssetName)
        .update({
      'assetName': newAssetName,
      'amount': newAmount,
      'assetIconPath': iconPath,
    });
  }

  Future<void> updateCredit(String userId, String aim, double amount) async {
    final firestore = FirebaseFirestore.instance;

    final docRef =
        firestore.collection('users').doc(userId).collection('credit').doc(aim);

    await firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);
      if (!docSnapshot.exists) {
        throw Exception("Document does not exist!");
      }

      final data = docSnapshot.data()!;
      final remaining = (data['remaining'] as double) - amount;
      final instalment = (data['instalment'] as int) - 1;
      final lastPaymentDateStr = data['lastPaymentDate'] as String;
      DateTime lastPaymentDate = DateTime.parse(lastPaymentDateStr);

      DateTime nextPaymentDate = DateTime(
        lastPaymentDate.year,
        lastPaymentDate.month + 1,
        lastPaymentDate.day,
      );

      if (nextPaymentDate.month > 12) {
        nextPaymentDate = DateTime(
          nextPaymentDate.year + 1,
          1,
          nextPaymentDate.day,
        );
      }

      transaction.update(docRef, {
        'remaining': remaining,
        'instalment': instalment,
        'lastPaymentDate': nextPaymentDate.toIso8601String(),
      });
    });
  }

  Future<void> updateAsset(String symbol, double newAmount) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .update({'amount': newAmount});
  }
}
