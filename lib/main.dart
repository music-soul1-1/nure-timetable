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


// Flutter
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nure_timetable/theme/themes.dart';

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
        theme: lightTheme,
        darkTheme: darkTheme,
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


