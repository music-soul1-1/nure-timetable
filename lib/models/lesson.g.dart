// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: (json['id'] as num).toInt(),
      brief: json['brief'] as String,
      title: json['title'] as String,
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num).toInt(),
      type: LessonType.fromJson(json['type'] as Map<String, dynamic>),
      numberPair: (json['numberPair'] as num).toInt(),
      teachers: (json['teachers'] as List<dynamic>)
          .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
          .toList(),
      auditory: Auditory.fromJson(json['auditory'] as Map<String, dynamic>),
      groups: (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'brief': instance.brief,
      'title': instance.title,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'type': instance.type,
      'numberPair': instance.numberPair,
      'teachers': instance.teachers,
      'auditory': instance.auditory,
      'groups': instance.groups,
    };
