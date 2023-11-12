import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';


var systemBrightness = Brightness.dark;


class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key, required this.title, required this.themeManager});

  final String title;
  final ThemeManager themeManager;

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  var timetable = Timetable();
  var settings = AppSettings.getDefaultSettings();
  List<Group> groups = [];
  List<Group> searchResult = [];


  Future<AppSettings> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = settingsToJson(settings);
    prefs.setString('appSettings', jsonString);

    return settings;
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('appSettings');

    if (jsonString == null) {
      return AppSettings.getDefaultSettings();
    }

    return settingsFromJson(jsonString);
  }

  void removeSettings() {
    final prefs = SharedPreferences.getInstance();
    prefs.then((value) => value.remove('appSettings'));
  }

  @override
  void initState() {
    super.initState();
    loadSettings().then((value) => setState(() {
      widget.themeManager.toggleTheme(value.useSystemTheme ? (systemBrightness == Brightness.dark) : value.darkThemeEnabled);
      settings = value;
    }));
    loadGroups();
  }

  void loadGroups() async {
    try {
      groups = await timetable.getGroups();
      setState(() {
        groups;
      });
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
      // TODO: music-soul1-1: Change that to proper Internet connection check.
      content: error.toString().contains('No such host is known')
          ? const Text("Немає підключення до Інтернету.")
          : Text('Помилка: ${error.toString()}'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;

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
                Icons.people_alt,
                size: 28,
                color: Color(0xFF06DDF6),
              ),
            ),
            Text(
              "Групи",
              style: TextStyle(
                color: Color(0xFF06DDF6),
                fontSize: 20,
                fontFamily: 'Inter'
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Введіть назву групи',
                ),
                onChanged: (value) async => {
                  setState(() {
                    searchResult = timetable.searchGroup(groups, value);
                  }),
                },
              ),
            ),
            SizedBox(
              height: 450,
              child: ListView(
                children: searchResult.map((group) => ListTile(
                  title: Text(group.name),
                  onTap: () async {
                    try {
                      settings.group = group;
                      
                      saveSettings(settings);

                      const snackbar = SnackBar(
                        content: Text('Групу змінено'),
                        duration: Duration(seconds: 1),
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