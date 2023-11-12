import 'package:flutter/material.dart';

var darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00465F),
    brightness: Brightness.dark,
    background: const Color.fromARGB(255, 0, 15, 19),
  ),
  useMaterial3: true,
  fontFamily: 'Inter',
);


var lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00465F),
    brightness: Brightness.light,
    background: const Color.fromARGB(255, 240, 240, 240),
  ),
  useMaterial3: true,
  fontFamily: 'Inter',
);
