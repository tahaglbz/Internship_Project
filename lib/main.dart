// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/auth/login.dart';
import 'package:my_app/auth/signup.dart';
import 'package:my_app/screens/cryptoScreens/crypto.dart';
import 'package:my_app/screens/exchangeScreens/exchange.dart';
import 'package:my_app/screens/expenseScreens/creditDetails.dart';
import 'package:my_app/screens/expenseScreens/expense.dart';
import 'package:my_app/screens/homepage.dart';
import 'package:my_app/screens/mainmenuScreens/mainmenu.dart';
import 'package:my_app/splashscreen.dart';

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
          seedColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/homepage',
      getPages: [
        GetPage(
            name: '/splashscreen',
            page: () => const SplashScreen(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/homepage',
            page: () => const Homepage(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/signup',
            page: () => const Signup(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/login',
            page: () => const LoginPage(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/mainmenu',
            page: () => const MainMenu(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/crypto',
            page: () => const Crypto(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/exchange',
            page: () => const Exchange(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/expense',
            page: () => const Expense(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/loandetails',
            page: () => const CreditDetails(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
