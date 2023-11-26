// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      id: json['Id'] as int,
      brief: json['Brief'] as String,
      title: json['Title'] as String,
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'Id': instance.id,
      'Brief': instance.brief,
      'Title': instance.title,
    };
