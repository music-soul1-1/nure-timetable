# NureTimetable

Schedule app for Kharkiv National University of Radio Electronics. Written in Flutter.
Uses [NureTimetableAPI](https://github.com/music-soul1-1/NureTimetableAPI).


## Features
- view schedule for group, teacher or auditorium.
- fast app start.
- cross-platform (web version [available](https://www.nure-time.pp.ua/)).
- uses [NureTimetableAPI](https://github.com/music-soul1-1/NureTimetableAPI).
- Material design.
- dark and light themes.
- offline support.
- customize calendar theme colors.
- Ukrainian and English languages.


## Plans
- change app icons for Linux
- refactor and optimize code
- update some dependencies


## Screenshots
Windows:
![image](https://github.com/music-soul1-1/nure-timetable/assets/72669184/c85fb945-3836-4fd5-9770-3c26c35d0dce)
![image2](https://github.com/music-soul1-1/nure-timetable/assets/72669184/ce09bd50-53ad-44f6-8137-a9b13ba832f6)

Android:
![imgonline-com-ua-twotoone-kpiWCmWmVtg0i](https://github.com/music-soul1-1/nure-timetable/assets/72669184/cbce1fbf-5600-416f-b58e-e779671829ff)


## For developers

If you are going to change models (that use JsonSerializableGenerator), please regenetate part files before starting debugging:
```
flutter pub run build_runner build
```


## Dependencies
-  [json_annotation](https://pub.dev/packages/json_annotation)
-  [http](https://pub.dev/packages/http)
-  [intl](https://pub.dev/packages/intl)
-  [shared_preferences](https://pub.dev/packages/shared_preferences)
-  [calendar_view](https://pub.dev/packages/calendar_view)
-  [flutter_settings_ui](https://pub.dev/packages/flutter_settings_ui)
-  [package_info_plus](https://pub.dev/packages/package_info_plus)
-  [url_launcher](https://pub.dev/packages/url_launcher)
-  [g_json](https://pub.dev/packages/g_json)
-  [flex_color_picker](https://pub.dev/packages/flex_color_picker)
-  [flutter_localization](https://pub.dev/packages/flutter_localization)


## License

This app is licensed under [GNU General Public License](https://github.com/music-soul1-1/nure-timetable/blob/main/LICENSE).

Copyright (C) 2023-2024  music-soul1-1
