import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/auth/login.dart';
import 'package:my_app/auth/signup.dart';
import 'package:my_app/screens/cryptoScreens/crypto.dart';
import 'package:my_app/screens/homepage.dart';
import 'package:my_app/screens/mainmenu.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stinginess',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 8, 1, 134),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/splashscreen', // Splash ekranı için başlangıç rotası
      getPages: [
        GetPage(name: '/splashscreen', page: () => const SplashScreen()),
        GetPage(
            name: '/homepage',
            page: () => const Homepage(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/signup',
            page: () => const Signup(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: '/login',
            page: () => const LoginPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/mainmenu',
            page: () => const MainMenu(),
            transition: Transition.fadeIn),
        GetPage(
            name: '/crypto',
            page: () => Crypto(),
            transition: Transition.fadeIn)
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

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
    await Future.delayed(
        const Duration(seconds: 3)); // Splash ekranının görünme süresi
    if (user != null) {
      // Kullanıcı giriş yapmışsa, ana menüye yönlendir
      Get.offAllNamed('/mainmenu');
    } else {
      // Kullanıcı giriş yapmamışsa, giriş sayfasına yönlendir
      Get.offAllNamed('/login');
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
