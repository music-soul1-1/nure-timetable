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


import 'dart:convert';
import 'package:g_json/g_json.dart';
import 'package:http/http.dart' as http;


class UpdateInfo {
  final String version;
  final String apkDownloadUrl;
  final String exeDownloadUrl;
  final String url;

  UpdateInfo({
    required this.version,
    required this.apkDownloadUrl,
    required this.exeDownloadUrl,
    required this.url,
  });
}

/// Returns the latest version of the app.
Future<UpdateInfo> getLatestVersion() async {
  const String url = 'https://api.github.com/repos/music-soul1-1/nure-timetable/releases/latest';

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    final mode = JSON.parse(response.body);
    final assets = mode['assets'].listValue;
    
    final apkDownloadUrl = assets
        .firstWhere((element) => element['browser_download_url']
            .stringValue
            .contains('apk'))['browser_download_url']
            .stringValue;
    final exeDownloadUrl = assets
        .firstWhere((element) => element['browser_download_url']
            .stringValue
            .contains('exe'))['browser_download_url']
            .stringValue;

    return UpdateInfo(
      version: json['tag_name'],
      apkDownloadUrl: apkDownloadUrl,
      exeDownloadUrl: exeDownloadUrl,
      url: json['html_url'],
    );
  }
  else {
    throw Exception('Failed to load latest version');
  }
}

/// Compares two versions.
/// Version value must be in format 'v.MAJOR.MINOR.PATCH'.
/// 
/// Returns true if [currentVersion] is older than [latestVersion].
bool compareVersions(String currentVersion, String latestVersion) {
  List<int> parseVersion(String version) {
    return version.split('.').map(int.parse).toList();
  }

  final List<int> current = parseVersion(currentVersion.substring(2)); // Remove the leading 'v.'
  final List<int> latest = parseVersion(latestVersion.substring(2));

  for (int i = 0; i < current.length; i++) {
    if (current[i] < latest[i]) {
      return true; // currentVersion is older
    }
    else if (current[i] > latest[i]) {
      return false; // currentVersion is newer
    }
  }

  return false;
}
