import 'package:flutter/material.dart';

class AppColors {
  static const defaultColors = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 5, 9, 237),
      Color.fromARGB(255, 8, 1, 134),
      Color.fromARGB(255, 5, 0, 74),
    ],
  );

  static const exchangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 237, 101, 5),
      Color.fromARGB(255, 134, 62, 1),
      Color.fromARGB(255, 74, 34, 0),
    ],
  );

  static const debtCardColors = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Colors.green,
      Colors.lightGreen,
      Colors.teal,
    ],
  );

  static const analyticsGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
    ],
  );
}
