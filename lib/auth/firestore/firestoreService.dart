import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/screens/exchangeScreens/fixerio.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final Fixerio fixerio = Fixerio();

  Stream<List<Map<String, dynamic>>> getAssets() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

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

  Stream<List<Map<String, dynamic>>> getIncomeStream() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('incomes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getUnPaidExpendes() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('expense')
        .where('paid', isEqualTo: false)
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

  Future<void> saveAsset(String symbol, double amount, String imageUrl,
      double usdValue, DateTime updatedDate) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .set({
      'symbol': symbol,
      'amount': amount,
      'imageUrl': imageUrl,
      'usdValue': usdValue,
      'updatedDate': updatedDate.toIso8601String(),
    });
  }

  Future<void> saveAimPlan(
      String aim, double price, DateTime updatedDate) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('savePlan')
          .doc(aim)
          .set({
        'aim': aim,
        'price': price,
        'updatedDate': updatedDate.toIso8601String(),
      });
    } catch (e) {
      print("Error saving income: $e");
    }
  }

  Future<void> saveIncome(
      String incomeName, double amount, DateTime updatedDate) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUser?.uid)
          .collection('incomes')
          .doc(incomeName)
          .set({
        'incomeName': incomeName,
        'amount': amount,
        'updatedDate': updatedDate.toIso8601String(),
      });
    } catch (e) {
      print("Error saving income: $e");
    }
  }

  Future<void> saveExcAsset(
      String assetName, double amount, String assetIconPath) async {
    double valueInUsd;

    if (assetIconPath == 'lib/assets/stock.png' ||
        assetIconPath == 'lib/assets/money.png') {
      valueInUsd = amount;
    } else {
      valueInUsd = await fixerio.calculateAssetValue(assetIconPath, amount);
    }

    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset')
        .doc(assetName)
        .set({
      'amount': amount,
      'assetName': assetName,
      'assetIconPath': assetIconPath,
      'valueInUsd': valueInUsd,
      'updateDate': DateTime.now().toIso8601String(),
    });
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
      'paid': 0
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

  Future<void> deleteAsset(String symbol) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .delete();
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

  Future<void> deleteIncomes(String incomeName) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('incomes')
        .doc(incomeName)
        .delete();
  }

  Future<void> updateAssetEx(
    String oldAssetName,
    String newAssetName,
    double newAmount,
    String iconPath,
  ) async {
    double valueInUsd;

    if (iconPath == 'lib/assets/stock.png' ||
        iconPath == 'lib/assets/money.png') {
      valueInUsd = newAmount;
    } else {
      valueInUsd = await fixerio.calculateAssetValue(iconPath, newAmount);
    }

    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset')
        .doc(oldAssetName)
        .update({
      'assetName': newAssetName,
      'newAmount': newAmount,
      'assetIconPath': iconPath,
      'newValueInUsd': valueInUsd,
      'updateDate': DateTime.now().toIso8601String(), // Güncelleme tarihi
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

      final paid = (data['paid'] as int) + 1;

      transaction.update(docRef, {
        'remaining': remaining,
        'instalment': instalment,
        'lastPaymentDate': nextPaymentDate.toIso8601String(),
        'paid': paid,
      });
    });
  }

  Future<void> updateIncome(String incomeName, double newAmount) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('incomes')
        .doc(incomeName)
        .update({
      'newAmount': newAmount,
      'newDate': DateTime.now().toIso8601String(),
      'updatedHistory': FieldValue.arrayUnion([
        {'date': DateTime.now().toIso8601String(), 'amount': newAmount}
      ])
    });
  }

  Future<void> updateAsset(String symbol, double newAmount, double newUsdValue,
      DateTime updatedDate) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .update({
      'amount': newAmount,
      'usdValue': newUsdValue,
      'updatedDate': updatedDate.toIso8601String(),
    });
  }

  Future<void> updateAssetAmount(
      String symbol, double newAmount, double newValueInUsd) async {
    final updatedDate = DateTime.now();

    final assetRef = _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol);

    final assetSnapshot = await assetRef.get();
    if (assetSnapshot.exists) {
      final currentData = assetSnapshot.data()!;
      final updateHistory =
          currentData['updateHistory'] as List<dynamic>? ?? [];

      updateHistory.add({
        'amount': newAmount,
        'valueInUsd': newValueInUsd,
        'updatedDate': updatedDate.toIso8601String(),
      });

      await assetRef.update({
        'newUpdatedDate': updatedDate.toIso8601String(),
        'newAmount': newAmount,
        'newValueInUsd': newValueInUsd,
        'updateHistory': updateHistory,
      });
    } else {
      await assetRef.set({
        'symbol': symbol,
        'amount': newAmount,
        'valueInUsd': newValueInUsd,
        'updatedDate': updatedDate.toIso8601String(),
        'lastAmount': newAmount,
        'lastUpdate': updatedDate.toIso8601String(),
        'updateHistory': [
          {
            'amount': newAmount,
            'valueInUsd': newValueInUsd,
            'updatedDate': updatedDate.toIso8601String(),
          }
        ],
      });
    }
  }
}
