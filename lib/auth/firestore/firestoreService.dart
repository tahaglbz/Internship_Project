// services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

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
    return doc.data();
  }

  Future<void> saveAsset(String symbol, double amount, String imageUrl) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .set({'symbol': symbol, 'amount': amount, 'imageUrl': imageUrl});
  }

  Future<void> deleteAsset(String symbol) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .delete();
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
