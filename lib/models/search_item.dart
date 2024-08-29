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

  /// Gets all university entities (groups, teachers, auditories) and returns them as a list of [SearchItem].
  static Future<List<SearchItem>> getItems() async {
    final timetable = Timetable();
    final combinedEntity = await timetable.getCombinedEntity();

    if (combinedEntity == null) {
      return [];
    }

    final searchResult = <SearchItem>[];

    searchResult.addAll(combinedEntity.groups.map((group) => SearchItem(group: group, name: group.name, type: EntityType.group)));
    searchResult.addAll(combinedEntity.teachers.map((teacher) => SearchItem(teacher: teacher, name: teacher.fullName, type: EntityType.teacher)));
    searchResult.addAll(combinedEntity.auditories.map((auditory) => SearchItem(auditory: auditory, name: auditory.name, type: EntityType.auditory)));

    return searchResult;
  }
}
