import 'package:flutter/material.dart';
import 'package:my_app/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stinginess',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 5, 142)),
        useMaterial3: true,
      ),
      home: const Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
