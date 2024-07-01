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