// lib/services/firestore_service.dart

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

  // Stream of a single asset by symbol
  Stream<List<Map<String, dynamic>>> getExcAssetsStream() {
    return _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Save an asset
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
        .collection('exchangeAsset')
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

  Future<void> deleteAssetEx(String assetName) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('exchangeAsset')
        .doc(assetName)
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

  // Update an asset's amount
  Future<void> updateAsset(String symbol, double newAmount) async {
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('assets')
        .doc(symbol)
        .update({'amount': newAmount});
  }
}
