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


import 'dart:convert';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nure_timetable/models/theme_colors.dart';

/// Class for storing app settings.
class AppSettings {
  Group group;
  int startTime;
  int endTime;
  String language;
  bool useSystemTheme;
  bool darkThemeEnabled;
  ThemeColors themeColors;
  Teacher teacher;
  /// Type of schedule: group or teacher.
  String type = "group";

  AppSettings({
    required this.group,
    required this.startTime,
    required this.endTime,
    required this.language,
    required this.useSystemTheme,
    required this.darkThemeEnabled,
    required this.themeColors,
    required this.teacher,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'group': group.toJson(), // Convert Group to a Map
      'startTime': startTime,
      'endTime': endTime,
      'language': language,
      'useSystemTheme': useSystemTheme,
      'darkThemeEnabled': darkThemeEnabled,
      'themeColors': themeColors.toJson(),
      'teacher': teacher.toJson(),
      'type': type,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      group: Group.fromJson(json['group']), // Convert Map to Group object
      startTime: json['startTime'],
      endTime: json['endTime'],
      language: json['language'],
      useSystemTheme: json['useSystemTheme'],
      darkThemeEnabled: json['darkThemeEnabled'],
      themeColors: ThemeColors.fromJson(json['themeColors']),
      teacher: Teacher.fromJson(json['teacher']),
      type: json['type'],
    );
  }

  static AppSettings getDefaultSettings() {
    return AppSettings(
      group: Group(id: 0, name: ""),
      startTime: 1693170000,
      endTime: 1706738400,
      language: "uk",
      useSystemTheme: true,
      darkThemeEnabled: false,
      themeColors: ThemeColors(
        lecture: "0xFFAD8827",
        practice: "0xFF1C8834",
        laboratory: "0xFF5A2194",
        consultation: "0xFF1E7F85",
        exam: "0xFF8E1D1D",
        other: "0xFF9A1A95",
      ),
      teacher: Teacher(id: 0, shortName: "", fullName: ""),
      type: "group",
    );
  }

  AppSettings copyWith({
    Group? group,
    int? startTime,
    int? endTime,
    String? language,
    bool? useSystemTheme,
    bool? darkThemeEnabled,
    ThemeColors? themeColors,
    Teacher? teacher,
    String? type,
  }) {
    return AppSettings(
      group: group ?? this.group,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      language: language ?? this.language,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      darkThemeEnabled: darkThemeEnabled ?? this.darkThemeEnabled,
      themeColors: themeColors ?? this.themeColors,
      teacher: teacher ?? this.teacher,
      type: type ?? this.type,
    );
  }

  /// Checks if all fields are not empty.
  /// 
  /// Returns `true` if all fields are not empty.
  bool checkFields() {
    return group.id.toString().isNotEmpty &&
        group.name.isNotEmpty &&
        startTime.toString().isNotEmpty &&
        endTime.toString().isNotEmpty &&
        language.isNotEmpty &&
        useSystemTheme.toString().isNotEmpty &&
        darkThemeEnabled.toString().isNotEmpty &&
        themeColors.lecture.toString().isNotEmpty &&
        teacher.shortName.isNotEmpty &&
        type.isNotEmpty;
  }
}


String settingsToJson(AppSettings settings) {
  return jsonEncode(settings.toJson());
}

AppSettings settingsFromJson(String jsonString) {
  final Map<String, dynamic> data = jsonDecode(jsonString);
  return AppSettings.fromJson(data);
}

void removeSettings({bool removeSchedule = false}) {
  SharedPreferences.getInstance()
      .then((value) {
        value.remove('appSettings');
        removeSchedule ? value.remove('schedule') : null;
      });
}


Future<AppSettings> loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('appSettings');

  if (jsonString == null) {
    return AppSettings.getDefaultSettings();
  }

  return settingsFromJson(jsonString);
}

Future<List<Lesson>> loadSchedule() async {
  final prefs = await SharedPreferences.getInstance();
  final scheduleJsonList = prefs.getStringList('schedule');

  if (scheduleJsonList == null) {
    return [];
  }

  return scheduleJsonList
      .map((jsonString) => Lesson.fromJson(jsonDecode(jsonString)))
      .toList();
}

Future<void> saveSchedule(List<Lesson> lessons) async {
  final prefs = await SharedPreferences.getInstance();
  final scheduleJsonList = lessons.map((lesson) => jsonEncode(lesson.toJson())).toList();
  prefs.setStringList('schedule', scheduleJsonList);
}

/// Saves settings in 'appSettings' key in SharedPreferences.
Future<AppSettings> saveSettings(AppSettings settings) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = settingsToJson(settings);
  prefs.setString('appSettings', jsonString);

  return settings;
}
