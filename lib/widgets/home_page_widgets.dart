import 'dart:io';
import 'dart:ui';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:nure_timetable/helpers.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/auditory.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/lesson_appointment.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/models/theme_colors.dart';


var isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
final FlutterLocalization localization = FlutterLocalization.instance;


Widget customEventTileBuilder(date, events, boundary, start, end, ThemeColors themeColors) {
  FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
  Size size = view.physicalSize / view.devicePixelRatio;
  double width = size.width;
  
  final event = events[0] as LessonAppointment;
  // Taken from calendar_view lib with small changes:
  return Container(
    margin: isMobile || width < 700 ? const EdgeInsets.only(right: 2) : const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: lessonColor(event.lesson.type, themeColors),
      borderRadius:
          isMobile || width < 700
              ? BorderRadius.circular(8)
              : BorderRadius.circular(12),
      boxShadow: List<BoxShadow>.generate(
        2,
        (index) => BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 2,
          offset: const Offset(-1, 1),
        ),
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            event.lesson.brief,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile || width < 700 ? 12 : 14,
            ),
          ),
          Text(
            event.lesson.type.shortName,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile || width < 700 ? 11 : 13,
            ),
          ),
          Text(
            event.lesson.auditory.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile || width < 700 ? 9 : 12,
            ),
          ),
          Text(
            '${event.lesson.startTimeToString()} - ${event.lesson.endTimeToString()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile || width < 700 ? 11 : 13,
            ),
          ),
        ],
      ),
    ),
  );
}


Widget customCalendarHeaderBuilder(startDate, endDate, BuildContext context, EventController controller, GlobalKey<WeekViewState> weekViewKey, DateTime scrollToWeekOnPress) {
  final nextLesson = controller.allEvents
      .map((event) => event as LessonAppointment)
      .where((event) => event.startTime!.isAfter(DateTime.now()) && event.startTime!.isBefore(DateTime.now().add(const Duration(hours: 8))))
      .firstOrNull;

  // Dimensions in logical pixels (dp)
  Size size = MediaQuery.of(context).size;
  double width = size.width;

  return SizedBox(
    height: isMobile ? 80 : 70,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isMobile || width < 700
            ? 
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              nextLesson != null
                  ? "${AppLocale.nextLesson.getString(context)}: ${nextLesson.lesson.brief}; " 
                  "${nextLesson.lesson.startTimeToString()}, ${DateFormat.Md(localization.currentLocale?.languageCode == "uk" ? "uk_UA" : "en_UK").format(nextLesson.startTime!)}"
                  : "${AppLocale.noLessonsInNearFuture.getString(context)} 😎",
              textScaler: const TextScaler.linear(1.1),
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
                    tooltip: AppLocale.previousWeek.getString(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      DateFormat.yMMMM(localization.currentLocale?.languageCode == "uk" ? "uk_UA" : "en_UK").format(startDate),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  )
                ],
              ),
              isMobile || width < 700
                ? 
              const SizedBox(
                height: 0,
              ) :
              Text(
                nextLesson != null
                    ? "${AppLocale.nextLesson.getString(context)}: ${nextLesson.lesson.brief}; " 
                    "${nextLesson.lesson.startTimeToString()}, ${DateFormat.Md(localization.currentLocale?.languageCode == "uk" ? "uk_UA" : "en_UK").format(nextLesson.startTime!)}"
                    : "${AppLocale.noLessonsInNearFuture.getString(context)} 😎",
                textScaler: const TextScaler.linear(1.2),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      weekViewKey.currentState?.animateToWeek(
                        scrollToWeekOnPress.toLocal(),
                        duration: const Duration(milliseconds: 350)
                      );
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                    tooltip: AppLocale.currentWeek.getString(context),
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    onPressed: () {
                      weekViewKey.currentState?.nextPage();
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    tooltip: AppLocale.nextWeek.getString(context),
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
        title: Text(lesson.title),
        scrollable: true,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📚${AppLocale.type.getString(context)}: ${lesson.type.fullName}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Wrap(
              children: [
                Text(
                  '👨🏼‍🏫${AppLocale.teachers.getString(context)}: ',
                  style: const TextStyle(fontSize: 16, height: 1.3),
                ),
                ...lesson.teachers.map((teacher) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).textTheme.labelMedium?.color,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.bottomCenter,
                    ),
                    onPressed: () => showTeacherInfoDialog(context, teacher),
                    child: Text(
                      "${teacher.fullName}(${teacher.faculty.shortName})${teacher != lesson.teachers.last ? ', ' : ''}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  );
                }),
              ],
            ),
            Text(
              '📆${AppLocale.time.getString(context)}: ${
                lesson.startTimeToString()} - ${
                lesson.endTimeToString()}; ${
                  DateFormat.yMMMMd(localization.currentLocale?.languageCode == "uk" ? "uk_UA" : "en_UK").format(
                    DateTime.fromMillisecondsSinceEpoch(lesson.startTime * 1000)
              )}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "🔢${AppLocale.pairNumber.getString(context)}: ${lesson.numberPair}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Wrap(
              children: [
                Text(
                  '🧑‍🤝‍🧑${AppLocale.groups.getString(context)}: ',
                  style: const TextStyle(fontSize: 16, height: 1.3),
                ),
                ...lesson.groups.map((group) {
                  return 
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).textTheme.labelMedium?.color,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.bottomCenter,
                      ),
                      onPressed: () => showGroupInfoDialog(context, group),
                      child: Text(
                        "${group.name}(${group.faculty.shortName})${group != lesson.groups.last ? ', ' : ''}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    );
                }),
              ],
            ),
            Wrap(
              children: [
                Text(
                  '🏫${AppLocale.auditory.getString(context)}: ',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).textTheme.labelMedium?.color,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.bottomCenter,
                  ),
                  onPressed: () => showAuditoryInfoDialog(context, lesson.auditory),
                  child: Text(
                    "${lesson.auditory.name}, ${AppLocale.floor.getString(context).toLowerCase()} - ${lesson.auditory.floor}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              copyLessonDetails(context, lesson);
            },
            child: Text(AppLocale.copyDetails.getString(context)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocale.close.getString(context)),
            ),
          ),
        ],
      );
    },
  );
}


Future<dynamic> showGroupInfoDialog(BuildContext context, Group group) {
  return showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        contentPadding: EdgeInsetsGeometry.lerp(
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          0.5,
        ),
        title: Text(group.name),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "🪪ID: ${group.id}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  child: IconButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size.zero),
                    ),
                    onPressed: () => Clipboard.setData(ClipboardData(text: "${group.id}")),
                    icon: const Icon(Icons.copy_outlined),
                    iconSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              "👨🏼‍🏫${AppLocale.faculty.getString(context)}: ${group.faculty.fullName}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "📚${AppLocale.direction.getString(context)}: ${group.direction.fullName}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              copyGroupDetails(context, group);

              Navigator.of(context).pop();
            },
            child: Text(AppLocale.copyDetails.getString(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocale.close.getString(context)),
          ),
        ],
      );
    }
  );
}

showTeacherInfoDialog(BuildContext context, Teacher teacher) {
    return showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        contentPadding: EdgeInsetsGeometry.lerp(
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          0.5,
        ),
        title: Text(teacher.fullName),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "🪪ID: ${teacher.id}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  child: IconButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size.zero),
                    ),
                    onPressed: () => Clipboard.setData(ClipboardData(text: "${teacher.id}")),
                    icon: const Icon(Icons.copy_outlined),
                    iconSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              "👨🏼‍🏫${AppLocale.faculty.getString(context)}: ${teacher.faculty.fullName}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "📚${AppLocale.department.getString(context)}: ${teacher.department.fullName}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              copyTeacherDetails(context, teacher);

              Navigator.of(context).pop();
            },
            child: Text(AppLocale.copyDetails.getString(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocale.close.getString(context)),
          ),
        ],
      );
    }
  );
}

Future<dynamic> showAuditoryInfoDialog(BuildContext context, Auditory auditory) {
    return showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        contentPadding: EdgeInsetsGeometry.lerp(
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          0.5,
        ),
        title: Text(auditory.name),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "🪪ID: ${auditory.id}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  child: IconButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size.zero),
                    ),
                    onPressed: () => Clipboard.setData(ClipboardData(text: "${auditory.id}")),
                    icon: const Icon(Icons.copy_outlined),
                    iconSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              "👨🏼‍🏫${AppLocale.building.getString(context)}: ${auditory.building.fullName}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "🏢${AppLocale.floor.getString(context)}: ${auditory.floor}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "🎨${AppLocale.auditoryTypes.getString(context)}: ${auditory.auditoryTypes.map((t) => t.name).join(", ")}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "🔌${AppLocale.hasPower.getString(context)}: ${auditory.hasPower ? AppLocale.yes.getString(context) : AppLocale.no.getString(context)}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              copyAuditoryDetails(context, auditory);

              Navigator.of(context).pop();
            },
            child: Text(AppLocale.copyDetails.getString(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocale.close.getString(context)),
          ),
        ],
      );
    }
  );
}