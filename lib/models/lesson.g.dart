// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int,
      auditory: json['auditory'] as String,
      type: json['type'] as String,
      groups: (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberPair: json['numberPair'] as int,
      teachers: (json['teachers'] as List<dynamic>)
          .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
          .toList(),
      subject: Subject.fromJson(json['subject'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'auditory': instance.auditory,
      'type': instance.type,
      'groups': instance.groups,
      'numberPair': instance.numberPair,
      'teachers': instance.teachers,
      'subject': instance.subject,
    };
