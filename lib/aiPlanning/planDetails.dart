import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/extensions/media_query.dart';

class PlanDetails extends StatefulWidget {
  const PlanDetails({super.key});

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
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
            'Plan Details',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
    );
  }
}
