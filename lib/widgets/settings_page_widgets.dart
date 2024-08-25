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


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:nure_timetable/locales/locales.dart';
import 'package:nure_timetable/models/settings.dart';
import 'package:nure_timetable/models/update_info.dart';
import 'package:nure_timetable/settings/settings_manager.dart';
import 'package:nure_timetable/widgets/helper_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutAppDialog extends StatelessWidget {
  final PackageInfo packageInfo;

  const AboutAppDialog({
    super.key,
    required this.packageInfo
  });

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: packageInfo.appName,
      applicationVersion: '${packageInfo.version}. Version code: ${packageInfo.buildNumber}',
      applicationIcon: const Icon(Icons.info_outline),
      applicationLegalese: "© 2023-2024 music-soul1-1",
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              const Text(
                "NureTimetable is an app for viewing schedule for groups, teachers or auditoriums of \n"
                "Kharkiv National University of Radio Electronics.\n"
                "Copyright (C) 2023-2024  music-soul1-1\n\n"

                "This program is free software: you can redistribute it and/or modify\n"
                "it under the terms of the GNU General Public License as published by\n"
                "the Free Software Foundation, either version 3 of the License, or\n"
                "(at your option) any later version.\n\n"

                "This program is distributed in the hope that it will be useful,\n"
                "but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
                "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
                "GNU General Public License for more details.\n\n"

                "You should have received a copy of the GNU General Public License\n"
                "along with this program.  If not, see <https://www.gnu.org/licenses/>.\n",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Source code: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _launchUrl('https://github.com/music-soul1-1/nure-timetable');
                    },
                    child: const Text("GitHub"),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "License: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _launchUrl('https://github.com/music-soul1-1/nure-timetable/blob/main/LICENSE');
                    },
                    child: const Text("GPL-3.0")
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "API: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    child: const Text("Documentation"),
                    onPressed: () => _launchUrl("https://music-soul1-1.github.io/NureTimetableAPI.Docs/"),
                  ),
                  TextButton(
                    child: const Text("GitHub"),
                    onPressed: () => _launchUrl("https://github.com/music-soul1-1/NureTimetableAPI"),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}


Future<dynamic> showRemoveSettingsDialog(BuildContext context, SettingsManager settingsManager) {
  return showDialog(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocale.doYouReallyWantToResetSettings.getString(context)),
        actions: [
          TextButton(
            onPressed: () {
              settingsManager.removeSettings(removeSchedule: true);
              Navigator.of(context).pop();
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
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}


Future<dynamic> showUpdateDialog(BuildContext context, PackageInfo packageInfo, UpdateInfo updateInfo) {
  bool needsUpdate = compareVersions("v.${packageInfo.version}", updateInfo.version);
  return showDialog(
    context: context, 
    builder: (BuildContext context) {
      return needsUpdate ? 
      AlertDialog(
        title: Text(AppLocale.newVersionAvailable.getString(context)),
        content: Text("${AppLocale.yourVersion.getString(context)}: v.${packageInfo.version}\n"
          "${AppLocale.latestVersion.getString(context)}: ${updateInfo.version}\n\n"
          "${AppLocale.downloadUpdate.getString(context)}",
        ),
        actions: [
          TextButton(
            child: Text(AppLocale.yes.getString(context)),
            onPressed: () {
              _launchUrl(Platform.isAndroid
                      ? updateInfo.apkDownloadUrl
                      : (Platform.isWindows
                          ? updateInfo.exeDownloadUrl
                          : updateInfo.url));
            }
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocale.no.getString(context)),
          ),
        ],
      ) : 
      AlertDialog(
        title: Text(AppLocale.youAreUsingLatestVersion.getString(context)),
        content: Text("${AppLocale.yourVersion.getString(context)}: v.${packageInfo.version}\n"),
        actions: [
          TextButton(
            onPressed: () => _launchUrl(updateInfo.url),
            child: Text(AppLocale.goToGithub.getString(context))
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocale.close.getString(context)),
          ),
        ],
      );
    }
  );
}

Future<dynamic> showFeedbackDialog(BuildContext context) {
  return showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text(AppLocale.sendReview.getString(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocale.close.getString(context)),
          ),
          TextButton(
            onPressed: () {
              _launchUrl("https://forms.gle/bCrh8KCNY3BiZgSs7");
              Navigator.of(context).pop();
            },
            child: Text(AppLocale.fillGoogleForm.getString(context)),
          ),
        ],
      );
    }
  );
}

CustomSettingsSection settingsErrorSection(AsyncSnapshot<AppSettings> snapshot, BuildContext context) {
  return CustomSettingsSection(
    child: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("${AppLocale.errorLoadingSettings.getString(context)}:"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                snapshot.error.toString(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: snapshot.error.toString(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackbar(AppLocale.errorCopiedToClipboard.getString(context))
                    );
                  }
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text("${AppLocale.tryToResetSettings.getString(context)}:"),
          ),
        ],
      ),
    ),
  );
}
