import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/search_item.dart';
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
  Future<List<SearchItem>>? allItems;
  List<SearchItem> searchResult = [];

  @override
  void initState() {
    super.initState();

    allItems = loadItems();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      systemBrightness = MediaQuery.of(context).platformBrightness;
      final useDarkTheme = widget.settingsManager.settings.useSystemTheme
          ? (systemBrightness == Brightness.dark)
          : widget.settingsManager.settings.darkThemeEnabled;

      setState(() {
        widget.themeManager.toggleTheme(useDarkTheme);
      });
    });
  }

  Future<List<SearchItem>>? loadItems() async {
    try {
      var items = await SearchItem.getItems();

      return items;
    }
    catch(error) {
      if (kDebugMode) {
        print(error);
      }
      showErrorSnackbar(error.toString());

      return Future.value([]);
    }
  }

  void showErrorSnackbar(String error) {
    var snackbar = SnackBar(
      content: error.contains('No such host is known')
          ? Text(AppLocale.noConnectionToInternet.getString(context))
          : Text('${AppLocale.error.getString(context)}: $error'),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: AppLocale.copy,
        textColor: widget.themeManager.themeMode == ThemeMode.dark
            ? const Color(0xFF06DDF6)
            : Colors.white,
        onPressed: () => Clipboard.setData(ClipboardData(text: error)),
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
        child: FutureBuilder<List<SearchItem>>(
          future: allItems,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocale.loading.getString(context)),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (snapshot.hasError) {
              showErrorSnackbar(snapshot.error.toString());
            }

            if (snapshot.hasData) {
              var items = snapshot.data!;

              return Column(
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
                          searchResult = items.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();                          
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
                            showErrorSnackbar(error.toString());
                          }
                        },
                      )).toList(),
                    ),
                  ),
                ],
              );
            }

            return const Text('Error');
          }
        ),
      ),
    );
  }
}