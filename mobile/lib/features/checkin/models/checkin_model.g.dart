// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckinModel _$CheckinModelFromJson(Map<String, dynamic> json) =>
    _CheckinModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      mood: json['mood'] as String,
      comment: json['comment'] as String? ?? '',
      dayKey: json['dayKey'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CheckinModelToJson(_CheckinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mood': instance.mood,
      'comment': instance.comment,
      'dayKey': instance.dayKey,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
