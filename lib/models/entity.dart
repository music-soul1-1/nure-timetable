import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable()
/// Entity with id, short name and full name.
/// 
/// Used as `Direction`, `Department`, `Faculty`, etc.
class Entity {
  Entity({
    required this.id,
    required this.shortName,
    required this.fullName,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'shortName')
  final String shortName;
  @JsonKey(name: 'fullName')
  final String fullName;
}