import 'package:json_annotation/json_annotation.dart';
import 'package:nure_timetable/models/entity.dart';

part 'group.g.dart'; // This part file will be generated by json_serializable

/// Class for storing group data.
@JsonSerializable()
class Group {
  Group({
    required this.id,
    required this.name,
    required this.direction,
    required this.faculty,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'direction')
  final Entity direction;
  @JsonKey(name: 'faculty')
  final Entity faculty;

  static Group getDefaultGroup() {
    return Group(
      id: 0,
      name: "",
      direction: Entity(id: 0, shortName: "", fullName: ""),
      faculty: Entity(id: 0, shortName: "", fullName: ""),
    );
  }
}
