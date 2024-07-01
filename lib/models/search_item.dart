import 'package:nure_timetable/api/timetable.dart';
import 'package:nure_timetable/models/auditory.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/teacher.dart';
import 'package:nure_timetable/types/entity_type.dart';

class SearchItem {
  SearchItem({
    this.group,
    this.teacher,
    this.auditory,
    required this.name,
    required this.type,
  });

  final Group? group;
  final Teacher? teacher;
  final Auditory? auditory;
  final String name;
  final EntityType type;
}

Future<List<SearchItem>> getItems() async {
  final timetable = Timetable();
  final groups = await timetable.getGroups();
  final teachers = await timetable.getTeachers();
  final auditories = await timetable.getAuditories();

  final searchResult = <SearchItem>[];
  
  if (groups != null) {
    searchResult.addAll(groups.map((group) => SearchItem(group: group, name: group.name, type: EntityType.group)));
  }
  
  if (teachers != null) {
    searchResult.addAll(teachers.map((teacher) => SearchItem(teacher: teacher, name: teacher.fullName, type: EntityType.teacher)));
  }
  
  if (auditories != null) {
  searchResult.addAll(auditories.map((auditory) => SearchItem(auditory: auditory, name: auditory.name, type: EntityType.auditory)));
  }

  return searchResult;
}