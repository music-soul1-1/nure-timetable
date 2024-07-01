// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonType _$LessonTypeFromJson(Map<String, dynamic> json) => LessonType(
      id: (json['id'] as num).toInt(),
      shortName: json['shortName'] as String,
      fullName: json['fullName'] as String,
      idBase: (json['idBase'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$LessonTypeToJson(LessonType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortName': instance.shortName,
      'fullName': instance.fullName,
      'idBase': instance.idBase,
      'type': instance.type,
    };
