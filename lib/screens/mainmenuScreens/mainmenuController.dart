// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../auth/firestore/firestoreService.dart';

class MainMenuController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<Map<String, dynamic>>> getAssetsStream() {
    return firestoreService.getAssets();
  }

  Stream<List<Map<String, dynamic>>> getExcAssetsStream() {
    return firestoreService.getExcAssetsStream();
  }

  Stream<List<Map<String, dynamic>>> getExpendes() {
    return firestoreService.getExpenseStream();
  }

  Stream<List<Map<String, dynamic>>> getCredits() {
    return firestoreService.getCreditStream();
  }

  Stream<List<Map<String, dynamic>>> getUnPaidExpendes() {
    return firestoreService.getUnPaidExpendes();
  }

  Future<List<Map<String, dynamic>>> getLastTwoVideos() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('edu')
        .orderBy('createdAt', descending: true)
        .limit(2)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getLastTwoArticles() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('eduArticles')
        .orderBy('createdAt', descending: true)
        .limit(2)
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
