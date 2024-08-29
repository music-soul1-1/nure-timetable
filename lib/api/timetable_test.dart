import 'package:flutter/foundation.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/models/teacher.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Timetable API', () {
    test('getTeachers should return teachers', () async {
      // Arrange
      final timetableApi = Timetable();

      final teachers = await timetableApi.getTeachers();

      if (kDebugMode) {
        print("Teachers count: ${teachers?.length}");
      }
      // Assert
      expect(teachers, isA<List<Teacher>>());
    });
  });
}