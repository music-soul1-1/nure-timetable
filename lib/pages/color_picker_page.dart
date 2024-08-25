import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/settings/settings_manager.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:nure_timetable/theme/themes.dart';
import '../types/lesson_type.dart';


class ColorPickerPage extends StatefulWidget {
  final ThemeManager themeManager;
  final SettingsManager settingsManager;

  const ColorPickerPage({super.key, required this.settingsManager, required this.themeManager});

  @override
   State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color pickerColor = const Color(0xff443a49);


  @override
  void initState() {
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(AppLocale.selectThemeColors.getString(context), Icons.color_lens_outlined),
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
            title: Text(AppLocale.colorTheme.getString(context)),
            tiles:  <SettingsTile>[
              SettingsTile.navigation(
                title: Text(AppLocale.lectureColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.lecture);
                },
              ),
              SettingsTile.navigation(
                title: Text(AppLocale.practiceColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.practice);
                },
              ),
              SettingsTile.navigation(
                title: Text(AppLocale.labColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.laboratory);
                },
              ),
              SettingsTile.navigation(
                title: Text(AppLocale.consultationColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.consultation);
                },
              ),
              SettingsTile.navigation(
                title: Text(AppLocale.testColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.test);
                },
              ),
              SettingsTile.navigation(
                title: Text(AppLocale.examColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.exam);
                },
              ),
              SettingsTile.navigation(
                title: Text(AppLocale.courseWorkColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.courseWork);
                },
              ),
              SettingsTile.navigation(
                title: Text(AppLocale.othersColor.getString(context)),
                leading: const Icon(Icons.color_lens_outlined),
                onPressed: (context) {
                  return showColorPicker(context, LessonType.other);
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocale.other.getString(context)),
            tiles: [
              SettingsTile.navigation(
                title: Text(AppLocale.resetColorSettings.getString(context)),
                leading: const Icon(Icons.restore_outlined),
                onPressed: (context) async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(AppLocale.doYouReallyWantToResetThisSettings.getString(context)),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              widget.settingsManager.settings.themeColors = AppSettings.getDefaultSettings().themeColors;
                              Navigator.of(context).pop();

                              await widget.settingsManager.saveSettings(widget.settingsManager.settings);
                              setState(() => widget.settingsManager.settings);
                            },
                            child: Text(AppLocale.yes.getString(context)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocale.no.getString(context)),
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

  Future<dynamic> showColorPicker(BuildContext context, LessonType type) {
    pickerColor = Color(int.parse(
      switch (type) {
        LessonType.lecture => widget.settingsManager.settings.themeColors.lecture,
        LessonType.practice => widget.settingsManager.settings.themeColors.practice,
        LessonType.laboratory => widget.settingsManager.settings.themeColors.laboratory,
        LessonType.consultation => widget.settingsManager.settings.themeColors.consultation,
        LessonType.test => widget.settingsManager.settings.themeColors.test,
        LessonType.exam => widget.settingsManager.settings.themeColors.exam,
        LessonType.courseWork => widget.settingsManager.settings.themeColors.courseWork,
        LessonType.other => widget.settingsManager.settings.themeColors.other,
      }
    ));

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
                  switch (type) {
                    LessonType.lecture => AppLocale.selectLectureColor.getString(context),
                    LessonType.practice => AppLocale.selectPracticeColor.getString(context),
                    LessonType.laboratory => AppLocale.selectLabColor.getString(context),
                    LessonType.consultation => AppLocale.selectConsultationColor.getString(context),
                    LessonType.test => AppLocale.selectTestColor.getString(context),
                    LessonType.exam => AppLocale.selectExamColor.getString(context),
                    LessonType.courseWork => AppLocale.selectCourseWorkColor.getString(context),
                    LessonType.other => AppLocale.selectOthersColor.getString(context),
                  }),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: pickerColor,
              onColorChanged: changeColor,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.wheel: true,
                ColorPickerType.primary: true,
                ColorPickerType.accent: false,
              },
              pickerTypeLabels: <ColorPickerType, String>{
                ColorPickerType.wheel: AppLocale.wheel.getString(context),
                ColorPickerType.primary: AppLocale.primary.getString(context),
              },
              subheading: Text(AppLocale.selectShade.getString(context)),
              wheelDiameter: 240,
              selectedPickerTypeColor: darkTheme.colorScheme.primary,
              wheelSquarePadding: 4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocale.close.getString(context))
            ),
            TextButton(
              child: Text(AppLocale.apply.getString(context)),
              onPressed: () async {
                switch (type) {
                  case LessonType.lecture: widget.settingsManager.settings.themeColors.lecture = pickerColor.value.toString();
                  case LessonType.practice: widget.settingsManager.settings.themeColors.practice = pickerColor.value.toString();
                  case LessonType.laboratory: widget.settingsManager.settings.themeColors.laboratory = pickerColor.value.toString();
                  case LessonType.consultation: widget.settingsManager.settings.themeColors.consultation = pickerColor.value.toString();
                  case LessonType.test: widget.settingsManager.settings.themeColors.test = pickerColor.value.toString();
                  case LessonType.exam: widget.settingsManager.settings.themeColors.exam = pickerColor.value.toString();
                  case LessonType.courseWork: widget.settingsManager.settings.themeColors.courseWork = pickerColor.value.toString();
                  case LessonType.other: widget.settingsManager.settings.themeColors.other = pickerColor.value.toString();
                }
                Navigator.of(context).pop();
                
                await widget.settingsManager.saveSettings(widget.settingsManager.settings);
                setState(() => {});
              },
            ),
          ],
        );
      },
    );
  }
}
