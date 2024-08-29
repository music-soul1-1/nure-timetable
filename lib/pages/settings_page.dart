import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/settings/settings_manager.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:nure_timetable/models/update_info.dart';
import 'package:nure_timetable/types/entity_type.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nure_timetable/widgets/settings_page_widgets.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';
import 'package:nure_timetable/pages/color_picker_page.dart';


var systemBrightness = Brightness.dark;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.settingsManager, required this.themeManager, required this.localization});

  final ThemeManager themeManager;
  final SettingsManager settingsManager;
  final FlutterLocalization localization;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String latestVersion = "";
  
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
      body: SettingsList(
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
                      value: Text(AppLocale.languages.firstWhere((element) => element['code'] == widget.settingsManager.settings.language)['title']!),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(AppLocale.selectLanguage.getString(context)),
                              content: SizedBox(
                                width: 350,
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
                                          widget.settingsManager.settings.language = code;
                                          widget.settingsManager.saveSettings(widget.settingsManager.settings);
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
                        widget.settingsManager.settings.useSystemTheme = value;
                        widget.themeManager.toggleTheme(value ? (systemBrightness == Brightness.dark) : widget.settingsManager.settings.darkThemeEnabled);
                        widget.settingsManager.saveSettings(widget.settingsManager.settings);
                      },
                      initialValue: widget.settingsManager.settings.useSystemTheme,
                      leading: const Icon(Icons.format_paint),
                    ),
                    SettingsTile.switchTile(
                      title: Text(AppLocale.darkTheme.getString(context)),
                      enabled: !widget.settingsManager.settings.useSystemTheme,
                      onToggle: (value) {
                        widget.settingsManager.settings.darkThemeEnabled = value;
                        widget.themeManager.toggleTheme(value);
                        widget.settingsManager.saveSettings(widget.settingsManager.settings); // Save the settings when the switch changes.
                      },
                      initialValue: widget.settingsManager.settings.darkThemeEnabled,
                      leading: const Icon(Icons.dark_mode),
                    ),
                    SettingsTile(title: Text(AppLocale.themeColors.getString(context)),
                      leading: const Icon(Icons.color_lens_outlined),
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorPickerPage(settingsManager: widget.settingsManager, themeManager: widget.themeManager),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text(AppLocale.schedule.getString(context)),
                  tiles: <SettingsTile>[
                    SettingsTile.switchTile(
                      title: Text(AppLocale.scrollToFirstLesson.getString(context)),
                      leading: const Icon(Icons.skip_next_outlined),
                      initialValue: widget.settingsManager.settings.scrollToFirstLesson,
                      onToggle: (value) async {
                        widget.settingsManager.settings.scrollToFirstLesson = value;
                        await widget.settingsManager.saveSettings(widget.settingsManager.settings);

                        setState(() {});
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text(AppLocale.startAndEndDateOfSchedule.getString(context)),
                      leading: const Icon(Icons.calendar_month_outlined),
                      value: Text(
                        widget.settingsManager.settings.startTime == null
                        ? AppLocale.getAllLessons.getString(context)
                        : "${DateTime.fromMillisecondsSinceEpoch((widget.settingsManager.settings.startTime ?? 0) * 1000).toLocal().toString().substring(0, 10)} - " 
                        "${DateTime.fromMillisecondsSinceEpoch((widget.settingsManager.settings.endTime ?? 0) * 1000).toLocal().toString().substring(0, 10)}",
                      ),
                      onPressed: (context) {
                        showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialEntryMode: DatePickerEntryMode.input,
                          locale: widget.localization.currentLocale,
                        ).then((value) {
                          setState(() {
                            if (value != null) {
                              widget.settingsManager.settings.startTime =
                                  (value.start.millisecondsSinceEpoch ~/ 1000);
                              widget.settingsManager.settings.endTime =
                                  (value.end.millisecondsSinceEpoch ~/ 1000);

                              widget.settingsManager.saveSettings(widget.settingsManager.settings);
                            }
                          });
                        });
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text(AppLocale.resetDateSettings.getString(context)),
                      leading: const Icon(Icons.restore),
                      onPressed: (context) {
                        showRemoveScheduleDateSettingsDialog(context, widget.settingsManager);
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text(AppLocale.lastScheduleUpdate.getString(context)),
                      leading: const Icon(Icons.file_download_outlined),
                      value: Text(DateTime.fromMillisecondsSinceEpoch(widget.settingsManager.settings.lastUpdated * 1000).toLocal().toString().substring(0, 16)),
                    ),
                    SettingsTile.navigation(
                      title: Text("${AppLocale.typeOfSchedule.getString(context)}:"),
                      leading: const Icon(Icons.people_alt_outlined),
                      value: Text(
                        switch (widget.settingsManager.settings.type) {
                          (EntityType.group) => AppLocale.group.getString(context),
                          (EntityType.teacher) => AppLocale.teacher.getString(context),
                          (EntityType.auditory) => AppLocale.auditory.getString(context),
                        }
                      ),
                      onPressed: (context) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackbar(
                                (widget.settingsManager.settings.type == EntityType.group || widget.settingsManager.settings.type == EntityType.auditory)
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
                      onPressed: (context) => showRemoveSettingsDialog(context, widget.settingsManager),
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
            )
          );
        }
}
