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
    date: DateTime.fromMillisecondsSinceEpoch(lesson.startTime * 1000),
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