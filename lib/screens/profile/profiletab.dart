// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/auth/widgets/reset_password.dart';
import 'package:my_app/screens/profile/incomeBottomSheet.dart';
import 'package:my_app/screens/profile/incomeUpdateBottomSheet.dart';
import 'package:my_app/screens/profile/profileController.dart';
import 'package:my_app/screens/profile/updateusername.dart';
import '../../auth/firestore/firestoreService.dart';
import '../../widgets/appColors.dart';

class ProfileAppTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final firestoreService = Get.put(FirestoreService());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() => GestureDetector(
                          onTap: () => controller.uploadProfilePhoto(),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                controller.profilePictureUrl.value.isNotEmpty
                                    ? NetworkImage(
                                        controller.profilePictureUrl.value)
                                    : null,
                            child: controller.profilePictureUrl.value.isEmpty
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                        )),
                    const SizedBox(height: 16),

                    Obx(() => Text(
                          'Username: ${controller.username.value}',
                          style: const TextStyle(
                              color: AppColors.defaultColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                    const SizedBox(height: 16),

                    Obx(() {
                      if (controller.bio.value.isNotEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.bio.value,
                              style: const TextStyle(
                                  color: AppColors.defaultColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      String newBio = controller.bio.value;
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            TextField(
                                              onChanged: (value) {
                                                newBio = value;
                                              },
                                              controller: TextEditingController(
                                                  text: controller.bio.value),
                                              decoration: const InputDecoration(
                                                labelText: 'Enter your bio',
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton.icon(
                                              icon: const Icon(Icons.save,
                                                  color: Colors.white),
                                              label: const Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.defaultColor,
                                              ),
                                              onPressed: () {
                                                if (newBio.isNotEmpty) {
                                                  controller.updateBio(newBio);
                                                  Get.back();
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        );
                      } else {
                        return ElevatedButton.icon(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text(
                            'Add Bio',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.defaultColor,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                String newBio = controller.bio.value;
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          newBio = value;
                                        },
                                        controller: TextEditingController(
                                            text: controller.bio.value),
                                        decoration: const InputDecoration(
                                          labelText: 'Enter your bio',
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.save,
                                            color: Colors.white),
                                        label: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.defaultColor,
                                        ),
                                        onPressed: () {
                                          if (newBio.isNotEmpty) {
                                            controller.updateBio(newBio);
                                            Get.back();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    }),
                    const SizedBox(height: 16),

                    // Registration date with reactive update
                    Obx(() => Text(
                          'Registration Date: ${DateFormat('dd/MM/yyyy').format(controller.registrationDate.value)}',
                          style: const TextStyle(
                              color: AppColors.defaultColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),

                    const SizedBox(height: 16),

                    // Username and Password update buttons
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.defaultColor),
                          onPressed: () async {
                            String? newUsername =
                                await ShowEditUsernameBottomSheet(context);
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

                    // Enter Income button
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
                  ],
                ),
              ),
            ),

            // Divider line
            const SizedBox(height: 10),
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
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: Card(
                                elevation: 4,
                                child: Dismissible(
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
                                    if (direction ==
                                        DismissDirection.startToEnd) {
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
                                      await firestoreService.deleteIncomes(
                                          income['id'].toString());
                                      return true;
                                    }
                                    return false;
                                  },
                                  child: ListTile(
                                    title: Text(income['incomeName']),
                                    subtitle: Text(
                                        'Amount: ${income['amount'].toStringAsFixed(2)}'),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
