import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/models/teacher.dart';


void main() {
  group('Timetable API', () {
    test('getTeacher should return a teacher', () async {
      // Arrange
      final timetableApi = Timetable();

      final teachers = await timetableApi.getTeachers();

      if (kDebugMode) {
        print("Got teacher:\n ${teachers[0].fullName}, ${teachers[0].id}");
      }
      // Assert
      expect(teachers.first, isA<Teacher>());
    });
  });
}