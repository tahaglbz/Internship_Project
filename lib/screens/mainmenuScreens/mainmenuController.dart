// ignore_for_file: file_names

import 'package:get/get.dart';

import '../../auth/firestore/firestoreService.dart';

class MainMenuController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();

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
}
