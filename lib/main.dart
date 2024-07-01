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


// Flutter
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nure_timetable/settings/settings_manager.dart';

// Pages
import 'pages/home_page.dart';
import 'pages/groups_page.dart';
import 'pages/settings_page.dart';

// Libraries
import 'package:calendar_view/calendar_view.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/theme/themes.dart';
import 'package:flutter_localization/flutter_localization.dart';

// Theme
import 'theme/theme_manager.dart';


var _themeManager = ThemeManager();
var _settingsManager = SettingsManager();
final FlutterLocalization localization = FlutterLocalization.instance;

void main() async {
  await _settingsManager.loadSettings();
  
  runApp(const MyApp());
  initializeDateFormatting(localization.currentLocale?.languageCode == "uk" ? 'uk_UA' : 'en_UK');
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
    _settingsManager.removeListener(settingsListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    _settingsManager.addListener(settingsListener);

    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('uk', AppLocale.UA),
      ],
      initLanguageCode: 'uk',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;

    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  themeListener() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  settingsListener() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //setState(() {});
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        title: 'NureTimetable',
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        themeMode: _themeManager.themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: TabBarView(
              children: [
                HomePage(settingsManager: _settingsManager, themeManager: _themeManager),
                GroupsPage(settingsManager: _settingsManager, themeManager: _themeManager),
                SettingsPage(settingsManager: _settingsManager, themeManager: _themeManager, localization: localization),
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
              child: TabBar(
                tabs: [
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    icon: const Icon(Icons.calendar_month),
                    text: AppLocale.getSchedule(localization),
                    height: 50,
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    icon: const Icon(Icons.people_alt),
                    height: 50,
                    text: AppLocale.getGroups(localization),
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    icon: const Icon(Icons.settings_rounded),
                    height: 50,
                    text: AppLocale.getSettings(localization),
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


