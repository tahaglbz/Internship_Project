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

  Future<void> deletePost(String? postId) async {
    if (postId == null || postId.isEmpty) {
      Get.snackbar('Error', 'Invalid post ID.');
      return;
    }

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('posts')
            .doc(postId)
            .delete();

        await _firestore.collection('postsAll').doc(postId).delete();

        Get.snackbar('Success', 'Post deleted successfully.');
        loadPosts();
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete post: $e');
      }
    } else {
      Get.snackbar('Error', 'No user is currently signed in.');
    }
  }

  Future<void> loadPosts() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userSnap =
            await _firestore.collection('users').doc(user.uid).get();
        userProfile.value = userSnap.data() ?? {};

        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .get();
        posts.value = snapshot.docs.map((doc) {
          final data = doc.data();
          data['postId'] = doc.id; // ID'yi ekleyin
          return data;
        }).toList();
      } catch (e) {
        print('Failed to load data: $e');
      }
    }
  }
}
