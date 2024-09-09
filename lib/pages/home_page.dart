import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:flutter/material.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/lesson.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:nure_timetable/models/lesson_appointment.dart';
import 'package:nure_timetable/settings/settings_manager.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:nure_timetable/widgets/home_page_widgets.dart';
import 'package:nure_timetable/widgets/settings_page_widgets.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';


GlobalKey<WeekViewState> weekViewKey = GlobalKey<WeekViewState>();
var isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
var systemBrightness = Brightness.dark;


class HomePage extends StatefulWidget {
  const HomePage({
    super.key, 
    required this.settingsManager, 
    required this.themeManager,
    required this.scheduleFetchedNotifier,
  });

  final ThemeManager themeManager;
  final SettingsManager settingsManager;
  final ValueNotifier<bool> scheduleFetchedNotifier;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var timetable = Timetable();
  final EventController controller = EventController();
  Future<List<Lesson>>? _lessonsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.scheduleFetchedNotifier.value) {
      _loadLessons(updateFromAPI: true);
    }
  }

  @override
  void initState() {
    widget.settingsManager.addListener(_onSettingsChanged);
    widget.scheduleFetchedNotifier.addListener(_onScheduleFetchedChanged);

    _lessonsFuture = _loadLessons();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      systemBrightness = MediaQuery.of(context).platformBrightness;
      final useDarkTheme = widget.settingsManager.settings.useSystemTheme
          ? (systemBrightness == Brightness.dark)
          : widget.settingsManager.settings.darkThemeEnabled;

      setState(() {
        widget.themeManager.toggleTheme(useDarkTheme);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.settingsManager.removeListener(_onSettingsChanged);
    widget.scheduleFetchedNotifier.removeListener(_onScheduleFetchedChanged);

    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {
      _lessonsFuture = Future<List<Lesson>>.value(widget.settingsManager.schedule);
    });
  }

  void _onScheduleFetchedChanged() {
    if (widget.scheduleFetchedNotifier.value) {
      setState(() {
        _lessonsFuture = _loadLessons();
      });
    }
  }

  Future<void> _refresh() async {
    // Updates lessons from the API and saves them to local storage
    var lessons = await _loadLessons(updateFromAPI: true);

    List<CalendarEventData<Object?>> eventsToRemove = List.from(controller.allEvents);

    eventsToRemove.map((event) => controller.remove(event));

    if (mounted && lessons != null) {
      setState(() {
        _lessonsFuture = Future<List<Lesson>>.value(lessons);
        widget.scheduleFetchedNotifier.value = true;
      });
    }
  }

  /// Loads lessons from API or local storage.
  ///
  /// If `updateFromAPI` is true, then lessons will be loaded from API, and then saved to local storage.
  Future<List<Lesson>>? _loadLessons({bool updateFromAPI = false}) async {
    try {
      if (updateFromAPI) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context)
            .showSnackBar(snackbar(AppLocale.updatingSchedule.getString(context), duration: 4));
        });
      }

      var lessons = await widget.settingsManager.loadSchedule(updateFromAPI: updateFromAPI);

      if (updateFromAPI) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
            .showSnackBar(snackbar(AppLocale.scheduleUpdated.getString(context)));
        });
      }

      widget.scheduleFetchedNotifier.value = true;

      return lessons;
    }
    catch (error) {
      showErrorSnackbar(error);
      return [];
    }
  }

  void updateEvents(List<Lesson> lessons) {
    // Clear the controller before adding new events
    controller.removeWhere((event) => true);

    // Map lessons to events
    final events = lessons.map((lesson) {
      return LessonAppointment(
        startTime: DateTime.fromMillisecondsSinceEpoch(
            lesson.startTime * 1000),
        endTime: DateTime.fromMillisecondsSinceEpoch(
            lesson.endTime * 1000),
        lesson: lesson,
        subject: lesson.title,
        color: lessonColor(lesson.type, widget.settingsManager.settings.themeColors),
      );
    }).toList();

    // Add the new events
    controller.addAll(events);
  }

  /// Gets preferred initial day for the calendar view.
  DateTime getInitialDay() {
    if (widget.settingsManager.settings.scrollToFirstLesson) {
      var firstLesson = widget.settingsManager.getFirstLesson();

      if (firstLesson != null) {
        if (firstLesson.startTime * 1000 > DateTime.now().millisecondsSinceEpoch) {
          return DateTime.fromMillisecondsSinceEpoch(firstLesson.startTime * 1000);
        }
      }
    }

    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      appBar: HomeHeader(context, widget.settingsManager.settings, Icons.calendar_month_outlined),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: isMobile || MediaQuery.of(context).size.width < 700
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 20, right: 20),
              child: FutureBuilder<List<Lesson>>(
                future: _lessonsFuture,
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
                            onPressed: () => showRemoveSettingsDialog(context, widget.settingsManager),
                            child: Text(AppLocale.resetSettings.getString(context))),
                      ],
                    );
                  }
                  else if (snapshot.hasData) {
                    final lessons = snapshot.data!;

                    updateEvents(lessons);

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
                            customEventTileBuilder(date, events, boundary, start, end, widget.settingsManager.settings.themeColors)),
                        onEventTap: (events, date) {
                          if (events.isNotEmpty) {
                            final lessonEvent = events[0] as LessonAppointment;
                            showLessonInfoDialog(context, lessonEvent.lesson);
                          }
                        },
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
                        startHour: DateTime.now().timeZoneOffset.inHours + 4,
                        liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
                          color: Color(0xFF06DDF6),
                        ),
                        weekPageHeaderBuilder: (startTime, endTime) {
                          return customCalendarHeaderBuilder(
                              startTime, endTime, context, controller, weekViewKey, getInitialDay(),
                          );
                        },
                        showLiveTimeLineInAllDays: false,
                        minDay: DateTime.fromMillisecondsSinceEpoch(
                            widget.settingsManager.settings.startTime != null ? widget.settingsManager.settings.startTime !* 1000 : DateTime.now().subtract(const Duration(days: 300)).millisecondsSinceEpoch),
                        maxDay: DateTime.fromMillisecondsSinceEpoch(
                            widget.settingsManager.settings.endTime != null ? widget.settingsManager.settings.endTime !* 1000 : DateTime.now().add(const Duration(days: 300)).millisecondsSinceEpoch),
                        pageTransitionDuration:
                            const Duration(milliseconds: 200),
                        hourIndicatorSettings: HourIndicatorSettings(
                          color: widget.themeManager.themeMode == ThemeMode.dark
                              ? const Color.fromARGB(64, 0, 70, 95)
                              : Colors.black12,
                        ),
                        initialDay: getInitialDay(),
                        heightPerMinute:
                            1, // height occupied by 1 minute time span.
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
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: AppLocale.copy,
        textColor: widget.themeManager.themeMode == ThemeMode.dark
            ? const Color(0xFF06DDF6)
            : Colors.white,
        onPressed: () => Clipboard.setData(ClipboardData(text: error.toString())),
      ),
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
                      color: DateTime.now().compareWithoutTime(date)
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
