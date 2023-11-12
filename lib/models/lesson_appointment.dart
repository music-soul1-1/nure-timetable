import 'dart:ui';
import 'package:calendar_view/calendar_view.dart';
import 'package:nure_timetable/models/lesson.dart';


/// Class for storing lesson appointment data.
class LessonAppointment extends CalendarEventData {
  final Lesson lesson;

  LessonAppointment({
    required DateTime startTime,
    required DateTime endTime,
    required this.lesson,
    required String subject,
    required Color color,
  }) : super(
    title: lesson.subject.brief,
    event: lesson.type,
    date: DateTime.fromMillisecondsSinceEpoch(int.parse(lesson.startTime) * 1000),
    startTime: startTime,
    endTime: endTime,
    color: lessonColor(lesson.type),
  );

  Map<String, dynamic> toMap() {
    return {
      'subject': lesson.subject.title,
      'color': lessonColor(lesson.type),
      'lesson': lesson,
    };
  }
}

/// Returns a color for a lesson type.
Color lessonColor(String lessonType) {
  switch (lessonType) {
    case "Лк":
      return const Color(0xFFAD8827);
    case "Лб":
      return const Color(0xFF5A2194);
    case "Пз":
      return const Color(0xFF1C8834);
    case "Конс":
      return const Color(0xFF1E7F85);
    case "Екз":
      return const Color(0xFF8E1D1D);
    default:
      return const Color(0xFF9A1A95);
  }
}