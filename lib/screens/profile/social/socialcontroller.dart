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
        final userSnap =
            await _firestore.collection('users').doc(user.uid).get();
        userProfile.value = userSnap.data() ?? {};

        final snapshot = await _firestore
            .collection('postsAll')
            .orderBy('createdAt', descending: true)
            .get();

        final postsList = await Future.wait(snapshot.docs.map((doc) async {
          final data = doc.data();
          data['postId'] = doc.id;

          final userId = data['userId'];
          if (userId != null) {
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

  Future<void> likeUpdate(String postId) async {
    try {
      DocumentReference postRef = _firestore.collection('postsAll').doc(postId);
      DocumentSnapshot postSnapshot = await postRef.get();

      if (!postSnapshot.exists) return;

      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;
      List<dynamic> likedBy = postData['likedBy'] ?? [];
      String currentUserId = _auth.currentUser!.uid;

      if (likedBy.contains(currentUserId)) {
        // Eğer kullanıcı zaten beğendiyse, beğeniyi geri al
        likedBy.remove(currentUserId);
        await postRef.update({
          'like': FieldValue.increment(-1),
          'likedBy': likedBy,
        });

        // UI'yi güncelle
        int index = posts.indexWhere((post) => post['postId'] == postId);
        if (index != -1) {
          posts[index]['like'] -= 1;
          posts[index]['likedBy'] = likedBy;
          posts.refresh();
        }
      } else {
        // Eğer kullanıcı beğenmediyse, beğeni ekle
        likedBy.add(currentUserId);
        await postRef.update({
          'like': FieldValue.increment(1),
          'likedBy': likedBy,
        });

        // UI'yi güncelle
        int index = posts.indexWhere((post) => post['postId'] == postId);
        if (index != -1) {
          posts[index]['like'] += 1;
          posts[index]['likedBy'] = likedBy;
          posts.refresh();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like: $e');
    }
  }
}
