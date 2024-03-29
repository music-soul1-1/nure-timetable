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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_localization/flutter_localization.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:flutter/material.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:nure_timetable/models/lesson_appointment.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:nure_timetable/widgets/home_page_widgets.dart';
import 'package:nure_timetable/widgets/settings_page_widgets.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';

GlobalKey<WeekViewState> weekViewKey = GlobalKey<WeekViewState>();
var isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
var systemBrightness = Brightness.dark;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.themeManager});

  final ThemeManager themeManager;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var timetable = Timetable();
  var settings = AppSettings.getDefaultSettings();
  final EventController controller = EventController();

  @override
  void initState() {
    super.initState();
    //SharedPreferences.getInstance().then((value) => value.clear());
    loadSettings().then((value) => setState(() {
          widget.themeManager.toggleTheme(value.useSystemTheme
              ? (systemBrightness == Brightness.dark)
              : value.darkThemeEnabled);
          settings = value;
        }));
  }

  Future<void> _refresh() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(AppLocale.updatingSchedule.getString(context), duration: 4));

    // Updates lessons data
    await _loadLessons(updateFromAPI: true);

    // .map method doesn't work here
    for (var event in controller.events) {
      controller.remove(event);
    }

    loadSettings().then((value) => setState(() {
          widget.themeManager.toggleTheme(value.useSystemTheme
              ? (systemBrightness == Brightness.dark)
              : settings.darkThemeEnabled);
          settings = value;

          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(snackbar(AppLocale.scheduleUpdated.getString(context)));
        }));
  }

  /// Loads lessons from API or cache.
  ///
  /// If `updateFromAPI` is true, then lessons will be loaded from API, and then saved to local storage.
  Future<List<Lesson>> _loadLessons({bool updateFromAPI = false}) async {
    try {
      if (!updateFromAPI) {
        return await loadSchedule();
      }

      if (settings.group.id != 0 && settings.type == 'group') {
        final lessons = timetable.getLessons(
          settings.group.id, settings.startTime, settings.endTime
        );
        settings.type = 'group';
        settings.lastUpdated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await saveSettings(settings);

        lessons.then((lessons) => saveSchedule(lessons));

        return lessons;
      }
      else if (settings.teacher.id != 0 && settings.type == 'teacher') {
        final lessons = timetable.getLessons(
          settings.teacher.id, settings.startTime, settings.endTime, true
        );
        settings.type = 'teacher';
        settings.lastUpdated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await saveSettings(settings);

        lessons.then((lessons) => saveSchedule(lessons));

        return lessons;
      }
      else {
        return [];
      }
    } catch (error) {
      showErrorSnackbar(error);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      appBar: HomeHeader(settings, Icons.calendar_month_outlined),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: isMobile
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 40, right: 40),
              child: FutureBuilder<List<Lesson>>(
                future: _loadLessons(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Handle loading state
                    return const Padding(
                      padding: EdgeInsets.all(80),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  else if (snapshot.hasError) {
                    // Handle error state
                    return Column(
                      children: [
                        Text('${AppLocale.error.getString(context)}: ${snapshot.error}'),
                        Text("${AppLocale.tryToResetSettings.getString(context)}:"),
                        TextButton(
                            onPressed: () => showRemoveSettingsDialog(context),
                            child: Text(AppLocale.resetSettings.getString(context))),
                      ],
                    );
                  }
                  else if (snapshot.hasData) {
                    final lessons = snapshot.data!;

                    final events = lessons.map((lesson) {
                      return LessonAppointment(
                        startTime: DateTime.fromMillisecondsSinceEpoch(
                            lesson.startTime * 1000),
                        endTime: DateTime.fromMillisecondsSinceEpoch(
                            lesson.endTime * 1000),
                        lesson: lesson,
                        subject: lesson.subject.title,
                        color: lessonColor(lesson.type, settings.themeColors),
                      );
                    }).toList();

                    controller.addAll(events);

                    return SizedBox(
                      height: MediaQuery.of(context).size.height -
                          (isMobile ? 125 : 100),
                      child: WeekView(
                        key: weekViewKey,
                        backgroundColor: Colors.transparent,
                        weekDayBuilder: (date) =>
                            customWeekDayBuilder(date, context),
                        weekTitleHeight: 60,
                        headerStyle: const HeaderStyle(
                          leftIcon: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF06DDF6),
                          ),
                          rightIcon: Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF06DDF6),
                          ),
                          headerTextStyle: TextStyle(
                            color: Color(0xFF06DDF6),
                            fontSize: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF00465F),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        controller: controller,
                        eventTileBuilder: ((date, events, boundary, start, end) =>
                            customEventTileBuilder(date, events, boundary, start, end, settings.themeColors)),
                        timeLineWidth: 50,
                        // Taken from calendar_view lib with small changes:
                        timeLineBuilder: (date) {
                          final timeLineString = "${date.hour}:${date.minute}0";
                          return Transform.translate(
                            offset: const Offset(0, -8),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 7.0),
                              child: Text(
                                timeLineString,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          );
                        },
                        scrollOffset: 450,
                        liveTimeIndicatorSettings: const HourIndicatorSettings(
                          color: Color(0xFF06DDF6),
                        ),
                        weekPageHeaderBuilder: (startTime, endTime) {
                          return customCalendarHeaderBuilder(
                              startTime, endTime, controller, weekViewKey, context);
                        },
                        showLiveTimeLineInAllDays: false,
                        minDay: DateTime.fromMillisecondsSinceEpoch(
                            settings.startTime * 1000),
                        maxDay: DateTime.fromMillisecondsSinceEpoch(
                            settings.endTime * 1000),
                        pageTransitionDuration:
                            const Duration(milliseconds: 200),
                        hourIndicatorSettings: HourIndicatorSettings(
                          color: widget.themeManager.themeMode == ThemeMode.dark
                              ? const Color.fromARGB(64, 0, 70, 95)
                              : Colors.black12,
                        ),
                        initialDay: DateTime.now(),
                        heightPerMinute:
                            1, // height occupied by 1 minute time span.
                        onEventTap: (events, date) {
                          if (events.isNotEmpty) {
                            final lessonEvent = events[0] as LessonAppointment;
                            showLessonInfoDialog(context, lessonEvent.lesson);
                          }
                        },
                        startDay: WeekDays.monday,
                      ),
                    );
                  }
                  else {
                    return Text(AppLocale.noData.getString(context));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: AppLocale.updateSchedule.getString(context),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void showErrorSnackbar(Object error) {
    var snackbar = SnackBar(
      content: error.toString().contains('No such host is known')
          ? Text(AppLocale.noConnectionToInternet.getString(context))
          : Text('${AppLocale.error.getString(context)}: ${error.toString()}'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget customWeekDayBuilder(date, context) {
    return Center(
      child: Column(
        children: [
          Text(
            DateFormat.E(localization.currentLocale?.languageCode == "uk" ? "uk_UA" : "en_UK").format(date),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: DateTime.now().compareWithoutTime(date)
                  ? const Color(0xFF00465F)
                  : Colors.transparent,
            ),
            child: SizedBox(
              width: 35,
              height: 35,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    DateFormat.d().format(date),
                    style: TextStyle(
                      fontSize: 16,
                      color: DateTime.now().day == date.day
                          ? Colors.white
                          : widget.themeManager.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
