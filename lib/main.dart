// Flutter
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

// Pages
import 'pages/home_page.dart';
import 'pages/groups_page.dart';
import 'pages/settings_page.dart';

// Libraries
import 'package:calendar_view/calendar_view.dart';

// Theme
import 'theme/theme_manager.dart';


var _themeManager = ThemeManager();

// TODO: music-soul1-1: change app icons for every platform (currently windows and android)
// TODO: music-soul1-1: add app locales
void main() {
  runApp(const MyApp());
  initializeDateFormatting('uk_UA');
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener(){
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        title: 'NureTimetable',
        locale: const Locale('uk', 'UA'),
        themeMode: _themeManager.themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00465F),
            brightness: Brightness.light,
            background: const Color.fromARGB(255, 240, 240, 240),
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00465F),
            brightness: Brightness.dark,
            background: const Color.fromARGB(255, 0, 15, 19)
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: TabBarView(
              children: [
                HomePage(themeManager: _themeManager,),
                GroupsPage(title: "Групи", themeManager: _themeManager),
                SettingsPage(themeManager: _themeManager),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(7, 0, 70, 95),
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(51, 0, 70, 95),
                    width: 0.5,
                  ),
                )
              ),
              child: const TabBar(
                tabs: [
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(Icons.calendar_month),
                    text: "Розклад",
                    height: 50,
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(Icons.people_alt),
                    height: 50,
                    text: "Групи",
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(Icons.settings_rounded),
                    height: 50,
                    text: "Налаштування"
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


