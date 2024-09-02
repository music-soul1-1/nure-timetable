import 'package:json_annotation/json_annotation.dart';

part 'theme_colors.g.dart'; // This part file will be generated by json_serializable

/// Class for storing theme colors.
@JsonSerializable()
class ThemeColors {
  ThemeColors({
    required this.lecture,
    required this.practice,
    required this.laboratory,
    required this.consultation,
    required this.test,
    required this.exam,
    required this.courseWork,
    required this.other,
  });

  factory ThemeColors.fromJson(Map<String, dynamic> json) => _$ThemeColorsFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeColorsToJson(this);

  @JsonKey(name: 'lecture')
  late String lecture;

  @JsonKey(name: 'practice')
  late String practice;

  @JsonKey(name: 'laboratory')
  late String laboratory;

  @JsonKey(name: 'consultation')
  late String consultation;

  @JsonKey(name: 'test')
  late String test;

  @JsonKey(name: 'exam')
  late String exam;

  @JsonKey(name: 'courseWork')
  late String courseWork;

  @JsonKey(name: 'other')
  late String other;

  static ThemeColors getDefaultColors() {
    return ThemeColors(
      lecture: "0xFFAD8827",
      practice: "0xFF1C8834",
      laboratory: "0xFF5A2194",
      consultation: "0xFF1E7F85",
      test: "0xFF9A1A95",
      exam: "0xFF8E1D1D",
      courseWork: "0xFF50B02E",
      other: "0xFFAD12E6",
    );
  }
}
