import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/screens/cryptoScreens/CoinMarketCap.dart';
import 'package:my_app/screens/cryptoScreens/amountUpdate.dart';

import '../../auth/firestore/firestoreService.dart';

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
  double? coinPrice;
  double? totalValue;

  @override
  void initState() {
    super.initState();
    _loadExistingAsset();
  }

  Future<void> _loadExistingAsset() async {
    String cryptoSymbol = cryptoCont.text.trim();
    if (cryptoSymbol.isEmpty) return;

    final assetData = await firestoreService.getAsset(cryptoSymbol);
    if (assetData != null) {
      setState(() {
        coinAsset = assetData['amount'] ?? 0.0;
        amountCont.text = coinAsset.toString();
      });
    }
  }

  Future<void> _fetchAndCalculateTotalValue() async {
    final service = CoinMarketCapService();

    try {
      final data = await service.fetchCoinData(cryptoCont.text.trim());
      setState(() {
        coinPrice =
            data['data'][cryptoCont.text.trim()]['quote']['USD']['price'];
      });

      final assetData = await firestoreService.getAsset(cryptoCont.text.trim());
      if (assetData != null) {
        setState(() {
          coinAsset = assetData['amount'] ?? 0.0;
        });
      }

      if (coinPrice != null) {
        setState(() {
          totalValue = coinPrice! * coinAsset;
        });
      } else {
        setState(() {
          totalValue = null;
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Could not fetch data, please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        totalValue = null;
      });
    }
  }

  Future<void> _fetchData() async {
    final service = CoinMarketCapService();
    try {
      final data = await service.fetchCoinData(cryptoCont.text.trim());
      setState(() {
        coinData = data['data'][cryptoCont.text.trim()];
      });
      _loadExistingAsset();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Could not fetch data, please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void fetchAmount() {
    setState(() {
      coinAsset = double.tryParse(amountCont.text.trim()) ?? 0.0;
    });
  }

  Future<void> _saveAsset() async {
    fetchAmount();
    final imageUrl =
        'https://s2.coinmarketcap.com/static/img/coins/64x64/${coinData!['id']}.png';
    await firestoreService.saveAsset(
        cryptoCont.text.trim(), coinAsset, imageUrl);
    _loadExistingAsset();
  }

  @override
  Widget build(BuildContext context) {
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 5, 9, 237),
                  Color.fromARGB(255, 8, 1, 134),
                  Color.fromARGB(255, 5, 0, 74),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 5, 9, 237),
              Color.fromARGB(255, 8, 1, 134),
              Color.fromARGB(255, 5, 0, 74),
            ],
          ),
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
                                          onPressed: _saveAsset,
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
                                    onPressed: () {
                                      showAmountDialog(
                                          context, asset['symbol']);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                  icon: const Icon(Icons.delete),
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