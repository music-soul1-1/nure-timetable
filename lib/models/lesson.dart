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


import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/subject.dart';
import 'package:nure_timetable/models/teacher.dart';


part 'lesson.g.dart';

/// Class for storing lesson data.
@JsonSerializable()
class Lesson {
  Lesson({
    required this.startTime,
    required this.endTime,
    required this.auditory,
    required this.type,
    required this.groups,
    required this.numberPair,
    required this.teachers,
    required this.subject});

  factory Lesson.fromJson(Map<String, dynamic> json) =>
      _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);

  @JsonKey(name: 'startTime')
  final int startTime;
  @JsonKey(name: 'endTime')
  final int endTime;
  @JsonKey(name: 'auditory')
  final String auditory;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'groups')
  final List<Group> groups;
  @JsonKey(name: 'numberPair')
  final int numberPair;
  @JsonKey(name: 'teachers')
  final List<Teacher> teachers;
  @JsonKey(name: 'subject')
  final Subject subject;


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

