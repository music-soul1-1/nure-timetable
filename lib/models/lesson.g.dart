// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: json['id'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      auditory: json['auditory'] as String,
      type: json['type'] as String,
      updatedAt: json['updatedAt'] as String,
      groups: (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberPair: json['number_pair'] as int,
      teachers: (json['teachers'] as List<dynamic>)
          .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
          .toList(),
      subject: Subject.fromJson(json['subject'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'auditory': instance.auditory,
      'type': instance.type,
      'updatedAt': instance.updatedAt,
      'groups': instance.groups,
      'number_pair': instance.numberPair,
      'teachers': instance.teachers,
      'subject': instance.subject,
    };
