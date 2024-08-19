// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/auth/firestore/firestoreService.dart'; // FirestoreService'i içe aktarın

class CreditController extends GetxController {
  var credits = <DocumentSnapshot>[].obs;
  final FirestoreService _firestoreService =
      FirestoreService(); // FirestoreService örneği oluşturun

  @override
  void onInit() {
    super.onInit();
    fetchCredits();
  }

  void fetchCredits() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('credit')
        .get();
    credits.assignAll(snapshot.docs);
  }

  void markAsPaid(String aim, double amount) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      await _firestoreService.updateCredit(
          userId, aim, amount); // FirestoreService'deki fonksiyonu çağırın
      fetchCredits(); // List'i yenileyin
    } catch (e) {
      Get.snackbar('Error', e.toString()); // Hata mesajını gösterin
    }
  }
}
