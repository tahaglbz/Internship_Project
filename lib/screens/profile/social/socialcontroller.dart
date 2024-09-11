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
    fetchPosts();
  }

  Future<void> deletePost(String? postId) async {
    // Eğer postId null ya da boşsa, hata mesajı ver
    if (postId == null || postId.isEmpty) {
      Get.snackbar('Error', 'Invalid post ID.');
      return;
    }

    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Kullanıcıya ait postu sil
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('posts')
            .doc(postId)
            .delete();

        // Genel postlar arasından da sil
        await _firestore.collection('postsAll').doc(postId).delete();

        Get.snackbar('Success', 'Post deleted successfully.');
        loadPosts(); // Postları yeniden yükle
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete post: $e');
      }
    } else {
      Get.snackbar('Error', 'No user is currently signed in.');
    }
  }

  Future<List<Map<String, dynamic>>> loadPosts() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Kullanıcı profil bilgilerini çek
        final userSnap =
            await _firestore.collection('users').doc(user.uid).get();
        userProfile.value = userSnap.data() ?? {};

        // Tüm postları çek
        final snapshot = await _firestore
            .collection('postsAll')
            .orderBy('createdAt', descending: true)
            .get();

        // Postların ve kullanıcı bilgilerini ekleyerek liste oluştur
        final postsList = await Future.wait(snapshot.docs.map((doc) async {
          final data = doc.data();
          data['postId'] = doc.id; // Post ID'si ekle

          final userId = data['userId'];
          if (userId != null) {
            // İlgili postun sahibi olan kullanıcı bilgilerini çek
            final userDoc =
                await _firestore.collection('users').doc(userId).get();
            final userData = userDoc.data();
            if (userData != null) {
              data['username'] = userData['username'] ?? 'Unknown';
              data['profilePicture'] = userData['profilePicture'] ?? '';
            }
          }

          return data;
        }).toList());

        return postsList;
      } catch (e) {
        Get.snackbar('Error', 'Failed to load posts: $e');
        print('Failed to load posts: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  Future<void> fetchPosts() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Kullanıcı profil bilgilerini çek
        final userSnap =
            await _firestore.collection('users').doc(user.uid).get();
        userProfile.value = userSnap.data() ?? {};

        // Tüm postları çek
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .get();

        // Postların ve kullanıcı bilgilerini ekleyerek liste oluştur
        final postsList = await Future.wait(snapshot.docs.map((doc) async {
          final data = doc.data();
          data['postId'] = doc.id; // Post ID'si ekle

          final userId = data['userId'];
          if (userId != null) {
            // İlgili postun sahibi olan kullanıcı bilgilerini çek
            final userDoc =
                await _firestore.collection('users').doc(userId).get();
            final userData = userDoc.data();
            if (userData != null) {
              data['username'] = userData['username'] ?? 'Unknown';
              data['profilePicture'] = userData['profilePicture'] ?? '';
            }
          }

          return data;
        }).toList());

        posts.value = postsList; // posts listesi güncelleniyor
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch posts: $e');
        print('Failed to fetch posts: $e');
        posts.value = []; // Post listesi hata durumunda boş oluyor
      }
    } else {
      posts.value = []; // Kullanıcı giriş yapmamışsa boş döner
    }
  }
}
