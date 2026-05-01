import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
abstract class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    @Default('') String description,
    @Default('both') String assignee, // me|partner|both
    DateTime? dueAt,
    @Default('medium') String priority, // low|medium|high
    @Default('home') String category, // home|market|work|personal|other
    @Default('none') String repeat, // none|daily|weekly|monthly
    @Default('none') String reminder, // 10m|1h|1d|none
    @Default('pending') String status, // pending|completed
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
}

