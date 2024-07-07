// Copyright (C) 2023-2024  music-soul1-1

// You should have received a copy of the GNU General Public License 
// along with this program.  If not, see <https://www.gnu.org/licenses/>.


import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nure_timetable/models/settings.dart' as app_settings;
import 'package:nure_timetable/models/lesson.dart';
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

  String _settingsToJson(app_settings.AppSettings settings) {
    return jsonEncode(settings.toJson());
  }

  app_settings.AppSettings _settingsFromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return app_settings.AppSettings.fromJson(data);
  }

  /// Removes settings from SharedPreferences. Optionally removes schedule.
  void removeSettings({bool removeSchedule = false}) {
    SharedPreferences.getInstance()
        .then((value) {
          value.remove('appSettings');
          removeSchedule ? value.remove('schedule') : null;
        });
    _settings = app_settings.AppSettings.getDefaultSettings();
    notifyListeners();
  }

  /// Loads settings from SharedPreferences.
  Future<app_settings.AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('appSettings');

    try {
      if (jsonString == null) {
        throw Exception('Settings not found in SharedPreferences.');
      }

      _settings = _settingsFromJson(jsonString);
    }
    catch (e) {
      if (kDebugMode) {
        print('Error while loading settings: $e');
      }

      await prefs.clear();
      
      _settings = app_settings.AppSettings.getDefaultSettings();

      await saveSettings(_settings);
    }

    notifyListeners();

    return _settings;
  }

  /// Loads schedule from SharedPreferences.
  Future<List<Lesson>> loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleJsonList = prefs.getStringList('schedule');

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
        print('Error while loading schedule: $e');
      }

      await prefs.clear();

      _schedule = [];

      await saveSchedule(_schedule);
    }

    notifyListeners();

    return _schedule;
  }

  /// Saves settings in 'appSettings' key in SharedPreferences.
  Future<app_settings.AppSettings> saveSettings(app_settings.AppSettings settings) async {
    final jsonString = _settingsToJson(settings);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('appSettings', jsonString);

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
    prefs.setStringList('schedule', scheduleJsonList);

    _schedule = lessons;
    notifyListeners();
  }
}