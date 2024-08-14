import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/firestore/firestoreService.dart';
import '../widgets/appColors.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final FirestoreService _firestoreService =
      FirestoreService(); // FirestoreService instance

  final List<Map<String, dynamic>> cardData = [
    {"title": "Crypto", 'page': '/crypto', 'gradient': AppColors.defaultColors},
    {
      "title": "Exchange",
      'page': '/exchange',
      'gradient': AppColors.exchangeGradient
    },
    {
      "title": "Portfolio",
      'page': '/portfolio',
      'gradient': AppColors.debtCardColors
    },
    {
      "title": "Analytics",
      'page': '/analytics',
      'gradient': AppColors.analyticsGradient
    },
  ];

  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //   switch (_selectedIndex) {
  //     case 0:
  //       Get.offAllNamed('/mainmenu');
  //       break;
  //     case 1:
  //       Get.offAllNamed('/crypto');
  //       break;
  //     case 2:
  //       Get.offAllNamed('/exchange');
  //       break;
  //     case 3:
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => const Crypto()));
  //       break;
  //   }
  // }

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
          elevation: 0,
          title: Image.asset(
            'lib/assets/logo.png',
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.defaultColors,
            ),
          ),
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: deviceHeight / 1400,
        ),
        Row(
          children: [
            const SizedBox(
              width: 30,
            ),
            Text(
              'Your Investments',
              style: GoogleFonts.adamina(
                  color: Colors.pink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              width: 150,
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: GoogleFonts.adamina(
                          color: Colors.pink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    )),
                const Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Colors.pink,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final gradient = cardData[index]['gradient'] as Gradient? ??
                  AppColors.defaultColors;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(cardData[index]['page']!);
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: gradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: cardData[index]['title'] == 'Crypto'
                            ? StreamBuilder<List<Map<String, dynamic>>>(
                                stream: _firestoreService.getAssets(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No assets found'));
                                  } else {
                                    final assets = snapshot.data!;
                                    final firstTwoAssets =
                                        assets.take(2).toList();
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Crypto',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ...firstTwoAssets.map((asset) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Row(
                                              children: [
                                                Image.network(
                                                  asset['imageUrl'] ?? '',
                                                  width: 12,
                                                  height: 12,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Icon(
                                                        Icons.error,
                                                        size: 12);
                                                  },
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  asset['symbol'] ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(width: 16),
                                                const Text(
                                                  'amount : ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  (asset['amount'] as double?)
                                                          ?.toString() ??
                                                      '0.0',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    );
                                  }
                                },
                              )
                            : cardData[index]['title'] == 'Exchange'
                                ? StreamBuilder<List<Map<String, dynamic>>>(
                                    stream:
                                        _firestoreService.getExcAssetsStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Center(
                                            child: Text('No assets found'));
                                      } else {
                                        final assets = snapshot.data!;
                                        final firstTwoAssets =
                                            assets.take(2).toList();
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Exchange',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            ...firstTwoAssets.map((asset) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      asset['assetIconPath'] ??
                                                          '',
                                                      width: 12,
                                                      height: 12,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.error,
                                                            size: 12);
                                                      },
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      asset['assetName'] ?? '',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    const Text(
                                                      'amount : ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      (asset['amount']
                                                                  as double?)
                                                              ?.toString() ??
                                                          '0.0',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                          ],
                                        );
                                      }
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      cardData[index]['title']!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: cardData.length,
          ),
        )
      ]),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //     selectedIndex: _selectedIndex, onItemTapped
      //     selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
