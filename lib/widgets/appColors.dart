// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  // Dinamik renkler
  static final Color color1 = HexColor("#C33764"); //expense
  static final Color color2 = HexColor("#1D2671"); //expense

  // Sabit LinearGradient tanımları
  static const LinearGradient defaultColors = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 5, 9, 237),
      Color.fromARGB(255, 8, 1, 134),
      Color.fromARGB(255, 5, 0, 74),
    ],
  );

  static const LinearGradient debtCardColorss = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 253, 106, 0),
      Color.fromARGB(255, 134, 62, 1),
      Color.fromARGB(255, 74, 34, 0),
    ],
  );

  static final LinearGradient debtCardColors = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      color1,
      color2,
    ],
  );

  static const LinearGradient exchangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Colors.green,
      Colors.lightGreen,
      Colors.teal,
    ],
  );

  static const LinearGradient analyticsGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
    ],
  );
}
