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


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/auditory.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/teacher.dart';


final FlutterLocalization localization = FlutterLocalization.instance;

/// Copies lesson details to clipboard.
void copyLessonDetails(BuildContext context, Lesson lesson) {
  Clipboard.setData(
    ClipboardData(
      text: "${lesson.title}" "\n\n"
      "${AppLocale.type.getString(context)}: ${lesson.type.fullName}" "\n"
      "${AppLocale.teachers.getString(context)}: ${lesson.teachers.map((teacher) => "${teacher.fullName}(${teacher.faculty.shortName})").join(", ")}" "\n"
      "${AppLocale.time.getString(context)}: ${
        lesson.startTimeToString()} - ${
        lesson.endTimeToString()}; ${
          DateFormat.yMMMMd(localization.currentLocale?.languageCode == "uk" ? "uk_UA" : "en_UK").format(
            DateTime.fromMillisecondsSinceEpoch(lesson.startTime * 1000)
      )}" "\n"
      "${AppLocale.pairNumber.getString(context)}: ${lesson.numberPair}" "\n"
      "${AppLocale.groups.getString(context)}: ${lesson.groups.map((group) => "${group.name}(${group.faculty.shortName})").join(", ")}" "\n"
      "${AppLocale.auditory.getString(context)}: ${lesson.auditory.name}, ${AppLocale.floor.getString(context).toLowerCase()} - ${lesson.auditory.floor}"
    ),
  );
}

void copyGroupDetails(BuildContext context, Group group) {
  Clipboard.setData(
    ClipboardData(
      text: "${group.name}""\n"
      "ID: ${group.id}""\n"
      "${AppLocale.faculty.getString(context)}: ${group.faculty.fullName}""\n"
      "${AppLocale.direction.getString(context)}: ${group.direction.fullName}"
    ),
  );
}

void copyTeacherDetails(BuildContext context, Teacher teacher) {
  Clipboard.setData(
    ClipboardData(
      text: "${teacher.fullName}""\n"
      "ID: ${teacher.id}""\n"
      "${AppLocale.faculty.getString(context)}: ${teacher.faculty.fullName}""\n"
      "${AppLocale.department.getString(context)}: ${teacher.department.fullName}"
    ),
  );
}

void copyAuditoryDetails(BuildContext context, Auditory auditory) {
  Clipboard.setData(
    ClipboardData(
      text: "${auditory.name}""\n"
      "ID: ${auditory.id}""\n"
      "${AppLocale.building.getString(context)}: ${auditory.building.fullName}""\n"
      "${AppLocale.floor.getString(context)}: ${auditory.floor}""\n"
      "${AppLocale.auditoryTypes.getString(context)}: ${auditory.auditoryTypes.map((t) => t.name).join(", ")}""\n"
      "${AppLocale.hasPower.getString(context)}: ${auditory.hasPower ? AppLocale.yes.getString(context) : AppLocale.no.getString(context)}"
    ),
  );
}