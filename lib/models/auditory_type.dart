import 'package:json_annotation/json_annotation.dart';

part 'auditory_type.g.dart';

@JsonSerializable()
class AuditoryType {
  AuditoryType({
    required this.id,
    required this.name,
  });

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;

  factory AuditoryType.fromJson(Map<String, dynamic> json) => _$AuditoryTypeFromJson(json);
  Map<String, dynamic> toJson() => _$AuditoryTypeToJson(this);
}