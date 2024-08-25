import 'package:nure_timetable/models/auditory.dart';
import 'package:nure_timetable/models/auditory_type.dart';
import 'package:nure_timetable/models/building.dart';
import 'package:nure_timetable/models/entity.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/types/entity_type.dart';
import 'package:nure_timetable/models/theme_colors.dart';

/// Class for storing app settings.
class AppSettings {
  Group group;
  Teacher teacher;
  Auditory auditory;
  int startTime;
  int endTime;
  String language;
  bool useSystemTheme;
  bool darkThemeEnabled;
  ThemeColors themeColors;

  /// Type of schedule: group or teacher.
  EntityType type = EntityType.group;

  /// Last time schedule was updated (UNIX timestamp).
  int lastUpdated;

  AppSettings({
    required this.group,
    required this.teacher,
    required this.auditory,
    required this.startTime,
    required this.endTime,
    required this.language,
    required this.useSystemTheme,
    required this.darkThemeEnabled,
    required this.themeColors,
    required this.type,
    this.lastUpdated = 0,
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
      'auditory': auditory.toJson(),
      'type': type.index,
      'lastUpdated': lastUpdated,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      group: Group.fromJson(json['group']), // Convert Map to Group object
      teacher: Teacher.fromJson(json['teacher']),
      auditory: Auditory.fromJson(json['auditory']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      language: json['language'],
      useSystemTheme: json['useSystemTheme'],
      darkThemeEnabled: json['darkThemeEnabled'],
      themeColors: ThemeColors.fromJson(json['themeColors']),
      type: switch (json['type']) {
        (0) => EntityType.group,
        (1) => EntityType.teacher,
        (2) => EntityType.auditory,
        null => EntityType.group,
        dynamic => EntityType.group, // default value
        Object() => EntityType.group,
      },
      lastUpdated: json['lastUpdated'],
    );
  }

  static AppSettings getDefaultSettings() {
    return AppSettings(
      group: Group(id: 0, name: "", direction: Entity(id: 0, shortName: "", fullName: ""), faculty: Entity(id: 0, shortName: "", fullName: "")),
      teacher: Teacher(id: 0, shortName: "", fullName: "", department: Entity(id: 0, shortName: "", fullName: ""), faculty: Entity(id: 0, shortName: "", fullName: "")),
      auditory: Auditory(id: 0, name: "", floor: 0, hasPower: false, auditoryTypes: List<AuditoryType>.empty(), building: Building(id: "", shortName: "", fullName: "")),
      startTime: DateTime.now().subtract(const Duration(days: 180)).millisecondsSinceEpoch ~/ 1000, // TODO: automatically set start time as the beginning of the current semester
      endTime: DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch ~/ 1000,
      language: "uk",
      useSystemTheme: true,
      darkThemeEnabled: false,
      themeColors: ThemeColors.getDefaultSettings(),
      type: EntityType.group,
      lastUpdated: 0,
    );
  }

  AppSettings copyWith({
    Group? group,
    Teacher? teacher,
    Auditory? auditory,
    int? startTime,
    int? endTime,
    String? language,
    bool? useSystemTheme,
    bool? darkThemeEnabled,
    ThemeColors? themeColors,
    EntityType? type,
    int? lastUpdated,
  }) {
    return AppSettings(
      group: group ?? this.group,
      teacher: teacher ?? this.teacher,
      auditory: auditory ?? this.auditory,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      language: language ?? this.language,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      darkThemeEnabled: darkThemeEnabled ?? this.darkThemeEnabled,
      themeColors: themeColors ?? this.themeColors,
      type: type ?? this.type,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Checks if all fields are not empty.
  /// 
  /// Returns `true` if all fields are not empty.
  bool checkFields() {
    return group.id.toString().isNotEmpty &&
        group.name.isNotEmpty &&
        teacher.shortName.isNotEmpty &&
        auditory.name.isNotEmpty &&
        startTime.toString().isNotEmpty &&
        endTime.toString().isNotEmpty &&
        language.isNotEmpty &&
        useSystemTheme.toString().isNotEmpty &&
        darkThemeEnabled.toString().isNotEmpty &&
        themeColors.lecture.toString().isNotEmpty &&
        type.toString().isNotEmpty &&
        lastUpdated.toString().isNotEmpty;
  }
}
