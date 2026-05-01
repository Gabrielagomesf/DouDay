import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkin_model.freezed.dart';
part 'checkin_model.g.dart';

@freezed
abstract class CheckinModel with _$CheckinModel {
  const factory CheckinModel({
    required String id,
    required String userId,
    required String mood, // very_good|good|neutral|tired|stressed
    @Default('') String comment,
    required String dayKey, // YYYY-MM-DD
    DateTime? createdAt,
  }) = _CheckinModel;

  factory CheckinModel.fromJson(Map<String, dynamic> json) => _$CheckinModelFromJson(json);
}

