import 'package:json_annotation/json_annotation.dart';

part 'building.g.dart';

@JsonSerializable()
class Building {
  Building({
    required this.id,
    required this.shortName,
    required this.fullName,
  });

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'shortName')
  final String shortName;
  @JsonKey(name: 'fullName')
  final String fullName;

  factory Building.fromJson(Map<String, dynamic> json) => _$BuildingFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingToJson(this);
}