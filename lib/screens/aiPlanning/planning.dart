import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screens/aiPlanning/userData.dart';
import 'package:my_app/extensions/media_query.dart';
import '../../auth/firestore/firestoreService.dart';
import '../../widgets/appColors.dart';

class Planning extends StatefulWidget {
  const Planning({super.key});

  @override
  State<Planning> createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  final TextEditingController planAimController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  UserInputs userinp = UserInputs();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
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
            'Planning',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: AppColors.defaultColor,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Save Planning',
              style: GoogleFonts.adamina(
                  color: AppColors.defaultColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
          ),
          const Divider(
            color: AppColors.defaultColor,
            thickness: 2,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: planAimController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.defaultColor)),
                        labelText: 'Plan Aim',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String aim = planAimController.text.trim();
                double price =
                    double.tryParse(priceController.text.trim()) ?? 0.0;

                if (aim.isNotEmpty && price > 0) {
                  await firestoreService.saveAimPlan(
                      aim, price, DateTime.now());

                  Get.snackbar('Success', 'Plan saved successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white);
                } else {
                  Get.snackbar('Error', 'Please enter valid inputs.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: AppColors.defaultColor),
              child: Text(
                'Save Plan',
                style: GoogleFonts.adamina(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Divider(
            color: AppColors.defaultColor,
            thickness: 2,
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestoreService.getSavePlan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No plans available.'));
                }

                final plans = snapshot.data!;

                return ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final aim = plan['aim'] ?? 'No Aim';
                    final price = plan['price'] ?? 0.0;
                    final updatedDateString =
                        plan['updatedDate'] ?? DateTime.now().toIso8601String();
                    final updatedDate =
                        DateTime.tryParse(updatedDateString) ?? DateTime.now();
                    final planId = plan['id'] ?? '';

                    return Dismissible(
                      key: Key(planId),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text(
                                  'Are you sure you want to delete this plan?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        setState(() {
                          plans.removeAt(index);
                        });

                        firestoreService.deleteAim(aim);
                        Get.snackbar('Deleted', 'Plan deleted successfully.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            aim,
                            style: GoogleFonts.adamina(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${price.toStringAsFixed(2)}',
                                style: GoogleFonts.adamina(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Date: ${updatedDate.toLocal().toShortDateString()}',
                                style: GoogleFonts.adamina(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Get.offAllNamed('/planDetail', arguments: plan);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.defaultColor,
                            ),
                            child: Text(
                              'See Plan',
                              style: GoogleFonts.adamina(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    return '$day/$month/$year';
  }
}
