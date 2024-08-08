import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                  Color.fromARGB(255, 38, 2, 85),
                  Color.fromARGB(255, 8, 1, 134),
                  Color.fromARGB(255, 48, 5, 95),
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
              Color.fromARGB(255, 38, 2, 85),
              Color.fromARGB(255, 8, 1, 134),
              Color.fromARGB(255, 48, 5, 95),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHeight / 8,
            ),
            Text(
              'welcome, stingy',
              style: GoogleFonts.zillaSlab(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement,
              style: ElevatedButton.styleFrom(
                  elevation: 13,
                  shadowColor: Colors.white,
                  minimumSize: const Size(337.1, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: Text('Log In',
                  style: GoogleFonts.zillaSlab(
                      color: const Color.fromARGB(255, 8, 1, 134),
                      fontSize: 30,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement,
              style: ElevatedButton.styleFrom(
                  elevation: 13,
                  shadowColor: Colors.white,
                  minimumSize: const Size(337.1, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: Text(
                'Sign Up',
                style: GoogleFonts.zillaSlab(
                    color: const Color.fromARGB(255, 8, 1, 134),
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement,
              style: ElevatedButton.styleFrom(
                  elevation: 13,
                  shadowColor: Colors.white,
                  minimumSize: const Size(337.1, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: Text(
                'Continue with Google',
                style: GoogleFonts.zillaSlab(
                    color: const Color.fromARGB(255, 8, 1, 134),
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
