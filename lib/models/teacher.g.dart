// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
      id: (json['id'] as num).toInt(),
      shortName: json['shortName'] as String,
      fullName: json['fullName'] as String,
      department: Entity.fromJson(json['department'] as Map<String, dynamic>),
      faculty: Entity.fromJson(json['faculty'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
      'id': instance.id,
      'shortName': instance.shortName,
      'fullName': instance.fullName,
      'department': instance.department,
      'faculty': instance.faculty,
    };
