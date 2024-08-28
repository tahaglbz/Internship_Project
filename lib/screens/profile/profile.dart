import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/auth/widgets/reset_password.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/expenseScreens/creditDetail/creditDetailDialog.dart';
import 'package:my_app/screens/profile/incomeBottomSheet.dart';
import 'package:my_app/screens/profile/incomeUpdateBottomSheet.dart';
import 'package:my_app/screens/profile/profileController.dart';

import '../../auth/firestore/firestoreService.dart';
import '../../widgets/appColors.dart';

class ProfilePage extends StatelessWidget {
  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final double deviceWidth = context.deviceWidth;
    // final double deviceHeight = context.deviceHeight;
    double appBarHeight = deviceWidth * 0.28;
    Get.lazyPut(() => FirestoreService());

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
                const SizedBox(height: 16),
                Text(
                  'Username: ${controller.username.value}',
                  style: const TextStyle(
                      color: AppColors.defaultColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Text(
                  'Registration Date: ${DateFormat('dd/MM/yyyy').format(controller.registrationDate.value)}',
                  style: const TextStyle(
                      color: AppColors.defaultColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
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
                    const SizedBox(width: 24),
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
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.defaultColor),
                  onPressed: () async {
                    showIncomeBottomSheet(context);
                  },
                  child: const Text(
                    'Enter Your Income',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: AppColors.defaultColor,
                  height: 2,
                  thickness: 3,
                ),
                Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: firestoreService.getIncomeStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text(
                        'No income found.',
                        style: TextStyle(color: Colors.grey),
                      ));
                    }

                    List<Map<String, dynamic>> incomes = snapshot.data!;

                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Incomes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.defaultColor,
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: incomes.length,
                          itemBuilder: (context, index) {
                            var income = incomes[index];
                            return Dismissible(
                              key: Key(income['id'].toString()),
                              background: Container(
                                color: AppColors.defaultColor,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 16.0),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16.0),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  showAmountBottomSheet(
                                    context,
                                    (newAmount) {
                                      firestoreService.updateIncome(
                                          income['incomeName'].toString(),
                                          double.parse(newAmount));
                                    },
                                  );
                                  return false;
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  bool? confirmDeletion = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                          'Are you sure you want to delete this income?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmDeletion == true) {
                                    try {
                                      await firestoreService
                                          .deleteIncomes(income['incomeName']);
                                      Get.snackbar('Success',
                                          '${income['incomeName']} deleted');
                                    } catch (e) {
                                      Get.snackbar('Error', ' ${e.toString()}');
                                    }
                                  }
                                }
                                return null;
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                elevation: 4,
                                child: ListTile(
                                  leading:
                                      Image.asset('lib/assets/revenue.png'),
                                  title:
                                      Text(income['incomeName'] ?? 'no name'),
                                  subtitle: Text(
                                      'Budget : ${controller.getDisplayAmount(income)}'),
                                  trailing: Text(
                                    'Date: ${formatDate(DateTime.parse(income['updatedDate'] ?? DateTime.now().toIso8601String()))}',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                      ],
                    );
                  },
                ))
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
