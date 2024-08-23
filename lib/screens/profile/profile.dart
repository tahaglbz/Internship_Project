import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/auth/widgets/reset_password.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/profile/incomeBottomSheet.dart';
import 'package:my_app/screens/profile/profileController.dart';
import '../../widgets/appColors.dart';
import '../../auth/firestore/firestoreService.dart'; // Ensure correct import

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensure FirestoreService is registered
    Get.put(FirestoreService());

    final ProfileController controller = Get.put(ProfileController());
    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;
    double appBarHeight = deviceWidth * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
              onPressed: () => Get.offAllNamed('/mainmenu'),
              icon: const Icon(Icons.arrow_back_ios_new_sharp)),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => controller.uploadProfilePhoto(),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        controller.profilePictureUrl.value.isNotEmpty
                            ? NetworkImage(controller.profilePictureUrl.value)
                            : null,
                    child: controller.profilePictureUrl.value.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Username: ${controller.username.value}',
                  style: const TextStyle(
                      color: AppColors.defaultColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 26),
                Text(
                  'Registration Date: ${DateFormat('dd/MM/yyyy').format(controller.registrationDate.value)}',
                  style: const TextStyle(
                      color: AppColors.defaultColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 26),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.defaultColor),
                  onPressed: () async {
                    String? newUsername =
                        await _showEditUsernameBottomSheet(context);
                    if (newUsername != null && newUsername.isNotEmpty) {
                      controller.updateUserProfile(newUsername);
                    }
                  },
                  child: const Text(
                    'Change Username',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 26),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.defaultColor),
                  onPressed: () async {
                    showResetPasswordBottomSheet(context);
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 26),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.defaultColor),
                  onPressed: () async {
                    showIncomeBottomSheet(context);
                  },
                  child: const Text(
                    'Add Your Income',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<String?> _showEditUsernameBottomSheet(BuildContext context) async {
    TextEditingController textController = TextEditingController();
    return await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Edit Username',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'New Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(textController.text);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
