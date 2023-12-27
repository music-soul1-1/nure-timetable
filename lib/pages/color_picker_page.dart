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


import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';
import 'package:settings_ui/settings_ui.dart';


class ColorPickerPage extends StatefulWidget {
  final ThemeManager themeManager;
  final AppSettings outerSettings;

  const ColorPickerPage({super.key, required this.themeManager, required this.outerSettings});

  @override
   State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  late AppSettings settings;
  Color pickerColor = const Color(0xff443a49);


  @override
  void initState() {
    super.initState();
    settings = widget.outerSettings;
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header("Обрати кольори теми", Icons.color_lens_outlined),
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
        sections: [ // TODO: change that to loop and create a method for settings tile
          SettingsSection(
            title: const Text("Колірна тема"),
            tiles:  <SettingsTile>[
              SettingsTile.navigation(
                title: const Text("Колір лекцій"),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Виберіть колір лекцій'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: Color(int.parse(settings.themeColors.lecture)),
                            onColorChanged: changeColor,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Закрити")
                          ),
                          TextButton(
                            child: const Text("Застосувати"),
                            onPressed: () async {
                              settings.themeColors.lecture = pickerColor.value.toString();
                              Navigator.of(context).pop();
                              
                              await saveSettings(settings);
                              setState(() => settings.themeColors.lecture = pickerColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text("Колір практичних занять"),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Виберіть колір ПЗ'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: Color(int.parse(settings.themeColors.practice)),
                            onColorChanged: changeColor,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Закрити")
                          ),
                          TextButton(
                            child: const Text('Застосувати'),
                            onPressed: () async {
                              settings.themeColors.practice = pickerColor.value.toString();
                              Navigator.of(context).pop();
                              
                              await saveSettings(settings);
                              setState(() => settings.themeColors.practice = pickerColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text("Колір лабораторних робіт"),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Виберіть колір ЛБ'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: Color(int.parse(settings.themeColors.laboratory)),
                            onColorChanged: changeColor,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Закрити")
                          ),
                          TextButton(
                            child: const Text('Застосувати'),
                            onPressed: () async {
                              settings.themeColors.laboratory = pickerColor.value.toString();
                              Navigator.of(context).pop();
                              
                              await saveSettings(settings);
                              setState(() => settings.themeColors.laboratory = pickerColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text("Колір консультацій"),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Виберіть колір консультацій'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: Color(int.parse(settings.themeColors.consultation)),
                            onColorChanged: changeColor,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Закрити")
                          ),
                          TextButton(
                            child: const Text('Застосувати'),
                            onPressed: () async {
                              settings.themeColors.consultation = pickerColor.value.toString();
                              Navigator.of(context).pop();
                              
                              await saveSettings(settings);
                              setState(() => settings.themeColors.consultation = pickerColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text("Колір екзаменів"),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Виберіть колір екзаменів'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: Color(int.parse(settings.themeColors.exam)),
                            onColorChanged: changeColor,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Закрити")
                          ),
                          TextButton(
                            child: const Text('Застосувати'),
                            onPressed: () async {
                              settings.themeColors.exam = pickerColor.value.toString();
                              Navigator.of(context).pop();
                              
                              await saveSettings(settings);
                              setState(() => settings.themeColors.exam = pickerColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text("Колір інших занять"),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Виберіть колір інших занять'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: Color(int.parse(settings.themeColors.other)),
                            onColorChanged: changeColor,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Закрити")
                          ),
                          TextButton(
                            child: const Text('Застосувати'),
                            onPressed: () async {
                              settings.themeColors.other = pickerColor.value.toString();
                              Navigator.of(context).pop();
                              
                              await saveSettings(settings);
                              setState(() => settings.themeColors.other = pickerColor.value.toString());
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text("Інше"),
            tiles: [
              SettingsTile.navigation(
                title: const Text("Скинути налаштування кольорів"),
                leading: const Icon(Icons.restore_outlined),
                onPressed: (context) async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Ви дійсно хочете скинути ці налаштування?"),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              settings.themeColors = AppSettings.getDefaultSettings().themeColors;
                              Navigator.of(context).pop();

                              await saveSettings(settings);
                              setState(() => settings);
                            },
                            child: const Text("Так"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Ні"),
                          ),
                        ],
                      );
                    }
                  );
                  
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}