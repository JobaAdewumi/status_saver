import 'package:all_status_saver/helpers/storage_manager.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  static const MaterialColor darkSwatch =
      MaterialColor(0xFF25434F, <int, Color>{
    50: Color(0xFFE0F2F1),
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF009688),
    600: Color(0xFF00897B),
    700: Color(0xFF00796B),
    800: Color(0xFF00695C),
    900: Color(0xFF004D40),
  });

  static const MaterialColor lightSwatch =
      MaterialColor(0xFF99CDD1, <int, Color>{
    50: Color(0xFFE0F2F1),
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF009688),
    600: Color(0xFF00897B),
    700: Color(0xFF00796B),
    800: Color(0xFF00695C),
    900: Color(0xFF004D40),
  });

  final darkTheme = ThemeData(
    dividerColor: Colors.white54,
    primarySwatch: darkSwatch,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 37, 67, 79),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 35, 41, 46),
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 35, 41, 46),
    primaryColorDark: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
        primary: darkSwatch, surface: darkSwatch, onSurface: Colors.black),
  );

  final lightTheme = ThemeData(
      dividerColor: Colors.black54,
      primarySwatch: lightSwatch,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 172, 200, 202),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Color.fromARGB(255, 153, 205, 209),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 203, 212, 212),
      // accentColor: Colors.black,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 153, 205, 209),
      ));

  late ThemeData _themeData = lightTheme;
  late String _currentTheme = 'light';

  ThemeNotifier() {
    StorageManager.readData('themeMode').then(
      (value) {
        var themeMode = value ?? 'light';
        if (themeMode == 'light') {
          _themeData = lightTheme;
          _currentTheme = 'light';
        } else {
          _themeData = darkTheme;
          _currentTheme = 'dark';
        }
        notifyListeners();
      },
    );
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  ThemeData getTheme() => _themeData;
  String getCurrentTheme() => _currentTheme;
}
