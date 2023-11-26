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


import 'dart:io';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/lesson_appointment.dart';


var isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);


Widget customEventTileBuilder(date, events, boundary, start, end) {
  final event = events[0] as LessonAppointment;
  // Taken from calendar_view lib with small changes:
  return Container(
    margin: isMobile ? const EdgeInsets.only(right: 2) : const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: lessonColor(event.lesson.type),
      borderRadius:
          isMobile
              ? BorderRadius.circular(6)
              : BorderRadius.circular(12),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            event.lesson.subject.brief,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
          Text(
            event.lesson.type,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 12 : 13,
            ),
          ),
          Text(
            event.lesson.auditory,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 10 : 12,
            ),
          ),
          Text(
            '${event.lesson.startTimeToString()} - ${event.lesson.endTimeToString()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 11 : 13,
            ),
          ),
        ],
      ),
    ),
  );
}


Widget customCalendarHeaderBuilder(startDate, endDate, EventController controller, GlobalKey<WeekViewState> weekViewKey) {
  final nextLesson = controller.events.reversed
      .map((event) => event as LessonAppointment)
      .where((event) => event.startTime!.isAfter(DateTime.now()) && event.startTime!.isBefore(DateTime.now().add(const Duration(hours: 8))))
      .firstOrNull;

  return SizedBox(
    height: isMobile ? 80 : 70,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isMobile
            ? 
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              nextLesson != null
                  ? "Наступна пара: ${nextLesson.lesson.subject.brief}; " 
                  "${nextLesson.lesson.startTimeToString()}, ${DateFormat.Md("uk_UA").format(nextLesson.startTime!)}"
                  : "Найближчим часом пар немає 😎",
              textScaleFactor: 1.2,
            ),
          ) : 
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      weekViewKey.currentState?.previousPage();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: "Попередній тиждень",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      DateFormat.yMMMM("uk_UA").format(startDate),
                      textScaleFactor: 1.2,
                    ),
                  )
                ],
              ),
              isMobile
                ? 
              const SizedBox(
                height: 0,
              ) :
              Text(
                nextLesson != null
                    ? "Наступна пара: ${nextLesson.lesson.subject.brief}; " 
                    "${nextLesson.lesson.startTimeToString()}, ${DateFormat.Md("uk_UA").format(nextLesson.startTime!)}"
                    : "Найближчим часом пар немає 😎",
                textScaleFactor: 1.2,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      weekViewKey.currentState?.animateToWeek(
                        DateTime.now(),
                        duration: const Duration(milliseconds: 500)
                      );
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                    tooltip: "Поточний тиждень",
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    onPressed: () {
                      weekViewKey.currentState?.nextPage();
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    tooltip: "Наступний тиждень",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> showLessonInfoDialog(BuildContext context, Lesson lesson) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(lesson.subject.title),
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📚Тип: ${lesson.type}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '👨🏼‍🏫Викладачі: ${lesson.teachers.map((teacher) => teacher.fullName).join(", ")}',
                style: const TextStyle(
                  fontSize: 16,
                ),  
              ),
              Text(
                '📆Час: ${
                  lesson.startTimeToString()} - ${
                  lesson.endTimeToString()}; ${
                    DateFormat.yMMMMd("uk_UA").format(
                      DateTime.fromMillisecondsSinceEpoch(lesson.startTime * 1000)
                )}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '🧑‍🤝‍🧑Групи: ${lesson.groups.map((group) => group.name).join(", ")}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '🏫Аудиторія: ${lesson.auditory}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Закрити'),
          ),
        ],
      );
    },
  );
}
