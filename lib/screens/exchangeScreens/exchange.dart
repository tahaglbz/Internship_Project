import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/exchangeScreens/assetController.dart';
import 'package:my_app/screens/exchangeScreens/assetDialog.dart';
import 'package:my_app/screens/exchangeScreens/updateAssetDialog.dart';

import '../../widgets/appColors.dart';

class Exchange extends StatelessWidget {
  const Exchange({super.key});

  @override
  Widget build(BuildContext context) {
    final AssetController assetController = Get.put(AssetController());

    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;
    double appBarHeight = deviceWidth * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Get.offAllNamed('/mainmenu'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          elevation: 0,
          title: Column(
            children: [
              Text(
                'Exchange Wallet',
                style: GoogleFonts.adamina(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.exchangeGradient,
            ),
          ),
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          gradient: AppColors.exchangeGradient,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Choose your asset',
                style: GoogleFonts.adamina(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => showAssetDialog(context),
                label: const Text(
                  'Save Assets',
                  style: TextStyle(color: Colors.black),
                ),
                icon: Image.asset('lib/assets/money.png'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    minimumSize: const Size(200, 60)),
              ),
              const SizedBox(height: 50),
              Text(
                'Your Assets: ',
                style: GoogleFonts.adamina(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 30),
              Obx(() {
                if (assetController.assets.isEmpty) {
                  return const Text(
                    'No assets found',
                    style: TextStyle(
                        color: Color.fromARGB(255, 158, 123, 120),
                        fontSize: 16),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: assetController.assets.length,
                    itemBuilder: (context, index) {
                      final asset = assetController.assets[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.asset(asset['assetIconPath']),
                          title: Text(
                            asset['assetName'],
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text('Amount: ${asset['amount']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.purple,
                                onPressed: () {
                                  showUpdateDia(context, asset['assetName'],
                                      asset['amount'], asset['assetIconPath']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  assetController
                                      .deleteAsset(asset['assetName']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
