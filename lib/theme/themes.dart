// NureTimetable is an app for viewing schedule for groups or teachers of Kharkiv National University of Radio Electronics.
// Copyright (C) 2023  music-soul1-1

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.


import 'package:flutter/material.dart';

var darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00465F),
    brightness: Brightness.dark,
    background: const Color.fromARGB(255, 0, 15, 19)
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
);


var lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00465F),
    brightness: Brightness.light,
    background: const Color.fromARGB(255, 240, 240, 240),
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
