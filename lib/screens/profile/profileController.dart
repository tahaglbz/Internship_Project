// ignore_for_file: avoid_print, file_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var username = ''.obs;
  var profilePictureUrl = ''.obs;
  var registrationDate = DateTime.now().obs;
  var bio = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  double getDisplayAmount(Map<String, dynamic> income) {
    if (income['updatedHistory'] != null &&
        income['updatedHistory'].isNotEmpty) {
      List<dynamic> history = income['updatedHistory'];
      history.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA); // Azalan sıraya göre
      });
      return history.first['amount'];
    } else {
      return income['amount'] ?? 0.0;
    }
  }

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          username.value = data['username'] ?? '';
          profilePictureUrl.value = data['profilePicture'] ?? '';
          registrationDate.value =
              (data['registrationDate'] as Timestamp).toDate();
          bio.value = data['bio'] ?? '';
        }
      } catch (e) {
        print('Failed to load user data: $e');
      }
    }
  }

  Future<void> uploadProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final user = _auth.currentUser;
      if (user != null) {
        try {
          final storageRef =
              _storage.ref().child('profile_pictures').child('${user.uid}.jpg');

          final uploadTask = storageRef.putFile(file);
          await uploadTask.whenComplete(() async {
            final downloadUrl = await storageRef.getDownloadURL();
            await _firestore
                .collection('users')
                .doc(user.uid)
                .update({'profilePicture': downloadUrl});
            profilePictureUrl.value = downloadUrl;
          });
        } catch (e) {
          print('Failed to upload photo: $e');
          Get.snackbar('Error', 'Failed to upload photo: $e');
        }
      }
    }
  }

  Future<void> updateUserProfile(String newUsername) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'username': newUsername});
        username.value = newUsername;
      } catch (e) {
        print('Failed to update profile: $e');
      }
    }
  }

  Future<void> updateBio(String newBio) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'bio': newBio});
        bio.value = newBio;
      } catch (e) {
        print('Failed to update bio: $e');
        Get.snackbar('Error', 'Failed to update bio: $e');
      }
    }
  }
}
