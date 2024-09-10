// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/extensions/media_query.dart';
import '../../widgets/ForumBottomNav.dart';
import '../../widgets/appColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  int _selectedIndex = 4;
  final TextEditingController textController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  XFile? selectedImage;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Get.offAllNamed('/mainmenu');
        break;
      case 1:
        _showPostBottomSheet(context); // Open the bottom sheet
        break;
      case 2:
        Get.offAllNamed('/profile');
        break;
    }
  }

  void _showPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: bottomInset + 16.0, // Add padding for the keyboard
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Create a Post', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'Post Title',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange))),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                      labelText: 'Post Text',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange))),
                ),
                const SizedBox(height: 20),
                selectedImage != null
                    ? Image.file(
                        File(selectedImage!.path),
                        height: 150,
                      )
                    : const Icon(Icons
                        .image_not_supported_sharp), // Placeholder if no image is selected
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(3, 2))),
                      backgroundColor: AppColors.defaultColor),
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.orange,
                  ),
                  label: const Text(
                    'Select Image',
                    style: TextStyle(color: Colors.orange),
                  ),
                  onPressed: () async {
                    try {
                      selectedImage =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (selectedImage != null) {
                        setState(
                            () {}); // Refresh the bottom sheet to show the selected image
                        print('Selected image path: ${selectedImage!.path}');
                      } else {
                        print('No image selected.');
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to pick image: $e');
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.orange,
                  ),
                  onPressed: () async {
                    if (selectedImage != null &&
                        textController.text.isNotEmpty &&
                        titleController.text.isNotEmpty) {
                      try {
                        await _createPost(selectedImage!, textController.text,
                            titleController.text);
                        Get.offAllNamed('/forum');
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to create post: $e');
                      }
                    } else {
                      Get.snackbar('Error',
                          'Please select an image and enter some text.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(3, 2))),
                      backgroundColor: AppColors.defaultColor),
                  label: const Text(
                    'Post',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createPost(
      XFile image, String postText, String titleText) async {
    if (postText.isEmpty || titleText.isEmpty) {
      Get.snackbar('Error', 'Please provide all required fields.');
      return;
    }

    try {
      String fileName = path.basename(image.path);
      File imageFile = File(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('posts/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference postRef = firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('posts')
          .doc();

      String postId = postRef.id;
      await postRef.set({
        'postId': postId,
        'title': titleText,
        'text': postText,
        'imageUrl': downloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await firestore.collection('postsAll').doc(postId).set({
        'userId': currentUser!.uid,
        'postId': postId,
        'title': titleText,
        'text': postText,
        'imageUrl': downloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Post created successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    double appBarHeight = deviceWidth * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Image.asset('lib/assets/logo.png'),
          centerTitle: true,
          backgroundColor: AppColors.defaultColor,
        ),
      ),
      bottomNavigationBar: ForumBottom(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
