import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(seconds: 3));
    if (user != null) {
      Get.offAllNamed('/mainmenu');
    } else {
      Get.offAllNamed('/homepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 9, 99),
      body: Center(
        child: Image.asset('lib/assets/logo.png'),
      ),
    );
  }
}
