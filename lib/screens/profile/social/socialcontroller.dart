// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SocialMediaController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var posts = <Map<String, dynamic>>[].obs;
  var userProfile = {}.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Load user profile information
        final userSnap =
            await _firestore.collection('users').doc(user.uid).get();
        userProfile.value = userSnap.data() ?? {};

        // Load user posts
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .get();
        posts.value = snapshot.docs.map((doc) => doc.data()).toList();
      } catch (e) {
        print('Failed to load data: $e');
      }
    }
  }
}
