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


import 'dart:ui';
import 'package:calendar_view/calendar_view.dart';
import 'package:nure_timetable/models/lesson.dart';
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
    title: lesson.subject.brief,
    event: lesson.type,
    date: DateTime.fromMillisecondsSinceEpoch(lesson.startTime * 1000),
  );
}

/// Returns a color for a lesson type.
Color lessonColor(String lessonType, ThemeColors themeColors) {
  switch (lessonType) {
    case "Лк":
      return Color(int.parse(themeColors.lecture));
    case "Лб":
      return Color(int.parse(themeColors.laboratory));
    case "Пз":
      return Color(int.parse(themeColors.practice));
    case "Конс":
      return Color(int.parse(themeColors.consultation));
    case "Екз":
      return Color(int.parse(themeColors.exam));
    default:
      return Color(int.parse(themeColors.other));
  }
}