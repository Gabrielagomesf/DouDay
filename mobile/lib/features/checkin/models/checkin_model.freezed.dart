// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckinModel {

 String get id; String get userId; String get mood;// very_good|good|neutral|tired|stressed
 String get comment; String get dayKey;// YYYY-MM-DD
 DateTime? get createdAt;
/// Create a copy of CheckinModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinModelCopyWith<CheckinModel> get copyWith => _$CheckinModelCopyWithImpl<CheckinModel>(this as CheckinModel, _$identity);

  /// Serializes this CheckinModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckinModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mood,comment,dayKey,createdAt);

@override
String toString() {
  return 'CheckinModel(id: $id, userId: $userId, mood: $mood, comment: $comment, dayKey: $dayKey, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CheckinModelCopyWith<$Res>  {
  factory $CheckinModelCopyWith(CheckinModel value, $Res Function(CheckinModel) _then) = _$CheckinModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String mood, String comment, String dayKey, DateTime? createdAt
});




}
/// @nodoc
class _$CheckinModelCopyWithImpl<$Res>
    implements $CheckinModelCopyWith<$Res> {
  _$CheckinModelCopyWithImpl(this._self, this._then);

  final CheckinModel _self;
  final $Res Function(CheckinModel) _then;

/// Create a copy of CheckinModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mood = null,Object? comment = null,Object? dayKey = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckinModel].
extension CheckinModelPatterns on CheckinModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckinModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckinModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckinModel value)  $default,){
final _that = this;
switch (_that) {
case _CheckinModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckinModel value)?  $default,){
final _that = this;
switch (_that) {
case _CheckinModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String mood,  String comment,  String dayKey,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckinModel() when $default != null:
return $default(_that.id,_that.userId,_that.mood,_that.comment,_that.dayKey,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String mood,  String comment,  String dayKey,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _CheckinModel():
return $default(_that.id,_that.userId,_that.mood,_that.comment,_that.dayKey,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String mood,  String comment,  String dayKey,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CheckinModel() when $default != null:
return $default(_that.id,_that.userId,_that.mood,_that.comment,_that.dayKey,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckinModel implements CheckinModel {
  const _CheckinModel({required this.id, required this.userId, required this.mood, this.comment = '', required this.dayKey, this.createdAt});
  factory _CheckinModel.fromJson(Map<String, dynamic> json) => _$CheckinModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String mood;
// very_good|good|neutral|tired|stressed
@override@JsonKey() final  String comment;
@override final  String dayKey;
// YYYY-MM-DD
@override final  DateTime? createdAt;

/// Create a copy of CheckinModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinModelCopyWith<_CheckinModel> get copyWith => __$CheckinModelCopyWithImpl<_CheckinModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckinModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mood,comment,dayKey,createdAt);

@override
String toString() {
  return 'CheckinModel(id: $id, userId: $userId, mood: $mood, comment: $comment, dayKey: $dayKey, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CheckinModelCopyWith<$Res> implements $CheckinModelCopyWith<$Res> {
  factory _$CheckinModelCopyWith(_CheckinModel value, $Res Function(_CheckinModel) _then) = __$CheckinModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String mood, String comment, String dayKey, DateTime? createdAt
});




}
/// @nodoc
class __$CheckinModelCopyWithImpl<$Res>
    implements _$CheckinModelCopyWith<$Res> {
  __$CheckinModelCopyWithImpl(this._self, this._then);

  final _CheckinModel _self;
  final $Res Function(_CheckinModel) _then;

/// Create a copy of CheckinModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mood = null,Object? comment = null,Object? dayKey = null,Object? createdAt = freezed,}) {
  return _then(_CheckinModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
