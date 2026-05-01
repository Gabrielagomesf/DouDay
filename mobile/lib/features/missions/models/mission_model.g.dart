// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MissionModel _$MissionModelFromJson(Map<String, dynamic> json) =>
    _MissionModel(
      id: json['id'] as String,
      scope: json['scope'] as String,
      title: json['title'] as String,
      points: (json['points'] as num?)?.toInt() ?? 10,
      status: json['status'] as String? ?? 'pending',
      dayKey: json['dayKey'] as String?,
      weekKey: json['weekKey'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$MissionModelToJson(_MissionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scope': instance.scope,
      'title': instance.title,
      'points': instance.points,
      'status': instance.status,
      'dayKey': instance.dayKey,
      'weekKey': instance.weekKey,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
