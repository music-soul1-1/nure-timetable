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


import 'package:json_annotation/json_annotation.dart';
import 'package:nure_timetable/models/entity.dart';

part 'teacher.g.dart'; // This part file will be generated by json_serializable

/// Class for storing teacher data.
@JsonSerializable()
class Teacher {
  Teacher({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.department,
    required this.faculty,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'shortName')
  final String shortName;
  @JsonKey(name: 'fullName')
  final String fullName;
  @JsonKey(name: 'department')
  final Entity department;
  @JsonKey(name: 'faculty')
  final Entity faculty;
}
