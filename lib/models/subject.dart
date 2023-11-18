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


import 'package:json_annotation/json_annotation.dart';

part 'subject.g.dart'; // This part file will be generated by json_serializable

/// Class for storing subject data.
@JsonSerializable()
class Subject {
  Subject({required this.id, required this.brief, required this.title});

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);

  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'Brief')
  final String brief;
  @JsonKey(name: 'Title')
  final String title;
}
