import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/teacher.dart';

class SearchItem {
  SearchItem({
    this.group,
    this.teacher,
    required this.name,
    required this.type,
  });

  final Group? group;
  final Teacher? teacher;
  final String name;
  final String type;
}

Future<List<SearchItem>> getItems() async {
  final timetable = Timetable();
  final groups = await timetable.getGroups();
  final teachers = await timetable.getTeachers();

  final searchResult = <SearchItem>[];
  searchResult.addAll(groups.map((group) => SearchItem(group: group, name: group.name, type: "group")));
  searchResult.addAll(teachers.map((teacher) => SearchItem(teacher: teacher, name: teacher.fullName, type: "teacher")));

  return searchResult;
}