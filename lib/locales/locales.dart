import 'package:flutter_localization/flutter_localization.dart';

mixin AppLocale {
  static const languages = [
    {'title': 'English', 'code': 'en'},
    {'title': 'Українська', 'code': 'uk'},
  ];

  static const title = 'title';
  static const appLanguage = 'appLanguage';
  static const schedule = "schedule";
  static const groups = "groups";
  static const settings = "settings";
  static const updateSchedule = "updateSchedule";
  static const updatingSchedule = "updatingSchedule";
  static const scheduleUpdated = "scheduleUpdated";
  static const tryToResetSettings = "tryToResetSettings";
  static const resetSettings = "resetSettings";
  static const noData = "noData";
  static const error = "error";
  static const noConnectionToInternet = "noConnectionToInternet";
  static const nextLesson = "nextLesson";
  static const noLessonsInNearFuture = "noLessonsInNearFuture";
  static const previousWeek = "previousWeek";
  static const currentWeek = "currentWeek";
  static const nextWeek = "nextWeek";
  static const type = "type";
  static const teachers = "teachers";
  static const time = "time";
  static const auditory = "auditory";
  static const close = "close";
  static const doYouReallyWantToResetSettings = "doYouReallyWantToResetSettings";
  static const yes = "yes";
  static const no = "no";
  static const newVersionAvailable = "newVersionAvailable";
  static const yourVersion = "yourVersion";
  static const latestVersion = "latestVersion";
  static const downloadUpdate = "downloadUpdate?";
  static const youAreUsingLatestVersion = "youAreUsingLatestVersion";
  static const goToGithub = "goToGithub";
  static const sendReview = "sendReview?";
  static const fillGoogleForm = "fillGoogleForm";
  static const errorLoadingSettings = "errorLoadingSettings";
  static const errorCopiedToClipboard = "errorCopiedToClipboard";
  static const enterNameOfGroupOrTeacher = "enterNameOfGroupOrTeacher";
  static const groupChanged = "groupChanged";
  static const teacherChanged = "teacherChanged";
  static const auditoryChanged = "auditoryChanged";
  static const other = "other";
  static const appVersion = "appVersion";
  static const loading = "loading...";
  static const errorLoadingVersion = "errorLoadingVersion";
  static const checkUpdates = "checkUpdates";
  static const sendReviewOrBugReport = "sendReviewOrBugReport";
  static const general = "general";
  static const selectLanguage = "selectLanguage";
  static const useSystemTheme = "useSystemTheme";
  static const darkTheme = "darkTheme";
  static const themeColors = "themeColors";
  static const startAndEndDateOfSchedule = "startAndEndDateOfSchedule";
  static const lastScheduleUpdate = "lastScheduleUpdate";
  static const typeOfSchedule = "typeOfSchedule";
  static const happyLearning = "happyLearning";
  static const happyTeaching = "happyTeaching";
  static const group = "group";
  static const teacher = "teacher";
  static const selectThemeColors = "selectThemeColors";
  static const colorTheme = "colorTheme";
  static const lectureColor = "lectureColor";
  static const selectLectureColor = "selectLectureColor";
  static const apply = "apply";
  static const practiceColor = "practiceColor";
  static const selectPracticeColor = "selectPracticeColor";
  static const labColor = "labColor";
  static const selectLabColor = "selectLabColor";
  static const consultationColor = "consultationColor";
  static const selectConsultationColor = "selectConsultationColor";
  static const testColor = "testColor";
  static const selectTestColor = "selectTestColor";
  static const examColor = "examColor";
  static const selectExamColor = "selectExamColor";
  static const courseWorkColor = "courseWorkColor";
  static const selectCourseWorkColor = "selectCourseWorkColor";
  static const othersColor = "othersColor";
  static const selectOthersColor = "selectOthersColor";
  static const resetColorSettings = "resetColorSettings";
  static const doYouReallyWantToResetThisSettings = "doYouReallyWantToResetThisSettings";
  static const copyDetails = "copyDetails";
  static const pairNumber = "numberPair";
  static const wheel = "wheel";
  static const primary = "primary";
  static const shade = "shade";
  static const selectShade = "selectShade";
  static const floor = "floor";
  static const copy = "copy";
  static const faculty = "faculty";
  static const direction = "direction";
  static const department = "department";
  static const building = "building";
  static const auditoryTypes = "auditoryTypes";
  static const hasPower = "hasPower";
  static const getAllLessons = "getAllLessons";
  static const resetDateSettings = "resetDateSettings";
  static const scrollToFirstLesson = "scrollToFirstLesson";


  // ignore: constant_identifier_names
  static const Map<String, dynamic> EN = {
    title: 'Localization',
    appLanguage: 'App language',
    schedule: "Schedule",
    groups: "Groups",
    settings: "Settings",
    updateSchedule: "Update schedule",
    updatingSchedule: "Updating schedule...",
    scheduleUpdated: "Schedule updated!",
    tryToResetSettings: "Try to reset settings",
    resetSettings: "Reset settings",
    noData: "No data",
    error: "Error",
    noConnectionToInternet: "No connection to the Internet",
    nextLesson: "Next lesson",
    noLessonsInNearFuture: "No lessons in the near future",
    previousWeek: "Previous week",
    currentWeek: "Current week",
    nextWeek: "Next week",
    type: "Type",
    teachers: "Teachers",
    time: "Time",
    auditory: "Auditory",
    close: "Close",
    doYouReallyWantToResetSettings: "Do you really want to reset settings?",
    yes: "Yes",
    no: "No",
    newVersionAvailable: "New version available",
    yourVersion: "Your version",
    latestVersion: "Latest version",
    downloadUpdate: "Download update?",
    youAreUsingLatestVersion: "You are using the latest version",
    goToGithub: "Go to Github",
    sendReview: "Send review?",
    fillGoogleForm: "Fill Google Form",
    errorLoadingSettings: "Error loading settings",
    errorCopiedToClipboard: "Error copied to clipboard",
    enterNameOfGroupOrTeacher: "Enter the name of group or teacher",
    groupChanged: "Group changed",
    teacherChanged: "Teacher changed",
    auditoryChanged: "Auditory changed",
    other: "Other",
    appVersion: "App version",
    loading: "Loading...",
    errorLoadingVersion: "Error loading version",
    checkUpdates: "Check for updates",
    sendReviewOrBugReport: "Send review/bug report",
    general: "General",
    selectLanguage: "Select language",
    useSystemTheme: "Use system theme",
    darkTheme: "Dark theme",
    themeColors: "Theme colors",
    startAndEndDateOfSchedule: "Start and end date of schedule",
    lastScheduleUpdate: "Last schedule update",
    typeOfSchedule: "Type of schedule",
    happyLearning: "Happy learning!",
    happyTeaching: "Happy teaching!",
    group: "Group",
    teacher: "Teacher",
    selectThemeColors: "Select theme colors",
    colorTheme: "Color theme",
    lectureColor: "Lecture color",
    selectLectureColor: "Select lecture color",
    apply: "Apply",
    practiceColor: "Practice color",
    selectPracticeColor: "Select practice color",
    labColor: "Lab color",
    selectLabColor: "Select lab color",
    consultationColor: "Consultation color",
    selectConsultationColor: "Select consultation color",
    testColor: "Test color",
    selectTestColor: "Select test color",
    examColor: "Exam color",
    selectExamColor: "Select exam color",
    othersColor: "Others color",
    courseWorkColor: "Course work color",
    selectCourseWorkColor: "Select course work color",
    selectOthersColor: "Select others color",
    resetColorSettings: "Reset color settings",
    doYouReallyWantToResetThisSettings: "Do you really want to reset this settings?",
    copyDetails: "Copy details",
    pairNumber: "Pair number",
    wheel: "Wheel",
    primary: "Primary",
    shade: "Shade",
    selectShade: "Select shade",
    floor: "Floor",
    copy: "Copy",
    faculty: "Faculty",
    direction: "Direction",
    department: "Department",
    building: "Building",
    auditoryTypes: "Auditory types",
    hasPower: "Has power",
    getAllLessons: "Get all lessons",
    resetDateSettings: "Reset date settings",
    scrollToFirstLesson: "Scroll to the first lesson",
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> UA = {
    title: 'Локалізація',
    appLanguage: 'Мова застосунку',
    schedule: "Розклад",
    groups: "Групи",
    settings: "Налаштування",
    updateSchedule: "Оновити розклад",
    updatingSchedule: "Оновлення розкладу...",
    scheduleUpdated: "Розклад оновлено!",
    tryToResetSettings: "Спробувати скинути налаштування",
    resetSettings: "Скинути налаштування",
    noData: "Немає даних",
    error: "Помилка",
    noConnectionToInternet: "Немає підключення до Інтернету",
    nextLesson: "Наступна пара",
    noLessonsInNearFuture: "Найближчим часом пар немає",
    previousWeek: "Попередній тиждень",
    currentWeek: "Поточний тиждень",
    nextWeek: "Наступний тиждень",
    type: "Тип",
    teachers: "Викладачі",
    time: "Час",
    auditory: "Аудиторія",
    close: "Закрити",
    doYouReallyWantToResetSettings: "Ви дійсно хочете скинути налаштування?",
    yes: "Так",
    no: "Ні",
    newVersionAvailable: "Доступна нова версія",
    yourVersion: "Ваша версія",
    latestVersion: "Остання версія",
    downloadUpdate: "Завантажити оновлення?",
    youAreUsingLatestVersion: "Ви використовуєте останню версію",
    goToGithub: "Перейти на Github",
    sendReview: "Надіслати відгук?",
    fillGoogleForm: "Заповнити Google форму",
    errorLoadingSettings: "Помилка завантаження налаштувань",
    errorCopiedToClipboard: "Помилка скопійована в буфер обміну",
    enterNameOfGroupOrTeacher: "Введіть назву групи або ім'я викладача",
    groupChanged: "Групу змінено",
    teacherChanged: "Викладача змінено",
    auditoryChanged: "Аудиторію змінено",
    other: "Інше",
    appVersion: "Версія застосунку",
    loading: "Завантаження...",
    errorLoadingVersion: "Помилка завантаження версії",
    checkUpdates: "Перевірити оновлення",
    sendReviewOrBugReport: "Надіслати відгук/повідомити про помилку",
    general: "Загальне",
    selectLanguage: "Оберіть мову",
    useSystemTheme: "Використовувати системну тему",
    darkTheme: "Темна тема",
    themeColors: "Кольори теми",
    startAndEndDateOfSchedule: "Початкова та кінцева дати розкладу",
    lastScheduleUpdate: "Останнє оновлення розкладу",
    typeOfSchedule: "Тип розкладу",
    happyLearning: "Гарного навчання!",
    happyTeaching: "Гарного викладання!",
    group: "Група",
    teacher: "Викладач",
    selectThemeColors: "Оберіть кольори теми",
    colorTheme: "Колірна тема",
    lectureColor: "Колір лекцій",
    selectLectureColor: "Оберіть колір лекцій",
    apply: "Застосувати",
    practiceColor: "Колір практичних занять",
    selectPracticeColor: "Оберіть колір ПЗ",
    labColor: "Колір лабораторних занять",
    selectLabColor: "Оберіть колір ЛБ",
    consultationColor: "Колір консультацій",
    selectConsultationColor: "Оберіть колір консультацій",
    testColor: "Колір заліків",
    selectTestColor: "Оберіть колір заліків",
    examColor: "Колір екзаменів",
    selectExamColor: "Оберіть колір екзаменів",
    othersColor: "Колір інших занять",
    courseWorkColor: "Колір курсових робіт",
    selectCourseWorkColor: "Оберіть колір курсових робіт",
    selectOthersColor: "Оберіть колір інших занять",
    resetColorSettings: "Скинути налаштування кольорів",
    doYouReallyWantToResetThisSettings: "Ви дійсно хочете скинути ці налаштування?",
    copyDetails: "Скопіювати деталі",
    pairNumber: "Номер пари",
    wheel: "Колесо",
    primary: "Основний",
    shade: "Відтінок",
    selectShade: "Оберіть відтінок",
    floor: "Поверх",
    copy: "Cкопіювати",
    faculty: "Факультет",
    direction: "Напрямок",
    department: "Кафедра",
    building: "Корпус",
    auditoryTypes: "Типи аудиторій",
    hasPower: "Є розетка",
    getAllLessons: "Отримувати всі заняття",
    resetDateSettings: "Скинути налаштування дати",
    scrollToFirstLesson: "Прокручувати до першого заняття",
  };

  static String getSchedule(FlutterLocalization localization) {
    return localization.currentLocale?.languageCode == "uk" ? UA[schedule] : EN[schedule];
  }

  static String getGroups(FlutterLocalization localization) {
    return localization.currentLocale?.languageCode == "uk" ? UA[groups] : EN[groups];
  }

  static String getSettings(FlutterLocalization localization) {
    return localization.currentLocale?.languageCode == "uk" ? UA[settings] : EN[settings];
  }
}
