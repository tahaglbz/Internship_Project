import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/widgets/appColors.dart';
import 'detailController.dart';

class PlanDetails extends StatelessWidget {
  final DetailController detailController = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    double appBarHeight = deviceWidth * 0.28;

    final Map<String, dynamic>? plan = Get.arguments as Map<String, dynamic>?;

    String aim = plan?['aim'] ?? 'No Aim';
    double price = plan?['price'] ?? 0.0;
    if (plan == null) {
      return const Scaffold(
        body: Center(child: Text('No plan details available.')),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () => Get.toNamed('/planning'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            aim,
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: AppColors.defaultColor,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16.0),
          Text(
            'Price: \$${price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          const Divider(
            color: AppColors.defaultColor,
            thickness: 2,
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: context.deviceHeight * 0.18,
            child: Obx(() {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 2,
                ),
                itemCount: detailController.expenses.length,
                itemBuilder: (context, index) {
                  final category =
                      detailController.expenses.keys.elementAt(index);
                  final amount = detailController.expenses[category] ?? 0.0;
                  return _buildCategoryCard(
                      category, '\$${amount.toStringAsFixed(2)}');
                },
              );
            }),
          ),
          const SizedBox(height: 8.0),
          const Divider(
            color: AppColors.defaultColor,
            thickness: 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'Plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, String value) {
    Color background;
    if (category == 'Income') {
      background = Colors.green[700]!;
    } else {
      background = Colors.red[700]!;
    }
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: background,
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 1.0),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
