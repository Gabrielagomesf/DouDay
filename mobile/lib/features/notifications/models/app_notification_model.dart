import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification_model.freezed.dart';
part 'app_notification_model.g.dart';

@freezed
abstract class AppNotificationModel with _$AppNotificationModel {
  const factory AppNotificationModel({
    required String id,
    @Default('system') String type,
    required String title,
    @Default('') String body,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _AppNotificationModel;

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) => _$AppNotificationModelFromJson(json);
}

