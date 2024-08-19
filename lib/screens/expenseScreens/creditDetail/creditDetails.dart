import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/expenseScreens/creditDetail/creditDetailController.dart';

import '../../../widgets/appColors.dart';

class CreditDetails extends StatelessWidget {
  final CreditController _controller = Get.put(CreditController());

  CreditDetails({super.key});

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  void showPaymentDialog(
      BuildContext context, String aim, double monthlyPayment) {
    Get.defaultDialog(
      title: 'Are you sure?',
      middleText: 'This action will update the payment details.',
      confirm: ElevatedButton(
        onPressed: () {
          _controller.markAsPaid(aim, monthlyPayment);
          Get.back(); // Close the dialog
        },
        child: Text('Yes'),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(), // Close the dialog
        child: Text('Cancel'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> credit = Get.arguments;

    String bankName = credit['bankName'] ?? 'No Bank Name';
    String imageUrl = credit['imageUrl'] ?? 'lib/assets/money.png';
    String lastPaymentDate =
        credit['lastPaymentDate'] ?? DateTime.now().toIso8601String();
    double monthlyPayment = credit['monthlyPayment']?.toDouble() ?? 0.0;
    int instalment = credit['instalment']?.toInt() ?? 0;
    String aim = credit['aim'] ?? 'No aim';

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = deviceWidth * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Get.offAllNamed('/expense'),
              icon: const Icon(Icons.arrow_back_ios_new_sharp)),
          elevation: 0,
          title: Text(
            bankName,
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.debtCardColors,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: deviceWidth,
        height: deviceHeight,
        decoration: BoxDecoration(
          gradient: AppColors.debtCardColors,
        ),
        child: Obx(() {
          // Kullanıcının ilgili kredileri filtreleme ve ödeme tarihlerini hesaplama
          final filteredCredits = _controller.credits.where((creditDoc) {
            final data = creditDoc.data() as Map<String, dynamic>;
            return data['aim'] == aim;
          }).toList();

          return Column(
            children: [
              Text(
                aim,
                style: GoogleFonts.adamina(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      instalment, // Her bir taksit için kart oluşturulacak
                  itemBuilder: (context, index) {
                    DateTime paymentDate = DateTime.parse(lastPaymentDate)
                        .add(Duration(days: 30 * index));

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4,
                      child: ListTile(
                        leading: Image.asset(imageUrl),
                        title: Text('Payment ${index + 1}'),
                        subtitle: Text('Amount: $monthlyPayment'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Date: ${formatDate(paymentDate)}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showPaymentDialog(
                                    context,
                                    aim,
                                    monthlyPayment,
                                  );
                                },
                                label: Text('Paid'),
                                icon: Icon(Icons.check),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
