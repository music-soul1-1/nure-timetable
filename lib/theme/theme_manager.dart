import 'package:flutter/material.dart';


/// Manager for switching between light and dark themes.
class ThemeManager with ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  toggleTheme(bool isDark){
    _themeMode = isDark?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
}

