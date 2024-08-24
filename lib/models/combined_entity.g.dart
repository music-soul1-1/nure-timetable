// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combined_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombinedEntity _$CombinedEntityFromJson(Map<String, dynamic> json) =>
    CombinedEntity(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      teachers: (json['teachers'] as List<dynamic>)
          .map((e) => Teacher.fromJson(e as Map<String, dynamic>))
          .toList(),
      auditories: (json['auditories'] as List<dynamic>)
          .map((e) => Auditory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CombinedEntityToJson(CombinedEntity instance) =>
    <String, dynamic>{
      'groups': instance.groups,
      'teachers': instance.teachers,
      'auditories': instance.auditories,
    };
