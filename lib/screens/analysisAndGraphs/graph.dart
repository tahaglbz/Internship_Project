import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/extensions/media_query.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
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
          title: Image.asset(
            'lib/assets/logo.png',
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
    );
  }
}
