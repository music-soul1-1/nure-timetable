import 'dart:convert';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class for storing app settings.
class AppSettings {
  Group group;
  String startTime;
  String endTime;
  String language;
  bool useSystemTheme;
  bool darkThemeEnabled;

  AppSettings({
    required this.group,
    required this.startTime,
    required this.endTime,
    required this.language,
    required this.useSystemTheme,
    required this.darkThemeEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'group': group.toJson(), // Convert Group to a Map
      'startTime': startTime,
      'endTime': endTime,
      'language': language,
      'useSystemTheme': useSystemTheme,
      'darkThemeEnabled': darkThemeEnabled,
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
    );
  }

  static AppSettings getDefaultSettings() {
    return AppSettings(
      group: Group(id: "", name: ""),
      startTime: "1693170000",
      endTime: "1706738400",
      language: "uk",
      useSystemTheme: true,
      darkThemeEnabled: false,
    );
  }

  AppSettings copyWith({
    Group? group,
    String? startTime,
    String? endTime,
    String? language,
    bool? useSystemTheme,
    bool? darkThemeEnabled,
  }) {
    return AppSettings(
      group: group ?? this.group,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      language: language ?? this.language,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      darkThemeEnabled: darkThemeEnabled ?? this.darkThemeEnabled,
    );
  }

  /// Checks if all fields are not empty.
  /// 
  /// Returns `true` if all fields are not empty.
  bool checkFields() {
    return group.id.isNotEmpty &&
        group.name.isNotEmpty &&
        startTime.isNotEmpty &&
        endTime.isNotEmpty &&
        language.isNotEmpty &&
        useSystemTheme.toString().isNotEmpty &&
        darkThemeEnabled.toString().isNotEmpty;
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