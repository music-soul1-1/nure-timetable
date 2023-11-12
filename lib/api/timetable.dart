import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/models/group.dart';
import 'dart:convert';


class Timetable {
  Timetable();
  /// The domain of the API.
  static const domain = "https://nure-dev.pp.ua/";

  /// Gets a list of groups.
  Future<List<Group>> getGroups() async {
    try {
      const url = '${domain}api/groups';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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
  Future<List<Lesson>> getLessons(String groupId, String startTime, String endTime, [bool isTeacher = false]) async {
    try {
      final url = '${domain}api/schedule?type=${isTeacher ? "teacher" : "group"}&id=$groupId&start_time=$startTime&end_time=$endTime';
      if (kDebugMode) {
        print(url);
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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
  Future<Lesson?> getNextLesson(String groupId) async {
    try {
      var lessons = await getLessons(
        groupId,
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        (DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000).toString()
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
      const url = '${domain}api/teachers';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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