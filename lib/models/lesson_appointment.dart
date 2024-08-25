import 'dart:ui';
import 'package:calendar_view/calendar_view.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/lesson_type.dart';
import 'package:nure_timetable/models/theme_colors.dart';


/// Class for storing lesson appointment data.
class LessonAppointment extends CalendarEventData {
  final Lesson lesson;

  LessonAppointment({
    required DateTime super.startTime,
    required DateTime super.endTime,
    required this.lesson,
    required String subject,
    required super.color,
  }) : super(
    title: lesson.brief,
    event: lesson.type,
    date: DateTime.fromMillisecondsSinceEpoch(lesson.startTime * 1000),
  );
}

/// Returns a color for a lesson type.
Color lessonColor(LessonType lessonType, ThemeColors themeColors) {
  switch (lessonType.idBase) {
    case 0:
      return Color(int.parse(themeColors.lecture));
    case 10:
      return Color(int.parse(themeColors.practice));
    case 20:
      return Color(int.parse(themeColors.laboratory));
    case 30:
      return Color(int.parse(themeColors.consultation));
    case 40:
      return Color(int.parse(themeColors.test));
    case 50:
      return Color(int.parse(themeColors.exam));
    case 60:
      return Color(int.parse(themeColors.courseWork));
    default:
      return Color(int.parse(themeColors.other));
  }
}