import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_event_model.freezed.dart';
part 'agenda_event_model.g.dart';

@freezed
abstract class AgendaEventModel with _$AgendaEventModel {
  const factory AgendaEventModel({
    required String id,
    required String title,
    @Default('') String description,
    @Default('') String location,
    @Default('both') String participants,
    required DateTime startAt,
    required DateTime endAt,
    @Default('none') String repeat,
    @Default('none') String reminder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AgendaEventModel;

  factory AgendaEventModel.fromJson(Map<String, dynamic> json) => _$AgendaEventModelFromJson(json);
}

