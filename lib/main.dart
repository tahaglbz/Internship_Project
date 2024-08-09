import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/auth/login.dart';
import 'package:my_app/auth/signup.dart';
import 'package:my_app/screens/homepage.dart';

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
          seedColor: const Color.fromARGB(255, 0, 5, 142),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/homepage', // Set your initial route
      getPages: [
        GetPage(name: '/homepage', page: () => const Homepage()),
        GetPage(name: '/signup', page: () => const Signup()),
        GetPage(name: '/login', page: () => const LoginPage()),
        // Add other routes here
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
