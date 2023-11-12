import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/subject.dart';
import 'package:nure_timetable/models/teacher.dart';


part 'lesson.g.dart';

/// Class for storing lesson data.
@JsonSerializable()
class Lesson {
  Lesson(
    {required this.id,
    required this.startTime,
    required this.endTime,
    required this.auditory,
    required this.type,
    required this.updatedAt,
    required this.groups,
    required this.numberPair,
    required this.teachers,
    required this.subject});

  factory Lesson.fromJson(Map<String, dynamic> json) =>
      _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;
  final String auditory;
  final String type;
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  final List<Group> groups;
  @JsonKey(name: 'number_pair')
  final int numberPair;
  final List<Teacher> teachers;
  final Subject subject;


  /// Converts the start time to a string.
  /// 
  /// Example: 8:30
  String startTimeToString() {
    return DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(startTime) * 1000));
  }

  /// Converts the end time to a string.
  /// 
  /// Example: 9:50
  String endTimeToString() {
    return DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(endTime) * 1000));
  }
}

List<Map<String, dynamic>> scheduleToJsonList(List<Lesson> schedule) {
  return schedule.map((lesson) => lesson.toJson()).toList();
}

