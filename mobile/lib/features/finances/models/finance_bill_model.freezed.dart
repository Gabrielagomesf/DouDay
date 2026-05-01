// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_bill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinanceBillModel {

 String get id; String get name; double get amount; String get category; DateTime get dueAt; String get responsible; String get splitType; double? get splitMe; double? get splitPartner; String get status; String get receiptUrl; String get notes; DateTime? get paidAt; String? get paidBy; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of FinanceBillModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceBillModelCopyWith<FinanceBillModel> get copyWith => _$FinanceBillModelCopyWithImpl<FinanceBillModel>(this as FinanceBillModel, _$identity);

  /// Serializes this FinanceBillModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceBillModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.responsible, responsible) || other.responsible == responsible)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&(identical(other.splitMe, splitMe) || other.splitMe == splitMe)&&(identical(other.splitPartner, splitPartner) || other.splitPartner == splitPartner)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paidBy, paidBy) || other.paidBy == paidBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,category,dueAt,responsible,splitType,splitMe,splitPartner,status,receiptUrl,notes,paidAt,paidBy,createdAt,updatedAt);

@override
String toString() {
  return 'FinanceBillModel(id: $id, name: $name, amount: $amount, category: $category, dueAt: $dueAt, responsible: $responsible, splitType: $splitType, splitMe: $splitMe, splitPartner: $splitPartner, status: $status, receiptUrl: $receiptUrl, notes: $notes, paidAt: $paidAt, paidBy: $paidBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FinanceBillModelCopyWith<$Res>  {
  factory $FinanceBillModelCopyWith(FinanceBillModel value, $Res Function(FinanceBillModel) _then) = _$FinanceBillModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, double amount, String category, DateTime dueAt, String responsible, String splitType, double? splitMe, double? splitPartner, String status, String receiptUrl, String notes, DateTime? paidAt, String? paidBy, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$FinanceBillModelCopyWithImpl<$Res>
    implements $FinanceBillModelCopyWith<$Res> {
  _$FinanceBillModelCopyWithImpl(this._self, this._then);

  final FinanceBillModel _self;
  final $Res Function(FinanceBillModel) _then;

/// Create a copy of FinanceBillModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? category = null,Object? dueAt = null,Object? responsible = null,Object? splitType = null,Object? splitMe = freezed,Object? splitPartner = freezed,Object? status = null,Object? receiptUrl = null,Object? notes = null,Object? paidAt = freezed,Object? paidBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,responsible: null == responsible ? _self.responsible : responsible // ignore: cast_nullable_to_non_nullable
as String,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as String,splitMe: freezed == splitMe ? _self.splitMe : splitMe // ignore: cast_nullable_to_non_nullable
as double?,splitPartner: freezed == splitPartner ? _self.splitPartner : splitPartner // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: null == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidBy: freezed == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceBillModel].
extension FinanceBillModelPatterns on FinanceBillModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceBillModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceBillModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceBillModel value)  $default,){
final _that = this;
switch (_that) {
case _FinanceBillModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceBillModel value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceBillModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double amount,  String category,  DateTime dueAt,  String responsible,  String splitType,  double? splitMe,  double? splitPartner,  String status,  String receiptUrl,  String notes,  DateTime? paidAt,  String? paidBy,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceBillModel() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.category,_that.dueAt,_that.responsible,_that.splitType,_that.splitMe,_that.splitPartner,_that.status,_that.receiptUrl,_that.notes,_that.paidAt,_that.paidBy,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double amount,  String category,  DateTime dueAt,  String responsible,  String splitType,  double? splitMe,  double? splitPartner,  String status,  String receiptUrl,  String notes,  DateTime? paidAt,  String? paidBy,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FinanceBillModel():
return $default(_that.id,_that.name,_that.amount,_that.category,_that.dueAt,_that.responsible,_that.splitType,_that.splitMe,_that.splitPartner,_that.status,_that.receiptUrl,_that.notes,_that.paidAt,_that.paidBy,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double amount,  String category,  DateTime dueAt,  String responsible,  String splitType,  double? splitMe,  double? splitPartner,  String status,  String receiptUrl,  String notes,  DateTime? paidAt,  String? paidBy,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FinanceBillModel() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.category,_that.dueAt,_that.responsible,_that.splitType,_that.splitMe,_that.splitPartner,_that.status,_that.receiptUrl,_that.notes,_that.paidAt,_that.paidBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceBillModel implements FinanceBillModel {
  const _FinanceBillModel({required this.id, required this.name, required this.amount, this.category = 'other', required this.dueAt, this.responsible = 'both', this.splitType = 'half', this.splitMe, this.splitPartner, this.status = 'pending', this.receiptUrl = '', this.notes = '', this.paidAt, this.paidBy, this.createdAt, this.updatedAt});
  factory _FinanceBillModel.fromJson(Map<String, dynamic> json) => _$FinanceBillModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  double amount;
@override@JsonKey() final  String category;
@override final  DateTime dueAt;
@override@JsonKey() final  String responsible;
@override@JsonKey() final  String splitType;
@override final  double? splitMe;
@override final  double? splitPartner;
@override@JsonKey() final  String status;
@override@JsonKey() final  String receiptUrl;
@override@JsonKey() final  String notes;
@override final  DateTime? paidAt;
@override final  String? paidBy;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of FinanceBillModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceBillModelCopyWith<_FinanceBillModel> get copyWith => __$FinanceBillModelCopyWithImpl<_FinanceBillModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceBillModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceBillModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.responsible, responsible) || other.responsible == responsible)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&(identical(other.splitMe, splitMe) || other.splitMe == splitMe)&&(identical(other.splitPartner, splitPartner) || other.splitPartner == splitPartner)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paidBy, paidBy) || other.paidBy == paidBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,category,dueAt,responsible,splitType,splitMe,splitPartner,status,receiptUrl,notes,paidAt,paidBy,createdAt,updatedAt);

@override
String toString() {
  return 'FinanceBillModel(id: $id, name: $name, amount: $amount, category: $category, dueAt: $dueAt, responsible: $responsible, splitType: $splitType, splitMe: $splitMe, splitPartner: $splitPartner, status: $status, receiptUrl: $receiptUrl, notes: $notes, paidAt: $paidAt, paidBy: $paidBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FinanceBillModelCopyWith<$Res> implements $FinanceBillModelCopyWith<$Res> {
  factory _$FinanceBillModelCopyWith(_FinanceBillModel value, $Res Function(_FinanceBillModel) _then) = __$FinanceBillModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double amount, String category, DateTime dueAt, String responsible, String splitType, double? splitMe, double? splitPartner, String status, String receiptUrl, String notes, DateTime? paidAt, String? paidBy, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$FinanceBillModelCopyWithImpl<$Res>
    implements _$FinanceBillModelCopyWith<$Res> {
  __$FinanceBillModelCopyWithImpl(this._self, this._then);

  final _FinanceBillModel _self;
  final $Res Function(_FinanceBillModel) _then;

/// Create a copy of FinanceBillModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? category = null,Object? dueAt = null,Object? responsible = null,Object? splitType = null,Object? splitMe = freezed,Object? splitPartner = freezed,Object? status = null,Object? receiptUrl = null,Object? notes = null,Object? paidAt = freezed,Object? paidBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_FinanceBillModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,responsible: null == responsible ? _self.responsible : responsible // ignore: cast_nullable_to_non_nullable
as String,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as String,splitMe: freezed == splitMe ? _self.splitMe : splitMe // ignore: cast_nullable_to_non_nullable
as double?,splitPartner: freezed == splitPartner ? _self.splitPartner : splitPartner // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: null == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidBy: freezed == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
