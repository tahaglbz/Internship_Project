import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocalizationController extends GetxController {
  Locale _locale = const Locale('en'); // Varsayılan dil İngilizce

  Locale get locale => _locale;

  void changeLocale(String languageCode) {
    Locale newLocale = Locale(languageCode);
    _locale = newLocale;
    Get.updateLocale(newLocale);
  }
}
