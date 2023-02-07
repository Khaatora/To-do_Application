import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  String langCode = 'en';

  void changeLanguage(String lang) {
    if (langCode == lang) return;
    langCode = lang;
    notifyListeners();
  }
}