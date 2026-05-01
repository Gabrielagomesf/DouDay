import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_bill_model.freezed.dart';
part 'finance_bill_model.g.dart';

@freezed
abstract class FinanceBillModel with _$FinanceBillModel {
  const factory FinanceBillModel({
    required String id,
    required String name,
    required double amount,
    @Default('other') String category,
    required DateTime dueAt,
    @Default('both') String responsible,
    @Default('half') String splitType,
    double? splitMe,
    double? splitPartner,
    @Default('pending') String status,
    @Default('') String receiptUrl,
    @Default('') String notes,
    DateTime? paidAt,
    String? paidBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FinanceBillModel;

  factory FinanceBillModel.fromJson(Map<String, dynamic> json) => _$FinanceBillModelFromJson(json);
}

