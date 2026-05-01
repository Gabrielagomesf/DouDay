// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => _TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  assignee: json['assignee'] as String? ?? 'both',
  dueAt: json['dueAt'] == null ? null : DateTime.parse(json['dueAt'] as String),
  priority: json['priority'] as String? ?? 'medium',
  category: json['category'] as String? ?? 'home',
  repeat: json['repeat'] as String? ?? 'none',
  reminder: json['reminder'] as String? ?? 'none',
  status: json['status'] as String? ?? 'pending',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$TaskModelToJson(_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'assignee': instance.assignee,
      'dueAt': instance.dueAt?.toIso8601String(),
      'priority': instance.priority,
      'category': instance.category,
      'repeat': instance.repeat,
      'reminder': instance.reminder,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
