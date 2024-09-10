import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/profile/social/socialcontroller.dart';

class SocialMediaTab extends StatelessWidget {
  const SocialMediaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final SocialMediaController controller = Get.put(SocialMediaController());

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
              children: [
                CircleAvatar(
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  radius: 20,
                  child: profileImage.isEmpty ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
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
                          child: Image.network(imageUrl),
                        ),
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
                      Divider(
                        thickness: 3,
                        color: Colors.grey,
                      )
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
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
