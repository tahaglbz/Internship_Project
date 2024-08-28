import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/aiPlanning/userData.dart';
import 'package:my_app/extensions/media_query.dart';
import '../auth/firestore/firestoreService.dart';
import '../widgets/appColors.dart';

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

  String? financialPlan;

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
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
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
          const SizedBox(
            height: 15,
          ),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (financialPlan != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                financialPlan!,
                style: GoogleFonts.adamina(
                  color: AppColors.defaultColor,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
