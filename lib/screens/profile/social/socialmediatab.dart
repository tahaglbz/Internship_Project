// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/profile/social/socialcontroller.dart';

class SocialMediaTab extends StatelessWidget {
  const SocialMediaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final SocialMediaController controller = Get.put(SocialMediaController());
    FirebaseAuth auth = FirebaseAuth.instance;

    // Ekran yüklendiğinde postları yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPosts();
    });

    return Obx(() {
      if (controller.posts.isEmpty) {
        return const Center(child: Text('No posts available.'));
      }

      final userProfile = controller.userProfile;
      final profileImage = userProfile['profilePicture'] ?? '';
      final username = userProfile['username'] ?? 'Unknown';

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  radius: 20,
                  child: profileImage.isEmpty ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 8),
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () => Get.offAllNamed('/forum'),
                    child: const Text(
                      'Go Forum',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
                const Spacer(),
                const Text(
                  'POSTS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: controller.posts.length,
              separatorBuilder: (context, index) => const Divider(height: 2),
              itemBuilder: (context, index) {
                final post = controller.posts[index];
                final createdAt = (post['createdAt'] as Timestamp).toDate();
                final timeAgo = _formatTimeAgo(createdAt);
                final title = post['title'] ?? '';
                final text = post['text'] ?? '';
                final imageUrl = post['imageUrl'] ?? '';
                final postId = post['postId'] ?? '';
                final like = post['like'] ?? 0;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (postId.isNotEmpty) {
                                await controller.deletePost(postId);
                              } else {
                                Get.snackbar('Error', 'Post ID is missing.');
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(text),
                      if (imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.network(
                            imageUrl,
                            width: 300,
                            height: 300,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.thumb_up,
                              color: (post['likedBy'] != null &&
                                      (post['likedBy'] as List)
                                          .contains(auth.currentUser?.uid))
                                  ? Colors.orange
                                  : const Color.fromARGB(111, 158, 158, 158),
                            ),
                            label: Text(post['like'].toString()),
                            onPressed: () {
                              controller.likeUpdate(postId);
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
                      const Divider(
                        thickness: 3,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

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
}
