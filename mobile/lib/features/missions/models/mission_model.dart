import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_model.freezed.dart';
part 'mission_model.g.dart';

@freezed
abstract class MissionModel with _$MissionModel {
  const factory MissionModel({
    required String id,
    required String scope, // daily|weekly
    required String title,
    @Default(10) int points,
    @Default('pending') String status,
    String? dayKey,
    String? weekKey,
    DateTime? completedAt,
  }) = _MissionModel;

  factory MissionModel.fromJson(Map<String, dynamic> json) => _$MissionModelFromJson(json);
}

