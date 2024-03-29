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


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/models/update_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nure_timetable/widgets/settings_page_widgets.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';
import 'package:nure_timetable/pages/color_picker_page.dart';


var systemBrightness = Brightness.dark;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.themeManager, required this.localization});

  final ThemeManager themeManager;
  final FlutterLocalization localization;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var settings = AppSettings.getDefaultSettings();
  late Future<AppSettings> settingsFuture;
  SharedPreferences? prefs;
  String latestVersion = "";

  @override
  void initState() {
    widget.themeManager.addListener(themeListener);
    super.initState();
    settingsFuture = getPreferences();
  }

  
  @override
  void dispose() {
    widget.themeManager.removeListener(themeListener);
    super.dispose();
  }

  themeListener(){
    if(mounted){
      setState(() {

      });
    }
  }

  Future<AppSettings> getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    final jsonString = prefs?.getString('appSettings');

    if (jsonString == null) {
      final settings = AppSettings.getDefaultSettings();
      await saveSettings(settings);

      widget.themeManager.toggleTheme(settings.useSystemTheme ? (systemBrightness == Brightness.dark) : settings.darkThemeEnabled);

      return settings;
    }
    else {
      final settings = settingsFromJson(jsonString);
      widget.themeManager.toggleTheme(settings.useSystemTheme ? (systemBrightness == Brightness.dark) : settings.darkThemeEnabled);
      return settingsFromJson(jsonString);
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final jsonString = settingsToJson(settings);
    prefs?.setString('appSettings', jsonString);
    setState(() {
    });
  }

  Future<void> checkForUpdates() async {
    final packageInfo = await PackageInfo.fromPlatform();

    getLatestVersion().then((updateInfo) => {
      setState(() {
        latestVersion = updateInfo.version;
        showUpdateDialog(context, packageInfo, updateInfo);
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;
    PackageInfo packageInfo;

    return Scaffold(
      appBar: Header(
        AppLocale.settings.getString(context), Icons.settings_rounded
      ),
      body: FutureBuilder<AppSettings>(
        future: settingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return SettingsList(
                  platform: DevicePlatform.android,
                  darkTheme: const SettingsThemeData(
                    settingsListBackground: Color.fromARGB(255, 0, 15, 19),
                    settingsSectionBackground: Color.fromARGB(255, 0, 25, 32),
                    tileHighlightColor: Color.fromARGB(255, 0, 34, 47),
                  ),
                  lightTheme: const SettingsThemeData(
                    settingsListBackground: Color.fromARGB(255, 240, 240, 240),
                  ),
                  sections: [
                    settingsErrorSection(snapshot, context),
                    SettingsSection(
                      title: Text(AppLocale.other.getString(context)),
                      tiles: <SettingsTile>[                    
                        SettingsTile.navigation(
                          title: Text(AppLocale.resetSettings.getString(context)),
                          leading: const Icon(Icons.restore),
                          onPressed: (context) => showRemoveSettingsDialog(context),
                        ),
                        SettingsTile.navigation(
                          title: Text(AppLocale.appVersion.getString(context)), 
                          leading: const Icon(Icons.info_outline),
                          value: FutureBuilder(
                            future: PackageInfo.fromPlatform(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(AppLocale.loading.getString(context));
                              }
                              else if (snapshot.hasError) {
                                return Text(AppLocale.errorLoadingVersion.getString(context));
                              }
                              else {
                                packageInfo = snapshot.data as PackageInfo;
                                return Text(packageInfo.version);
                              }
                            }
                          ),
                          onPressed: (context) {
                            PackageInfo.fromPlatform().then((info) => {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AboutAppDialog(packageInfo: info);
                                }
                              )
                            });
                          },
                        ),
                        SettingsTile.navigation(
                          title: Text(AppLocale.checkUpdates.getString(context)),
                          leading: const Icon(Icons.update),
                          onPressed: (context) => checkForUpdates(),
                        ),
                        SettingsTile.navigation(
                          title: Text(AppLocale.sendReviewOrBugReport.getString(context)),
                          leading: const Icon(Icons.bug_report_outlined),
                          onPressed: (context) => showFeedbackDialog(context),
                        ),
                      ],
                    ),
                  ]
                
            );
          }
          else {
            final settings = snapshot.data!;

            return SettingsList(
              platform: DevicePlatform.android,
              darkTheme: const SettingsThemeData(
                settingsListBackground: Color.fromARGB(255, 0, 15, 19),
                settingsSectionBackground: Color.fromARGB(255, 0, 25, 32),
                tileHighlightColor: Color.fromARGB(255, 0, 34, 47),
              ),
              lightTheme: const SettingsThemeData(
                settingsListBackground: Color.fromARGB(255, 240, 240, 240),
              ),
              sections: [
                SettingsSection(
                  title: Text(AppLocale.general.getString(context)),
                  tiles: <SettingsTile>[
                    SettingsTile(
                      title: Text(AppLocale.appLanguage.getString(context)),
                      leading: const Icon(Icons.language),
                      value: Text(AppLocale.languages.firstWhere((element) => element['code'] == settings.language)['title']!),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(AppLocale.selectLanguage.getString(context)),
                              content: SizedBox(
                                width: double.minPositive,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 2,
                                  itemBuilder: (context, index) {                                    
                                    return ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text(AppLocale.languages[index]['title']!),
                                      onTap: () {
                                        var code = AppLocale.languages[index]['code'];

                                        if (code != null) {
                                          widget.localization.translate(code);
                                          settings.language = code;
                                          saveSettings(settings);
                                        }
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    SettingsTile.switchTile(
                      title: Text(AppLocale.useSystemTheme.getString(context)),
                      onToggle: (value) {
                        settings.useSystemTheme = value;
                        widget.themeManager.toggleTheme(value ? (systemBrightness == Brightness.dark) : settings.darkThemeEnabled);
                        saveSettings(settings);
                      },
                      initialValue: settings.useSystemTheme,
                      leading: const Icon(Icons.format_paint),
                    ),
                    SettingsTile.switchTile(
                      title: Text(AppLocale.darkTheme.getString(context)),
                      enabled: !settings.useSystemTheme,
                      onToggle: (value) {
                        settings.darkThemeEnabled = value;
                        widget.themeManager.toggleTheme(value);
                        saveSettings(settings); // Save the settings when the switch changes.
                      },
                      initialValue: settings.darkThemeEnabled,
                      leading: const Icon(Icons.dark_mode),
                    ),
                    SettingsTile(title: Text(AppLocale.themeColors.getString(context)),
                      leading: const Icon(Icons.color_lens_outlined),
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorPickerPage(themeManager: widget.themeManager, outerSettings: settings),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(AppLocale.schedule.getString(context)),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      title: Text(AppLocale.startAndEndDateOfSchedule.getString(context)),
                      leading: const Icon(Icons.calendar_month_outlined),
                      onPressed: (context) {
                        showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialDateRange: DateTimeRange(
                            start: DateTime.fromMillisecondsSinceEpoch(
                                settings.startTime * 1000),
                            end: DateTime.fromMillisecondsSinceEpoch(
                                settings.endTime * 1000),
                          ),
                        ).then((value) {
                          setState(() {
                            if (value != null) {
                              settings.startTime =
                                  (value.start.millisecondsSinceEpoch ~/ 1000);
                              settings.endTime =
                                  (value.end.millisecondsSinceEpoch ~/ 1000);

                              saveSettings(settings);
                            }
                          });
                        });
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text(AppLocale.lastScheduleUpdate.getString(context)),
                      leading: const Icon(Icons.file_download_outlined),
                      value: Text(DateTime.fromMillisecondsSinceEpoch(settings.lastUpdated * 1000).toLocal().toString().substring(0, 16)),
                    ),
                    SettingsTile.navigation(
                      title: Text("${AppLocale.typeOfSchedule.getString(context)}:"),
                      leading: const Icon(Icons.people_alt_outlined),
                      value: Text(
                        settings.type == 'group' ? AppLocale.group.getString(context) : AppLocale.teacher.getString(context),
                      ),
                      onPressed: (context) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackbar(
                                settings.type == 'group'
                                    ? AppLocale.happyLearning.getString(context)
                                    : AppLocale.happyTeaching
                                        .getString(context))
                        ),
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(AppLocale.other.getString(context)),
                  tiles: <SettingsTile>[                    
                    SettingsTile.navigation(
                      title: Text(AppLocale.resetSettings.getString(context)),
                      leading: const Icon(Icons.restore),
                      onPressed: (context) => showRemoveSettingsDialog(context),
                    ),
                    SettingsTile.navigation(
                      title: Text(AppLocale.appVersion.getString(context)), 
                      leading: const Icon(Icons.info_outline),
                      value: FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(AppLocale.loading.getString(context));
                          }
                          else if (snapshot.hasError) {
                            return Text(AppLocale.errorLoadingVersion.getString(context));
                          }
                          else {
                            packageInfo = snapshot.data as PackageInfo;
                            return Text(packageInfo.version);
                          }
                        }
                      ),
                      onPressed: (context) {
                        PackageInfo.fromPlatform().then((info) => {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AboutAppDialog(packageInfo: info);
                            }
                          )
                        });
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text(AppLocale.checkUpdates.getString(context)),
                      enabled: !kIsWeb,
                      leading: const Icon(Icons.update),
                      onPressed: (context) => checkForUpdates(),
                    ),
                    SettingsTile.navigation(
                      title: Text(AppLocale.sendReviewOrBugReport.getString(context)),
                      leading: const Icon(Icons.bug_report_outlined),
                      onPressed: (context) => showFeedbackDialog(context),
                    ),
                  ]
                )
              ],
            );
          }
        }
      )
    );
  }
}
