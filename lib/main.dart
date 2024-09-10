// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/Lang/LocalizationController.dart';
import 'package:my_app/generated/l10n.dart';
import 'package:my_app/screens/Forum/forum.dart';
import 'package:my_app/screens/aiPlanning/planDetails.dart';
import 'package:my_app/screens/aiPlanning/planning.dart';
import 'package:my_app/auth/login.dart';
import 'package:my_app/auth/signup.dart';
import 'package:my_app/screens/analysisAndGraphs/graph.dart';
import 'package:my_app/screens/cryptoScreens/crypto.dart';
import 'package:my_app/screens/education/education.dart';
import 'package:my_app/screens/exchangeScreens/exchange.dart';
import 'package:my_app/screens/expenseScreens/creditDetail/creditDetails.dart';
import 'package:my_app/screens/expenseScreens/expense.dart';
import 'package:my_app/screens/homepage.dart';
import 'package:my_app/screens/mainmenuScreens/mainmenu.dart';
import 'package:my_app/screens/profile/profile.dart';
import 'package:my_app/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // BU SATIRI EKLEYİN
import 'firebase_options.dart';
import 'widgets/ThemeController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        AndroidProvider.playIntegrity, // Android'de Play Integrity kullan
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final LocalizationController localizationController =
        Get.put(LocalizationController());

    return GetMaterialApp(
      title: 'Stinginess',
      themeMode: themeController.theme,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 16, 1, 10),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      locale: localizationController.locale,
      fallbackLocale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: '/mainmenu',
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
            page: () => CreditDetails(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/graph',
            page: () => const Graph(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/profile',
            page: () => ProfilePage(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            name: '/planning',
            page: () => const Planning(),
            transition: Transition.cupertinoDialog,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
          name: '/planDetail',
          page: () => PlanDetails(),
          transition: Transition.cupertinoDialog,
          transitionDuration: const Duration(seconds: 1),
        ),
        GetPage(
          name: '/education',
          page: () => const Education(),
          transition: Transition.cupertinoDialog,
          transitionDuration: const Duration(seconds: 1),
        ),
        GetPage(
          name: '/forum',
          page: () => const Forum(),
          transition: Transition.cupertinoDialog,
          transitionDuration: const Duration(seconds: 1),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
