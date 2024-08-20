// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static final Color color1 = HexColor("#C33764"); //expense
  static final Color color2 = HexColor("#1D2671"); //expense
  static final Color color1Crypto = HexColor("#2E3192"); //crypto
  static final Color color2Crypto = HexColor("#1BFFFF"); //crypto

  static LinearGradient defaultColors = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [color1Crypto, color2Crypto],
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
