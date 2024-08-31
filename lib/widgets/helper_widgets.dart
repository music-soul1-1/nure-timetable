import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/types/entity_type.dart';
import 'package:nure_timetable/widgets/home_page_widgets.dart';


SnackBar snackbar(String text, {int duration = 1}) {
  return SnackBar(
    content: Text(text),
    duration: Duration(seconds: duration),
  );
}


/// Header for the app bar in home page (uses either group, teacher or auditory name).
// ignore: non_constant_identifier_names
AppBar HomeHeader(BuildContext context, AppSettings settings, IconData iconData) {
  return AppBar(
    toolbarHeight: 45,
    backgroundColor: const Color(0xFF00465F),
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: Icon(iconData,
            size: 28,
            color: const Color(0xFF06DDF6),
          ),
        ),
        settings.auditory.id != 0 || settings.group.id != 0 || settings.teacher.id != 0 ? 
        TextButton(
          onPressed: () => switch (settings.type) {
            EntityType.group => showGroupInfoDialog(context, settings.group),
            EntityType.teacher => showTeacherInfoDialog(context, settings.teacher),
            EntityType.auditory => showAuditoryInfoDialog(context, settings.auditory),
          },
          child: Text(
            switch (settings.type) {
              EntityType.group => "${settings.group.name}, ${settings.group.faculty.shortName}",
              EntityType.teacher => "${settings.teacher.shortName}, ${settings.teacher.faculty.shortName}",
              EntityType.auditory => "${settings.auditory.name}, ${settings.auditory.building.shortName}",
            },
            style: const TextStyle(
              color: Color(0xFF06DDF6),
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: 'Inter',
            ),
          ),
        ) : 
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            AppLocale.schedule.getString(context),
            style: const TextStyle(
                color: Color(0xFF06DDF6),
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontFamily: 'Inter',
              ),
          ),
        ),
      ],
    ),
  );
}


/// Header for the app bar.
// ignore: non_constant_identifier_names
AppBar Header(String title, IconData iconData) {
  return AppBar(
    toolbarHeight: 45,
    backgroundColor: const Color(0xFF00465F),
    foregroundColor: const Color(0xFF06DDF6),
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(iconData,
            size: 28,
            color: const Color(0xFF06DDF6),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF06DDF6),
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  );
}