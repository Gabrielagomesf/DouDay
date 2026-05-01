// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotificationModel _$AppNotificationModelFromJson(
  Map<String, dynamic> json,
) => _AppNotificationModel(
  id: json['id'] as String,
  type: json['type'] as String? ?? 'system',
  title: json['title'] as String,
  body: json['body'] as String? ?? '',
  isRead: json['isRead'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppNotificationModelToJson(
  _AppNotificationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'body': instance.body,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt?.toIso8601String(),
};
