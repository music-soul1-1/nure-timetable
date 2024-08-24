import 'package:json_annotation/json_annotation.dart';
import 'package:nure_timetable/models/auditory.dart';
import 'package:nure_timetable/models/group.dart';
import 'package:nure_timetable/models/teacher.dart';

part 'combined_entity.g.dart';

@JsonSerializable()
class CombinedEntity {
  CombinedEntity({
    required this.groups,
    required this.teachers,
    required this.auditories,
  });

  factory CombinedEntity.fromJson(Map<String, dynamic> json) => _$CombinedEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CombinedEntityToJson(this);

  @JsonKey(name: 'groups')
  final List<Group> groups;
  @JsonKey(name: 'teachers')
  final List<Teacher> teachers;
  @JsonKey(name: 'auditories')
  final List<Auditory> auditories;
}
