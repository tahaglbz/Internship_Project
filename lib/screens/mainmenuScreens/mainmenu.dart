// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/analysisAndGraphs/IncExpChart.dart';
import 'package:my_app/screens/mainmenuScreens/mainmenuController.dart';
import '../../widgets/CustomBottomNav.dart';
import '../../widgets/appColors.dart';
import '../analysisAndGraphs/datas.dart';

class MainMenu extends StatefulWidget {
  MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  MainMenuController mainMenuController = MainMenuController();
  int _selectedIndex = 0;
  double incomeTotal = 0.0;
  double expenseTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dataService = DataService();

    try {
      final income = await dataService.getTotalIncome();
      final expenses = await dataService.getTotalExpenses();

      setState(() {
        incomeTotal = income;
        expenseTotal = expenses;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Get.offAllNamed('/mainmenu');
        break;
      case 1:
        Get.offAllNamed('/crypto');

        break;
      case 2:
        Get.offAllNamed('/expense');
        break;
      case 3:
        Get.offAllNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;
    double appBarHeight = deviceWidth * 0.28;

    final List<Map<String, dynamic>> cardData = [
      {
        "title": "Crypto",
        'page': '/crypto',
        'gradient': AppColors.defaultColors
      },
      {
        "title": "Exchange",
        'page': '/exchange',
        'gradient': AppColors.exchangeGradient
      },
      {
        "title": "Expense",
        'page': '/expense',
        'gradient': AppColors.debtCardColors
      },
      {
        "title": "Portfolio",
        'page': '/analytics',
        'gradient': AppColors.analyticsGradient
      },
    ];

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
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
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
              'Pages',
              style: GoogleFonts.adamina(
                  color: const Color.fromARGB(255, 0, 9, 99),
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: GoogleFonts.adamina(
                          color: const Color.fromARGB(255, 0, 9, 99),
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    )),
                const Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: const Color.fromARGB(255, 0, 9, 99),
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
                    Navigator.pushNamed(context, cardData[index]['page']!);
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
                                stream: mainMenuController.getAssetsStream(),
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
                                    return const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Crypto',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'No assets found',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    );
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
                                        mainMenuController.getExcAssetsStream(),
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
                                        return const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Exchange',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'No assets found',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        );
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
                                : cardData[index]['title'] == 'Expense'
                                    ? StreamBuilder<List<Map<String, dynamic>>>(
                                        stream: mainMenuController
                                            .getUnPaidExpendes(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Expense',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'No expenses found',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            );
                                          } else {
                                            final assets = snapshot.data!;
                                            final firstOneAssets =
                                                assets.take(2).toList();
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Expense',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                ...firstOneAssets.map((asset) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4.0),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          asset['imageUrl'] ??
                                                              '',
                                                          width: 12,
                                                          height: 12,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Icon(
                                                                Icons.error,
                                                                size: 12);
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          asset['expName'] ??
                                                              '',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            width: 16),
                                                        const Text(
                                                          'date : ',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          asset['lastPaymentDate'] !=
                                                                  null
                                                              ? DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(DateTime
                                                                      .parse(asset[
                                                                              'lastPaymentDate']
                                                                          as String))
                                                              : 'N/A',
                                                          style:
                                                              const TextStyle(
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
        ),
        SizedBox(
          height: deviceHeight / 50,
        ),
        SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed('/graph'),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Adjust the padding as needed
                    child: Stack(
                      children: [
                        Card(
                          elevation: 9.0,
                          shadowColor: AppColors.defaultColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            width: deviceWidth * 0.9,
                            height: deviceHeight * 0.35,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.defaultColor,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: incomeTotal > 0 && expenseTotal > 0
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IncomeExpenseChart(
                                      incomeTotal: incomeTotal,
                                      expenseTotal: expenseTotal,
                                    ),
                                  )
                                : const Center(child: Text('Loading...')),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: const Text(
                              'Graphics',
                              style: TextStyle(
                                color: AppColors.defaultColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10), // Kartlar arasında boşluk

                Card(
                  elevation: 9.0,
                  shadowColor: AppColors.defaultColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    width: deviceWidth * 0.9,
                    height: deviceHeight * 0.35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.defaultColor,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Yeni Kart',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ]),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
