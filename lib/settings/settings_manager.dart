import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nure_timetable/models/auditory.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/settings.dart' as app_settings;
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/models/theme_colors.dart';
import 'package:nure_timetable/types/entity_type.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Settings manager for the app.
class SettingsManager with ChangeNotifier {
  var _settings = app_settings.AppSettings.getDefaultSettings();
  var _schedule = <Lesson>[];

  app_settings.AppSettings get settings => _settings;
  set settings(app_settings.AppSettings value) {
    _settings = value;
    notifyListeners();
  }

  List<Lesson> get schedule => _schedule;
  set schedule(List<Lesson> value) {
    _schedule = value;
    notifyListeners();
  }

  /// Removes settings from SharedPreferences. Optionally removes schedule.
  void removeSettings({bool removeSchedule = false}) {
    SharedPreferences.getInstance()
        .then((value) {
          value.remove("appSettings");

          value.remove("group");
          value.remove("teacher");
          value.remove("auditory");
          value.remove("startTime");
          value.remove("endTime");
          value.remove("language");
          value.remove("useSystemTheme");
          value.remove("darkThemeEnabled");
          value.remove("themeColors");
          value.remove("type");
          value.remove("lastUpdated");
          value.remove("scrollToFirstLesson");

          if (removeSchedule) {
            value.remove("schedule");
          }
        });
    
    _settings = app_settings.AppSettings.getDefaultSettings();
    notifyListeners();
  }

  /// Loads settings from SharedPreferences.
  Future<app_settings.AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    try {
      final settings = app_settings.AppSettings(
        group: Group.fromJson(jsonDecode(prefs.getString("group") ?? "")), 
        teacher: Teacher.fromJson(jsonDecode(prefs.getString("teacher") ?? "")), 
        auditory: Auditory.fromJson(jsonDecode(prefs.getString("auditory") ?? "")), 
        startTime: prefs.getInt("startTime") != 0 ? prefs.getInt("startTime") : null, 
        endTime: prefs.getInt("endTime") != 0 ? prefs.getInt("endTime") : null, 
        language: prefs.getString("language") ?? "uk", 
        useSystemTheme: prefs.getBool("useSystemTheme") ?? true, 
        darkThemeEnabled: prefs.getBool("darkThemeEnabled") ?? true, 
        themeColors: ThemeColors.fromJson(jsonDecode(prefs.getString("themeColors") ?? "")), 
        type: EntityType.values[prefs.getInt("type") ?? 0],
        lastUpdated: prefs.getInt("lastUpdated") ?? 0,
        scrollToFirstLesson: prefs.getBool("scrollToFirstLesson") ?? true,
      );

      _settings = settings;
    }
    catch (e) {
      if (kDebugMode) {
        print("Error while loading settings: $e");
      }

      await prefs.clear(); // TODO: add keys check, and remove only invalid keys
      
      _settings = app_settings.AppSettings.getDefaultSettings();

      await saveSettings(_settings);
    }

    notifyListeners();

    return _settings;
  }

  /// Loads schedule from SharedPreferences.
  Future<List<Lesson>> loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleJsonList = prefs.getStringList("schedule");

    try {
      if (scheduleJsonList == null) {
        _schedule = [];

        return [];
      }

      _schedule = scheduleJsonList
          .map((jsonString) => Lesson.fromJson(jsonDecode(jsonString)))
          .toList();      
    }
    catch (e) {
      if (kDebugMode) {
        print("Error while loading schedule: $e");
      }

      await prefs.clear();

      _schedule = [];

      await saveSchedule(_schedule);
    }

    notifyListeners();

    return _schedule;
  }

  /// Saves settings in SharedPreferences.
  Future<app_settings.AppSettings> saveSettings(app_settings.AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("group", jsonEncode(settings.group));
    prefs.setString("teacher", jsonEncode(settings.teacher));
    prefs.setString("auditory", jsonEncode(settings.auditory));
    prefs.setInt("startTime", settings.startTime ?? 0);
    prefs.setInt("endTime", settings.endTime ?? 0);
    prefs.setString("language", settings.language);
    prefs.setBool("useSystemTheme", settings.useSystemTheme);
    prefs.setBool("darkThemeEnabled", settings.darkThemeEnabled);
    prefs.setString("themeColors", jsonEncode(settings.themeColors));
    prefs.setInt("type", settings.type.index);
    prefs.setInt("lastUpdated", settings.lastUpdated);
    prefs.setBool("scrollToFirstLesson", settings.scrollToFirstLesson);

    _settings = settings;
    notifyListeners();

    return _settings;
  }

  /// Saves schedule in 'schedule' key in SharedPreferences.
  Future<void> saveSchedule(List<Lesson>? lessons) async {
    if (lessons == null) {
      return;
    }
    
    final scheduleJsonList = lessons.map((lesson) => jsonEncode(lesson.toJson())).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("schedule", scheduleJsonList);

    _schedule = lessons;
    notifyListeners();
  }

  Lesson? getFirstLesson() {
    if (_schedule.isEmpty) {
      return null;
    }

    return (_schedule..sort((a, b) => a.startTime.compareTo(b.startTime))).first;
  }
}
