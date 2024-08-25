import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/search_item.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/settings/settings_manager.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:nure_timetable/types/entity_type.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';


var systemBrightness = Brightness.dark;
var isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);


class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key, required this.settingsManager, required this.themeManager});

  final ThemeManager themeManager;
  final SettingsManager settingsManager;

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  var timetable = Timetable();
  List<Group> groups = [];
  List<Teacher> teachers = [];
  List<SearchItem> searchResult = [];
  List<SearchItem> allItems = [];

  @override
  void initState() {
    super.initState();
    loadItems().then((_) {
      if (mounted) {
        setState(() {
          widget.themeManager.toggleTheme(widget.settingsManager.settings.useSystemTheme ? 
            (systemBrightness == Brightness.dark) : 
            widget.settingsManager.settings.darkThemeEnabled
          );
        });
      }
    });
  }

  Future<void> loadItems() async {
    try {
      allItems = await getItems();
    }
    catch(error) {
      if (kDebugMode) {
        print(error);
      }
      showErrorSnackbar(error);
    }
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

  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      appBar: Header(AppLocale.groups.getString(context), Icons.people_alt),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocale.enterNameOfGroupOrTeacher.getString(context),
                ),
                onChanged: (value) async => {
                  setState(() {
                    searchResult = allItems.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
                  }),
                },
              ),
            ),
            SizedBox(
              height: isMobile ? 600 : 450,
              child: ListView(
                children: searchResult.map((item) => ListTile(
                  title: Text(item.name),
                  onTap: () async {
                    try {
                      switch (item.type) {
                        case EntityType.group:
                          widget.settingsManager.settings.group = item.group!;
                          widget.settingsManager.settings.type = EntityType.group;

                          break;
                        case EntityType.teacher:
                          widget.settingsManager.settings.teacher = item.teacher!;
                          widget.settingsManager.settings.type = EntityType.teacher;

                          break;
                        case EntityType.auditory:
                          widget.settingsManager.settings.auditory = item.auditory!;
                          widget.settingsManager.settings.type = EntityType.auditory;

                          break;
                      }
                      
                      widget.settingsManager.saveSettings(widget.settingsManager.settings);

                      var snackbar = SnackBar(
                        content: 
                          Text(
                            switch (widget.settingsManager.settings.type) {
                              (EntityType.group) => AppLocale.groupChanged.getString(context),
                              (EntityType.teacher) => AppLocale.teacherChanged.getString(context),
                              (EntityType.auditory) => AppLocale.auditoryChanged.getString(context),
                            },
                          ),
                        duration: const Duration(seconds: 1),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                    catch(error) {
                      showErrorSnackbar(error);
                    }
                  },
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}