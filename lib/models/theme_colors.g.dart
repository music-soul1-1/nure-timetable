// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_colors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeColors _$ThemeColorsFromJson(Map<String, dynamic> json) => ThemeColors(
      lecture: json['lecture'] as String,
      practice: json['practice'] as String,
      laboratory: json['laboratory'] as String,
      consultation: json['consultation'] as String,
      test: json['test'] as String,
      exam: json['exam'] as String,
      courseWork: json['courseWork'] as String,
      other: json['other'] as String,
    );

Map<String, dynamic> _$ThemeColorsToJson(ThemeColors instance) =>
    <String, dynamic>{
      'lecture': instance.lecture,
      'practice': instance.practice,
      'laboratory': instance.laboratory,
      'consultation': instance.consultation,
      'test': instance.test,
      'exam': instance.exam,
      'courseWork': instance.courseWork,
      'other': instance.other,
    };
