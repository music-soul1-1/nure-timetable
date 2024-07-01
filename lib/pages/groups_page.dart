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

  void showErrorSnackbar(Object error, [BuildContext? ctx]) {
    var snackbar = SnackBar(
      content: error.toString().contains('No such host is known')
            ? Text(AppLocale.noConnectionToInternet.getString(context))
          : Text('${AppLocale.error.getString(context)}: ${error.toString()}'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(ctx ?? context).showSnackBar(snackbar);
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
              height: 450,
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