# NureTimetable

Schedule app for Kharkiv National University of Radio Electronics. Written in Flutter.
Uses [nure-api](https://github.com/mindenit/nure-api).


## Features
- view schedule for group or teacher.
- fast app start.
- cross-platform.
- uses [nure-api](https://github.com/mindenit/nure-api).
- Material design.
- dark and light themes.
- offline support.
- customize calendar theme colors.


## Plans
- automate schedule date picker (so that the app shows schedule for current semester automatically)
- change app icons for every platform (currently Windows and Android)
- add English locale
- host web version
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
- json_annotation: ^4.8.1
- http: ^1.1.0
- intl: ^0.18.1
- shared_preferences: ^2.2.2
- calendar_view: ^1.0.4
- settings_ui: ^2.0.2
- package_info_plus: ^4.2.0
- url_launcher: ^6.2.1
- build_runner: ^2.1.5
- json_serializable: ^6.1.4


## License

This app is licensed under [GNU General Public License](https://github.com/music-soul1-1/nure-timetable/blob/main/LICENSE).

Copyright (C) 2023  music-soul1-1
