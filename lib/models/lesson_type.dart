import 'package:json_annotation/json_annotation.dart';

part 'lesson_type.g.dart';

@JsonSerializable()
class LessonType {
  LessonType({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.idBase,
    required this.type,
  });

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'shortName')
  final String shortName;
  @JsonKey(name: 'fullName')
  final String fullName;
  @JsonKey(name: 'idBase')
  final int idBase;
  @JsonKey(name: 'type')
  final String type;

  factory LessonType.fromJson(Map<String, dynamic> json) => _$LessonTypeFromJson(json);
  Map<String, dynamic> toJson() => _$LessonTypeToJson(this);
}