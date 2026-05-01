// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgendaEventModel _$AgendaEventModelFromJson(Map<String, dynamic> json) =>
    _AgendaEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      participants: json['participants'] as String? ?? 'both',
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      repeat: json['repeat'] as String? ?? 'none',
      reminder: json['reminder'] as String? ?? 'none',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AgendaEventModelToJson(_AgendaEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'participants': instance.participants,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'repeat': instance.repeat,
      'reminder': instance.reminder,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
