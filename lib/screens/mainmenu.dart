import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/widgets/CustomBottomNav.dart';
import 'package:my_app/screens/cryptoScreens/crypto.dart';
import '../widgets/appColors.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final List<Map<String, dynamic>> cardData = [
    {"title": "Crypto", 'page': '/crypto', 'gradient': AppColors.defaultColors},
    {
      "title": "Exchange",
      'page': '/exchange',
      'gradient': AppColors.defaultColors
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

  int _selectedIndex = 0;

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
        Get.offAllNamed('/exchange');
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Crypto()));
        break;
    }
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
          elevation: 0,
          title: Image.asset(
            'lib/assets/logo.png',
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
        Container(
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
              );
            },
            itemCount: cardData.length,
          ),
        )
      ]),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
