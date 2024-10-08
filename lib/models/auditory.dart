import 'package:json_annotation/json_annotation.dart';
import 'package:nure_timetable/models/building.dart';
import 'package:nure_timetable/models/auditory_type.dart';

part 'auditory.g.dart';

@JsonSerializable()
class Auditory {
  Auditory({
    required this.id,
    required this.name,
    required this.floor,
    required this.hasPower,
    required this.auditoryTypes,
    required this.building,
  });

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'floor')
  final int floor;
  @JsonKey(name: 'hasPower')
  final bool hasPower;
  @JsonKey(name: 'auditoryTypes')
  final List<AuditoryType> auditoryTypes;
  @JsonKey(name: 'building')
  final Building building;

  factory Auditory.fromJson(Map<String, dynamic> json) => _$AuditoryFromJson(json);
  Map<String, dynamic> toJson() => _$AuditoryToJson(this);

  static Auditory getDefaultAuditory() {
    return Auditory(
      id: 0,
      name: "",
      floor: 0,
      hasPower: false,
      auditoryTypes: [],
      building: Building(id: "", shortName: "", fullName: ""),
    );
  }
}
