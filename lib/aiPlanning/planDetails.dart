import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/aiPlanning/userData.dart';
import 'package:my_app/extensions/media_query.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height *
                    0.75, // Yüksekliği ayarlayabilirsiniz
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Her satıra 4 kart
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio:
                        2, // Kartların yüksekliği ve genişliği oranı
                  ),
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) {
                    final category = _expenses.keys.elementAt(index);
                    final amount = _expenses[category] ?? 0.0;
                    return _buildCategoryCard(
                        category, '\$${amount.toStringAsFixed(2)}');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, String value) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category,
              style: GoogleFonts.adamina(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.0),
            Text(
              value,
              style: GoogleFonts.adamina(color: Colors.black87, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
