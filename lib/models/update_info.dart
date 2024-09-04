import 'dart:convert';
import 'package:g_json/g_json.dart';
import 'package:http/http.dart' as http;


class UpdateInfo {
  final String version;
  final String apkDownloadUrl;
  final String exeDownloadUrl;
  final String githubUrl;

  UpdateInfo({
    required this.version,
    required this.apkDownloadUrl,
    required this.exeDownloadUrl,
    required this.githubUrl,
  });
}

/// Returns the latest version of the app.
Future<UpdateInfo?> getLatestVersion() async {
  try {
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
        githubUrl: json['html_url'],
      );
    }

    return null;
  }
  catch (e) {
    throw Exception('Failed to load latest version: $e');
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
