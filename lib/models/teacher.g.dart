// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
      id: json['Id'] as int,
      fullName: json['FullName'] as String,
      shortName: json['ShortName'] as String,
    );

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
      'Id': instance.id,
      'FullName': instance.fullName,
      'ShortName': instance.shortName,
    };
