import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/aiPlanning/userData.dart';
import 'package:my_app/extensions/media_query.dart';

import '../widgets/appColors.dart';

class PlanDetails extends StatefulWidget {
  @override
  _PlanDetailsState createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  final UserInputs _userInputs = UserInputs();
  Map<String, double?> _expenses = {};

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    try {
      final electricity = await _userInputs.getTotalElectricityAmount();
      final water = await _userInputs.getTotalWaterAmount();
      final nGas = await _userInputs.getTotalNaturalGasAmount();
      final net = await _userInputs.getTotalInternetAmount();
      final rent = await _userInputs.getTotalRentAmount();
      final edu = await _userInputs.getTotalEducationAmount();
      final tport = await _userInputs.getTotalTransportAmount();
      final shop = await _userInputs.getTotalShoppingAmount();
      final health = await _userInputs.getTotalHealthAmount();
      final ent = await _userInputs.getTotalEntertainmentAmount();
      final other = await _userInputs.getTotalOtherAmount();
      final income = await _userInputs.getTotalIncomesAmount();

      setState(() {
        _expenses = {
          'Electricity': electricity,
          'Water': water,
          'N Gas': nGas,
          'Internet': net,
          'Rent': rent,
          'Education': edu,
          'Transport': tport,
          'Shopping': shop,
          'Health': health,
          'Fun': ent,
          'Other': other,
          'Income': income
        };
      });
    } catch (e) {
      print('Error fetching expenses: $e');
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
          leading: IconButton(
            onPressed: () => Get.toNamed('/mainmenu'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Plan Details',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: context.deviceHeight * 0.18,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Her satıra 4 kart
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 2, // Kartların yüksekliği ve genişliği oranı
              ),
              itemCount: _expenses.length, // Kart sayısı
              itemBuilder: (context, index) {
                final category = _expenses.keys.elementAt(index);
                final amount = _expenses[category] ?? 0.0;
                return _buildCategoryCard(
                    category, '\$${amount.toStringAsFixed(2)}');
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Divider(
            color: AppColors.defaultColor,
            thickness: 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
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
