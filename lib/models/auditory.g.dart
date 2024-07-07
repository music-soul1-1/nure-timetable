// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditory _$AuditoryFromJson(Map<String, dynamic> json) => Auditory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      floor: (json['floor'] as num).toInt(),
      hasPower: json['hasPower'] as bool,
      auditoryTypes: (json['auditoryTypes'] as List<dynamic>)
          .map((e) => AuditoryType.fromJson(e as Map<String, dynamic>))
          .toList(),
      building: Building.fromJson(json['building'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuditoryToJson(Auditory instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'floor': instance.floor,
      'hasPower': instance.hasPower,
      'auditoryTypes': instance.auditoryTypes,
      'building': instance.building,
    };
