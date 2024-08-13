import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/widgets/CustomBottomNav.dart';
import 'package:my_app/screens/cryptoScreens/crypto.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
          elevation: 0, // Gölgeleri kaldırmak için elevation sıfırlanır
          title: Image.asset(
            'lib/assets/logo.png',
            // AppBar yüksekliğine göre logo yüksekliği
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft, // Aynı yönü sağlamak için
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
            begin: Alignment.centerLeft, // AppBar ile aynı yönü sağlamak için
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 5, 9, 237),
              Color.fromARGB(255, 8, 1, 134),
              Color.fromARGB(255, 5, 0, 74),
            ],
          )),
          child: Column()),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}
