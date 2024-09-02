import 'package:nure_timetable/models/auditory.dart';
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
  int? startTime;
  int? endTime;
  String language;
  bool useSystemTheme;
  bool darkThemeEnabled;
  ThemeColors themeColors;
  bool scrollToFirstLesson;

  /// Type of schedule: group or teacher.
  EntityType type = EntityType.group;

  /// Last time schedule was updated (UNIX timestamp).
  int lastUpdated;

  AppSettings({
    required this.group,
    required this.teacher,
    required this.auditory,
    this.startTime,
    this.endTime,
    required this.language,
    required this.useSystemTheme,
    required this.darkThemeEnabled,
    required this.themeColors,
    required this.type,
    this.lastUpdated = 0,
    this.scrollToFirstLesson = true,
  });

  static AppSettings getDefaultSettings() {
    return AppSettings(
      group: Group(id: 0, name: "", direction: Entity(id: 0, shortName: "", fullName: ""), faculty: Entity(id: 0, shortName: "", fullName: "")),
      teacher: Teacher(id: 0, shortName: "", fullName: "", department: Entity(id: 0, shortName: "", fullName: ""), faculty: Entity(id: 0, shortName: "", fullName: "")),
      auditory: Auditory(id: 0, name: "", floor: 0, hasPower: false, auditoryTypes: [], building: Building(id: "", shortName: "", fullName: "")),
      startTime: null,
      endTime: null,
      language: "uk",
      useSystemTheme: true,
      darkThemeEnabled: false,
      themeColors: ThemeColors.getDefaultColors(),
      type: EntityType.group,
      lastUpdated: 0,
      scrollToFirstLesson: true,
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
    bool? scrollToFirstLesson,
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
      scrollToFirstLesson: scrollToFirstLesson ?? this.scrollToFirstLesson,
    );
  }
}
