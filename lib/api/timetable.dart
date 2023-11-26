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


import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/models/group.dart';
import 'dart:convert';


class Timetable {
  Timetable();
  /// The domain of the API.
  static const domain = "https://api.mindenit.tech";

  /// Gets a list of groups.
  Future<List<Group>> getGroups() async {
    try {
      const url = '$domain/groups';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Group> groups = data.map((item) => Group.fromJson(item)).toList();
        return groups;
      }
      else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load groups: ${response.statusCode}');
      }
    }
    catch(error) {
      throw Exception('Error in <getGroups>: $error');
    }
  }

  /// Gets a group by name.
  Future<Group> getGroup(String groupName) async {
    try {
      List<Group> groups = await getGroups();
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

  /// Gets lessons for a group/teacher.
  Future<List<Lesson>> getLessons(int groupId, int startTime, int endTime, [bool isTeacher = false]) async {
    try {
      final url = '$domain/schedule?type=${isTeacher ? "teacher" : "group"}&id=$groupId&start_time=$startTime&end_time=$endTime';
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

  /// Gets next lesson for a group.
  Future<Lesson?> getNextLesson(int groupId) async {
    try {
      var lessons = await getLessons(
        groupId,
        (DateTime.now().millisecondsSinceEpoch ~/ 1000),
        (DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000),
      );
      if (lessons.isNotEmpty) {
        return lessons.first;
      }
      else {
        return null;
      }
    }
    catch(error) {
      throw Exception('Error in <getNextLesson>: $error');
    }
  }

  /// Gets a list of teachers.
  Future<List<Teacher>> getTeachers() async {
    try {
      const url = '$domain/teachers';
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

  /// Gets a teacher by name.
  Future<Teacher> getTeacher(String shortName) async {
    try {
      List<Teacher> teachers = await getTeachers();
      return teachers.firstWhere((teacher) => teacher.shortName.toLowerCase() == shortName.toLowerCase());
    }
    catch(error) {
      throw Exception('Error in <getTeacher>: $error');
    }
  }
}