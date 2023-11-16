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


import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:flutter/material.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:nure_timetable/models/lesson_appointment.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:nure_timetable/widgets/home_page_widgets.dart';


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
      widget.themeManager.toggleTheme(value.useSystemTheme ? (systemBrightness == Brightness.dark) : settings.darkThemeEnabled);
      settings = value;
    }));
  }

  Future<void> _refresh() async {
    // Updates lessons data
    await _loadLessons(updateFromAPI: true);

    // .map method doesn't work here
    for (var event in controller.events) {
      controller.remove(event);
    }
    
    loadSettings().then((value) => setState(() {
      widget.themeManager.toggleTheme(value.useSystemTheme ? (systemBrightness == Brightness.dark) : settings.darkThemeEnabled);
      settings = value;
    }));
  }

  /// Loads lessons from API or cache.
  /// 
  /// If `updateFromAPI` is true, then lessons will be loaded from API, and then saved to local storage.
  Future<List<Lesson>> _loadLessons({bool updateFromAPI = false}) async {
    try {
      if (settings.group.id != "") {
        var lessonList = await loadSchedule();

        if (lessonList.isNotEmpty && !updateFromAPI) {
          return lessonList;
        }

        final lessons = timetable.getLessons(settings.group.id, settings.startTime, settings.endTime);

        lessons.then((lessons) => saveSchedule(lessons));

        return lessons;
      }
      else {
        return [];
      }
    }
    catch (error) {
      showErrorSnackbar(error);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: const Color(0xFF00465F),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.calendar_month_outlined,
                size: 28,
                color: Color(0xFF06DDF6),
              ),
            ),
            Text(
              settings.group.name,
              style: const TextStyle(
                color: Color(0xFF06DDF6),
                fontSize: 20,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
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
                      return Text('Error: ${snapshot.error}');
                    }
                    else if (snapshot.hasData) {
                      final lessons = snapshot.data!;
      
                      final events = lessons.map((lesson) {
                        return LessonAppointment(
                          startTime: DateTime.fromMillisecondsSinceEpoch(int.parse(lesson.startTime) * 1000),
                          endTime: DateTime.fromMillisecondsSinceEpoch(int.parse(lesson.endTime) * 1000),
                          lesson: lesson,
                          subject: lesson.subject.title,
                          color: lessonColor(lesson.type),
                        );
                      }).toList();

                      controller.addAll(events);
      
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - (isMobile ? 125 : 100),
                        child: WeekView(
                          key: weekViewKey,
                          backgroundColor: Colors.transparent,
                          weekDayBuilder: (date) => customWeekDayBuilder(date, context),
                          weekTitleHeight: 60,
                          headerStyle: const HeaderStyle(
                            leftIcon: Icon(Icons.arrow_back_rounded, color: Color(0xFF06DDF6),),
                            rightIcon: Icon(Icons.arrow_forward_rounded, color: Color(0xFF06DDF6),),
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
                          eventTileBuilder: customEventTileBuilder,
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
                            return customCalendarHeaderBuilder(startTime, endTime, controller, weekViewKey);
                          },
                          showLiveTimeLineInAllDays: false,
                          minDay: DateTime(2023, 1, 1),
                          maxDay: DateTime(2033, 3, 31),
                          pageTransitionDuration: const Duration(milliseconds: 200),
                          hourIndicatorSettings: HourIndicatorSettings(
                            color: widget.themeManager.themeMode == ThemeMode.dark ? const Color.fromARGB(64, 0, 70, 95) : Colors.black12,
                          ),
                          initialDay: DateTime.now(),                        
                          heightPerMinute: 1, // height occupied by 1 minute time span.
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
                      return const Text('No data');
                    }
                  },
                ),
              ),
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Оновити розклад',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void showErrorSnackbar(Object error) {
    var snackbar = SnackBar(
      // TODO: music-soul1-1: Change that to proper Internet connection check.
      content: error.toString().contains('No such host is known')
          ? const Text("Немає підключення до Інтернету.")
          : Text('Помилка: ${error.toString()}'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget customWeekDayBuilder(date, context) {
    return Center(
      child: Column(
        children: [
          Text(
            DateFormat.E('uk_UA').format(date),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: DateTime.now().compareWithoutTime(date) ? const Color(0xFF00465F) : Colors.transparent,
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
                        : widget.themeManager.themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
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
