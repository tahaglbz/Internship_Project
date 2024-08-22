// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/cryptoScreens/CoinMarketCap.dart';
import 'package:my_app/screens/cryptoScreens/amountUpdate.dart';

import '../../auth/firestore/firestoreService.dart';
import '../../widgets/appColors.dart';

class Crypto extends StatefulWidget {
  const Crypto({super.key});

  @override
  State<Crypto> createState() => _CryptoState();
}

class _CryptoState extends State<Crypto> {
  final TextEditingController cryptoCont = TextEditingController();
  final TextEditingController amountCont = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  Map<String, dynamic>? coinData;
  double coinAsset = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchData() async {
    final service = CoinMarketCapService();
    try {
      final data = await service.fetchCoinData(cryptoCont.text.trim());
      setState(() {
        coinData = data['data'][cryptoCont.text.trim()];
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Could not fetch data, please try again.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveAsset() async {
    final coinPrice = coinData?['quote']['USD']['price'] ?? 0.0;
    final usdValue = coinPrice * coinAsset;
    final imageUrl =
        'https://s2.coinmarketcap.com/static/img/coins/64x64/${coinData?['id']}.png';
    final updatedDate = DateTime.now();

    await firestoreService.saveAsset(
        cryptoCont.text.trim(), coinAsset, imageUrl, usdValue, updatedDate);
  }

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
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Get.offAllNamed('/mainmenu'),
              icon: const Icon(Icons.arrow_back_ios_new_sharp)),
          elevation: 0,
          title: Text(
            'Crypto Wallets',
            style: GoogleFonts.adamina(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.defaultColors,
            ),
          ),
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: BoxDecoration(
          gradient: AppColors.defaultColors,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          controller: cryptoCont,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Crypto Symbol',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: amountCont,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Amount',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Image.asset(
                    'lib/assets/ethereum.png',
                    height: 32,
                    width: 32,
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  onPressed: _fetchData,
                  label: const Text(
                    'Get Info',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 8, 1, 134)),
                  ),
                ),
              ),
              if (coinData != null) ...[
                const SizedBox(height: 20),
                Text(
                  'Search',
                  style: GoogleFonts.adamina(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                Card(
                  color: coinData!['quote']['USD']['percent_change_24h'] >= 0
                      ? Colors.green[50]
                      : Colors.red[50],
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              'https://s2.coinmarketcap.com/static/img/coins/64x64/${coinData!['id']}.png',
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coinData!['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Price: \$${coinData!['quote']['USD']['price'].toStringAsFixed(2)}',
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '24h Change: ${coinData!['quote']['USD']['percent_change_24h'].toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          color: coinData!['quote']['USD']
                                                      ['percent_change_24h'] >=
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: Image.asset(
                                            'lib/assets/save-money.png',
                                            height: 24,
                                            width: 24,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size(double.infinity, 40),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 8, 1, 134),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final coinPrice = coinData?['quote']
                                                    ['USD']['price'] ??
                                                0.0;
                                            final newAmount = double.tryParse(
                                                    amountCont.text.trim()) ??
                                                0.0;
                                            final newValueInUsd =
                                                newAmount * coinPrice;
                                            await firestoreService.saveAsset(
                                                cryptoCont.text.trim(),
                                                newAmount,
                                                'https://s2.coinmarketcap.com/static/img/coins/64x64/${coinData?['id']}.png',
                                                newValueInUsd,
                                                DateTime.now());
                                            Get.snackbar('Success',
                                                'Asset saved successfully!',
                                                snackPosition:
                                                    SnackPosition.BOTTOM);
                                          },
                                          label: const Text(
                                            'Save asset',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Your Coins',
                style: GoogleFonts.adamina(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: deviceHeight - (appBarHeight + 400),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: firestoreService.getAssets(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error loading assets');
                    }
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final assets = snapshot.data!;
                    if (assets.isEmpty) {
                      return const Text('No assets found.');
                    }

                    return ListView.builder(
                      itemCount: assets.length,
                      itemBuilder: (context, index) {
                        final asset = assets[index];
                        return Card(
                          margin: const EdgeInsets.all(16.0),
                          child: ListTile(
                            leading: Image.network(
                              asset['imageUrl'] ?? '',
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              height: 40,
                              width: 40,
                            ),
                            title: Text(
                              asset['symbol'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Amount: ${asset['amount'].toStringAsFixed(2)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final coinPrice = coinData?['quote']['USD']
                                            ['price'] ??
                                        0.0;
                                    if (coinPrice != 0.0) {
                                      showAmountDialog(
                                          context, asset['symbol'], coinPrice);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                              'Coin data is not available. Please fetch data first.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.purple,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => firestoreService
                                      .deleteAsset(asset['symbol']),
                                ),
                              ],
                            ),
                            onTap: () {
                              cryptoCont.text = asset['symbol'];
                              amountCont.text = asset['amount'].toString();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
