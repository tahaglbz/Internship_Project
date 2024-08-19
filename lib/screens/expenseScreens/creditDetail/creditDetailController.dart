import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreditController extends GetxController {
  var credits = <DocumentSnapshot>[].obs;

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
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('credit')
        .doc(aim);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) {
        throw Exception("Document does not exist!");
      }

      final remaining = (doc.data()?['remaining'] ?? 0.0) as double;
      final instalment = (doc.data()?['instalment'] ?? 0) as int;

      if (remaining >= amount) {
        transaction.update(docRef, {
          'remaining': remaining - amount,
          'instalment': instalment - 1,
        });

        // Optionally remove the document if instalments reach 0
        if (instalment - 1 <= 0) {
          transaction.delete(docRef);
        }
      } else {
        throw Exception("Insufficient remaining amount!");
      }
    });

    fetchCredits(); // Refresh the list
  }
}
