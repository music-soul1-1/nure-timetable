// NureTimetable is an app for viewing schedule for groups or teachers of Kharkiv National University of Radio Electronics.
// Copyright (C) 2023-2024  music-soul1-1

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
import 'package:nure_timetable/models/settings.dart';


SnackBar snackbar(String text, {int duration = 1}) {
  return SnackBar(
    content: Text(text),
    duration: Duration(seconds: duration),
  );
}


/// Header for the app bar in home page (uses either group or teacher name).
// ignore: non_constant_identifier_names
AppBar HomeHeader(AppSettings settings, IconData iconData) {
  return AppBar(
    toolbarHeight: 45,
    backgroundColor: const Color(0xFF00465F),
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(iconData,
            size: 28,
            color: const Color(0xFF06DDF6),
          ),
        ),
        Text(
          settings.type == 'group' ? settings.group.name : settings.teacher.shortName,
          style: const TextStyle(
            color: Color(0xFF06DDF6),
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  );
}


/// Header for the app bar.
// ignore: non_constant_identifier_names
AppBar Header(String title, IconData iconData) {
  return AppBar(
    toolbarHeight: 45,
    backgroundColor: const Color(0xFF00465F),
    foregroundColor: const Color(0xFF06DDF6),
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(iconData,
            size: 28,
            color: const Color(0xFF06DDF6),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF06DDF6),
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  );
}