import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nure_timetable/models/auditory.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/models/lesson_type.dart';


part 'lesson.g.dart';

/// Class for storing lesson data.
@JsonSerializable()
class Lesson {
  Lesson({
    required this.id,
    required this.brief,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.numberPair,
    required this.teachers,
    required this.auditory,
    required this.groups,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) =>
      _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'brief')
  final String brief;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'startTime')
  final int startTime;
  @JsonKey(name: 'endTime')
  final int endTime;
  @JsonKey(name: 'type')
  final LessonType type;
  @JsonKey(name: 'numberPair')
  final int numberPair;
  @JsonKey(name: 'teachers')
  final List<Teacher> teachers;
  @JsonKey(name: 'auditory')
  final Auditory auditory;
  @JsonKey(name: 'groups')
  final List<Group> groups;

  /// Converts the start time to a string.
  /// 
  /// Example: 8:30
  String startTimeToString() {
    return DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(startTime * 1000));
  }

  /// Converts the end time to a string.
  /// 
  /// Example: 9:50
  String endTimeToString() {
    return DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(endTime * 1000));
  }
}

List<Map<String, dynamic>> scheduleToJsonList(List<Lesson> schedule) {
  return schedule.map((lesson) => lesson.toJson()).toList();
}
