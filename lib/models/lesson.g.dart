// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: json['Id'] as int,
      startTime: json['StartTime'] as int,
      endTime: json['EndTime'] as int,
      auditory: json['Auditory'] as String,
      type: json['Type'] as String,
      groups: (json['Groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberPair: json['NumberPair'] as int,
      teachers: (json['Teachers'] as List<dynamic>)
          .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
          .toList(),
      subject: Subject.fromJson(json['Subject'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'Id': instance.id,
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'Auditory': instance.auditory,
      'Type': instance.type,
      'Groups': instance.groups,
      'NumberPair': instance.numberPair,
      'Teachers': instance.teachers,
      'Subject': instance.subject,
    };
