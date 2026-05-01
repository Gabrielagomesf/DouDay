// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_bill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinanceBillModel _$FinanceBillModelFromJson(Map<String, dynamic> json) =>
    _FinanceBillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String? ?? 'other',
      dueAt: DateTime.parse(json['dueAt'] as String),
      responsible: json['responsible'] as String? ?? 'both',
      splitType: json['splitType'] as String? ?? 'half',
      splitMe: (json['splitMe'] as num?)?.toDouble(),
      splitPartner: (json['splitPartner'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'pending',
      receiptUrl: json['receiptUrl'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paidBy: json['paidBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FinanceBillModelToJson(_FinanceBillModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'category': instance.category,
      'dueAt': instance.dueAt.toIso8601String(),
      'responsible': instance.responsible,
      'splitType': instance.splitType,
      'splitMe': instance.splitMe,
      'splitPartner': instance.splitPartner,
      'status': instance.status,
      'receiptUrl': instance.receiptUrl,
      'notes': instance.notes,
      'paidAt': instance.paidAt?.toIso8601String(),
      'paidBy': instance.paidBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
