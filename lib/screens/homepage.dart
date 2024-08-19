import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/auth/authservice.dart';
import 'package:my_app/auth/login.dart';
import 'package:my_app/auth/signup.dart';

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
    final AuthService authService = Get.put(AuthService());

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
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 9, 99),
        width: deviceWidth,
        height: deviceHeight,
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
            ElevatedButton.icon(
              icon: Image.asset(
                'lib/assets/log-in.png',
                height: 32,
                width: 32,
              ),
              onPressed: () =>
                  Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              )),
              style: ElevatedButton.styleFrom(
                  elevation: 13,
                  minimumSize: const Size(369.1, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              label: Text('Log In',
                  style: GoogleFonts.zillaSlab(
                      color: const Color.fromARGB(255, 8, 1, 134),
                      fontSize: 30,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton.icon(
              icon: Image.asset(
                'lib/assets/add-friend.png',
                height: 32,
                width: 32,
              ),
              onPressed: () =>
                  Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const Signup();
                },
              )),
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.white,
                  minimumSize: const Size(369.1, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              label: Text('Sign Up',
                  style: GoogleFonts.zillaSlab(
                      color: const Color.fromARGB(255, 8, 1, 134),
                      fontSize: 30,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton.icon(
              icon: Image.asset(
                'lib/assets/google.png',
                height: 32,
                width: 32,
              ),
              onPressed: () => authService.signWithGoogle(context),
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.white,
                  minimumSize: const Size(337.1, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              label: Text('Continue with Google',
                  style: GoogleFonts.zillaSlab(
                      color: const Color.fromARGB(255, 8, 1, 134),
                      fontSize: 30,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
