import 'package:flutter/material.dart';

var darkTheme = ThemeData(
  scaffoldBackgroundColor:const Color.fromARGB(255, 0, 15, 19),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00465F),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  fontFamily: 'Inter',
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.fixed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    insetPadding: EdgeInsets.all(10),
    backgroundColor: Color(0xFF00465F),
    contentTextStyle: TextStyle(
      color: Color(0xFF06DDF6),
      fontSize: 14,
      fontFamily: 'Inter'
    ),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF0d242c),
  )
);


var lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00465F),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  fontFamily: 'Inter',
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.fixed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    insetPadding: EdgeInsets.all(10),
    backgroundColor: Color(0xFF00465F),
    contentTextStyle: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 14,
      fontFamily: 'Inter'
    ),
  ),
);
