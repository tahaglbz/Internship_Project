// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/profile/social/socialcontroller.dart';
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
  SocialMediaController controller = SocialMediaController();

  XFile? selectedImage;

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes == 1) {
      return 'A minute ago';
    } else {
      return 'Just now';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Get.offAllNamed('/mainmenu');
        break;
      case 1:
        _showPostBottomSheet(context);
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
            bottom: bottomInset + 16.0,
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
                    : const Icon(Icons.image_not_supported_sharp),
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
                        setState(() {});
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
        'like': 0,
        'likedBy': [],
        'userId': currentUser!.uid,
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
          title: Text(
            'FORUM',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          backgroundColor: AppColors.defaultColor,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.loadPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No posts available"));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final createdAt = (post['createdAt'] as Timestamp).toDate();
              final formattedTimeAgo = _formatTimeAgo(createdAt);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: post['profilePicture'] != ''
                                  ? NetworkImage(post['profilePicture'])
                                  : const AssetImage(
                                          'lib/assets/default_avatar.png')
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              post['username'] ?? 'Unknown User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    formattedTimeAgo,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(post['text'] ?? ''),
                        const SizedBox(height: 10),
                        post['imageUrl'] != ''
                            ? Image.network(
                                post['imageUrl'],
                                width: 300,
                                height: 300,
                              )
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              onPressed: () {
                                // Handle like action
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                // Handle comment action
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark),
                              onPressed: () {
                                // Handle save action
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                // Handle share action
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 40, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ForumBottom(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
