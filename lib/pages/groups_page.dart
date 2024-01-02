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


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/models/search_item.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';


var systemBrightness = Brightness.dark;


class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key, required this.themeManager});

  final ThemeManager themeManager;

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  var timetable = Timetable();
  var settings = AppSettings.getDefaultSettings();
  List<Group> groups = [];
  List<Teacher> teachers = [];
  List<SearchItem> searchResult = [];
  List<SearchItem> allItems = [];

  @override
  void initState() {
    super.initState();
    loadSettings().then((value) => setState(() {
      widget.themeManager.toggleTheme(value.useSystemTheme ? (systemBrightness == Brightness.dark) : value.darkThemeEnabled);
      settings = value;
    }));
    loadItems();
  }

  void loadItems() async {
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
      // TODO: music-soul1-1: Change that to proper Internet connection check.
      content: error.toString().contains('No such host is known')
          ? const Text("Немає підключення до Інтернету.")
          : Text('Помилка: ${error.toString()}'),
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
                      if (item.type == 'group') {
                        settings.group = item.group!;
                        settings.type = "group";
                      }
                      else {
                        settings.teacher = item.teacher!;
                        settings.type = "teacher";
                      }
                      
                      saveSettings(settings);

                      var snackbar = SnackBar(
                        content: Text(settings.type == "group"
                                    ? AppLocale.groupChanged.getString(context)
                                    : AppLocale.teacherChanged
                                        .getString(context)),
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