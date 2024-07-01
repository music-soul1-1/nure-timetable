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


import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nure_timetable/models/auditory.dart';
import 'dart:convert';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/types/entity_type.dart';


class Timetable {
  Timetable();
  /// The domain of the API.
  static const domain = "https://nure-time.runasp.net/api";

  /// Gets a list of groups.
  Future<List<Group>?> getGroups() async {
    try {
      const url = '$domain/groups/all';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Group> groups = data.map((item) => Group.fromJson(item)).toList();
        return groups;
      }
      else {
        throw Exception('Failed to load groups: ${response.statusCode}');
      }
    }
    catch(error) {
      throw Exception('Error in <getGroups>: $error');
    }
  }

  /// Gets a group by id.
  Future<Group?> getGroupById(int id) async
  {
    try
    {
      final response = await http.get(Uri.parse('$domain/groups/$id'));

      if (response.statusCode != 200)
      {
        throw Exception('Failed to get group with id $id: ${response.statusCode}');
      }

      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      return Group.fromJson(data);
    }
    catch(error)
    {
      throw Exception('Error in <getGroup>: $error');
    }
  }

  /// Gets a group by name.
  Future<Group?> getGroup(String groupName) async {
    try {
      List<Group>? groups = await getGroups();

      if (groups == null) {
        return null;
      }

      return groups.firstWhere((group) => group.name.toLowerCase() == groupName.toLowerCase());
    }
    catch(error) {
      throw Exception('Error in <getGroup>: $error');
    }
  }

  /// Searches for a group by name.
  List<Group> searchGroup(List<Group> groups, String groupName) {
    try {
      return groups.where((group) => group.name.toLowerCase().contains(groupName.toLowerCase())).toList();
    }
    catch(error) {
      throw Exception('Error in <searchGroup>: $error');
    }
  }

  /// Gets lessons for a group/teacher/auditory.
  Future<List<Lesson>>? getLessons(int id, int startTime, int endTime, [EntityType entityType= EntityType.group]) async {
    try {
      final url = '$domain/Lessons/Get?id=$id&type=${entityType.index}&start_time=$startTime&end_time=$endTime';

      if (kDebugMode) {
        print(url);
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Lesson> lessons = data.map((item) => Lesson.fromJson(item)).toList();
        return lessons;
      }
      else {
        throw Exception('Failed to load lessons: ${response.statusCode}');
      }
    }
    catch(error) {
      throw Exception('Error in <getLessons>: $error');
    }
  }

  Lesson? getNextLessonFromList(List<Lesson> lessons) {
    try {
      if (lessons.isNotEmpty) {
        return lessons.where((lesson) => lesson.startTime >= (DateTime.now().millisecondsSinceEpoch ~/ 1000)).first;
      }
      else {
        return null;
      }
    }
    catch(error) {
      throw Exception('Error in <getNextLessonFromList>: $error');
    }
  }

  /// Gets a list of teachers.
  Future<List<Teacher>>? getTeachers() async {
    try {
      const url = '$domain/teachers/all';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Teacher> teachers = data.map((item) => Teacher.fromJson(item)).toList();
        return teachers;
      }
      else {
        throw Exception('Failed to load teachers: ${response.statusCode}');
      }
    }
    catch(error) {
      throw Exception('Error in <getTeachers>: $error');
    }
  }

  Future<Teacher?> getTeacherById(int id) async
  {
    try
    {
      final response = await http.get(Uri.parse('$domain/teachers/$id'));

      if (response.statusCode != 200)
      {
        throw Exception('Failed to get teacher with id $id: ${response.statusCode}');
      }

      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      return Teacher.fromJson(data);
    }
    catch(error)
    {
      throw Exception('Error in <getTeacherById>: $error');
    }
  }

  /// Gets a teacher by name.
  Future<Teacher?> getTeacher(String shortName) async {
    try {
      List<Teacher>? teachers = await getTeachers();

      if (teachers == null){
        return null;
      }

      return teachers.firstWhere((teacher) => teacher.shortName.toLowerCase() == shortName.toLowerCase());
    }
    catch(error) {
      throw Exception('Error in <getTeacher>: $error');
    }
  }

  Future<List<Auditory>>? getAuditories() async {
    try {
      const url = '$domain/auditories/all';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        try {
          List<Auditory> auditories = data.map((item) => Auditory.fromJson(item)).toList();
          return auditories;
        }
        catch(error) {
          throw Exception('Error in <getAuditories>: $error');
        }
      }
      else {
        throw Exception('Failed to load auditories: ${response.statusCode}');
      }
    }
    catch(error) {
      throw Exception('Error in <getAuditories>: $error');
    }
  }

  Future<Auditory?> getAuditoryById(int id) async
  {
    try
    {
      final response = await http.get(Uri.parse('$domain/auditories/$id'));

      if (response.statusCode != 200)
      {
        throw Exception('Failed to get auditory with id $id: ${response.statusCode}');
      }

      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      return Auditory.fromJson(data);
    }
    catch(error)
    {
      throw Exception('Error in <getAuditoryById>: $error');
    }
  }

  Future<Auditory?> getAuditory(String name) async {
    try {
      List<Auditory>? auditories = await getAuditories();

      if (auditories == null) {
        return null;
      }

      return auditories.firstWhere((auditory) => auditory.name.toLowerCase() == name.toLowerCase());
    }
    catch(error) {
      throw Exception('Error in <getAuditory>: $error');
    }
  }
}