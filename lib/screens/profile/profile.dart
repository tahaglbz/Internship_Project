import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/profile/profileController.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => controller.uploadProfilePhoto(),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.profilePictureUrl.value.isNotEmpty
                      ? NetworkImage(controller.profilePictureUrl.value)
                      : null,
                  child: controller.profilePictureUrl.value.isEmpty
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              Text('Username: ${controller.username.value}'),
              SizedBox(height: 8),
              Text(
                  'Registration Date: ${DateFormat('dd/MM/yyyy').format(controller.registrationDate.value)}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String? newUsername = await _showEditUsernameDialog(context);
                  if (newUsername != null) {
                    controller.updateUserProfile(newUsername);
                  }
                },
                child: Text('Change Username'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<String?> _showEditUsernameDialog(BuildContext context) async {
    TextEditingController textController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Username'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: 'New Username'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textController.text);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
