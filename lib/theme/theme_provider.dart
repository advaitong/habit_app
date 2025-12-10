import 'package:flutter/material.dart';
import 'package:habit_app/theme/dark_mode.dart';
import 'package:habit_app/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // Initialize to darkMode to make it the default
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
