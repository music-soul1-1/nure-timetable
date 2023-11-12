import 'package:flutter/material.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nure_timetable/widgets/settings_page_widgets.dart';

var systemBrightness = Brightness.dark;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.themeManager});

  final ThemeManager themeManager;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var settings = AppSettings.getDefaultSettings();
  late Future<AppSettings> settingsFuture;
  SharedPreferences? prefs;

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

  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;
    PackageInfo packageInfo;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: const Color(0xFF00465F),
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.settings_rounded,
                size: 28,
                color: Color(0xFF06DDF6),
              ),
            ),
            Text(
              "Налаштування",
              style: TextStyle(
                color: Color(0xFF06DDF6),
                fontSize: 20,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<AppSettings>(
        future: settingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Column(
              children: [
                Text('Error: ${snapshot.error}'),
                const Text("Спробуйте скинути налаштування:"),
                TextButton(
                  onPressed: () => showRemoveSettingsDialog(context),
                  child: const Text("Скинути налаштування"),
                ),
              ],
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
                  title: const Text('Загальне'),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.language),
                      title: const Text('Мова застосунку'),
                      onPressed: (context) {
                        const snackbar = SnackBar(
                          content: Text('На даний момент доступна лише українська мова'),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      },
                      value: Text(settings.language),
                    ),
                    SettingsTile.switchTile(
                      title: const Text('Використовувати системну тему'),
                      onToggle: (value) {
                        settings.useSystemTheme = value;
                        saveSettings(settings);
                      },
                      initialValue: settings.useSystemTheme,
                      leading: const Icon(Icons.format_paint),
                    ),
                    SettingsTile.switchTile(
                      title: const Text('Темна тема'),
                      enabled: !settings.useSystemTheme,
                      onToggle: (value) {
                        settings.darkThemeEnabled = value;
                        widget.themeManager.toggleTheme(value);
                        saveSettings(settings); // Save the settings when the switch changes.
                      },
                      initialValue: settings.darkThemeEnabled,
                      leading: const Icon(Icons.dark_mode),
                    ),
                  ],
                ),
                SettingsSection(
                  title: const Text("Розклад"),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      title: const Text("Початкова та кінцева дати розкладу"),
                      leading: const Icon(Icons.calendar_month_outlined),
                      onPressed: (context) {
                        showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2023, 1, 1),
                          lastDate: DateTime(2033),
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialDateRange: DateTimeRange(
                            start: DateTime.fromMillisecondsSinceEpoch(
                                int.parse(settings.startTime) * 1000),
                            end: DateTime.fromMillisecondsSinceEpoch(
                                int.parse(settings.endTime) * 1000),
                          ),
                        ).then((value) {
                          setState(() {
                            if (value != null) {
                              settings.startTime =
                                  (value.start.millisecondsSinceEpoch ~/ 1000).toString();
                              settings.endTime =
                                  (value.end.millisecondsSinceEpoch ~/ 1000).toString();

                              saveSettings(settings);
                            }
                          });
                        });
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: const Text("Інше"),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      title: const Text("Скинути налаштування"),
                      leading: const Icon(Icons.restore),
                      onPressed: (context) => showRemoveSettingsDialog(context),
                    ),
                    SettingsTile.navigation(
                      title: const Text("Версія застосунку"), 
                      leading: const Icon(Icons.info_outline),
                      value: FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Завантаження...");
                          }
                          else if (snapshot.hasError) {
                            return const Text("Помилка завантаження версії");
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
                              return CustomAboutDialog(packageInfo: info);
                            }
                          )
                        });
                      },
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
