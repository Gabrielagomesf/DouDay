// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionModel {

 String get id; String get scope;// daily|weekly
 String get title; int get points; String get status; String? get dayKey; String? get weekKey; DateTime? get completedAt;
/// Create a copy of MissionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionModelCopyWith<MissionModel> get copyWith => _$MissionModelCopyWithImpl<MissionModel>(this as MissionModel, _$identity);

  /// Serializes this MissionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.title, title) || other.title == title)&&(identical(other.points, points) || other.points == points)&&(identical(other.status, status) || other.status == status)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.weekKey, weekKey) || other.weekKey == weekKey)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scope,title,points,status,dayKey,weekKey,completedAt);

@override
String toString() {
  return 'MissionModel(id: $id, scope: $scope, title: $title, points: $points, status: $status, dayKey: $dayKey, weekKey: $weekKey, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $MissionModelCopyWith<$Res>  {
  factory $MissionModelCopyWith(MissionModel value, $Res Function(MissionModel) _then) = _$MissionModelCopyWithImpl;
@useResult
$Res call({
 String id, String scope, String title, int points, String status, String? dayKey, String? weekKey, DateTime? completedAt
});




}
/// @nodoc
class _$MissionModelCopyWithImpl<$Res>
    implements $MissionModelCopyWith<$Res> {
  _$MissionModelCopyWithImpl(this._self, this._then);

  final MissionModel _self;
  final $Res Function(MissionModel) _then;

/// Create a copy of MissionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scope = null,Object? title = null,Object? points = null,Object? status = null,Object? dayKey = freezed,Object? weekKey = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,dayKey: freezed == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String?,weekKey: freezed == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionModel].
extension MissionModelPatterns on MissionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionModel value)  $default,){
final _that = this;
switch (_that) {
case _MissionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionModel value)?  $default,){
final _that = this;
switch (_that) {
case _MissionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scope,  String title,  int points,  String status,  String? dayKey,  String? weekKey,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionModel() when $default != null:
return $default(_that.id,_that.scope,_that.title,_that.points,_that.status,_that.dayKey,_that.weekKey,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scope,  String title,  int points,  String status,  String? dayKey,  String? weekKey,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _MissionModel():
return $default(_that.id,_that.scope,_that.title,_that.points,_that.status,_that.dayKey,_that.weekKey,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scope,  String title,  int points,  String status,  String? dayKey,  String? weekKey,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _MissionModel() when $default != null:
return $default(_that.id,_that.scope,_that.title,_that.points,_that.status,_that.dayKey,_that.weekKey,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MissionModel implements MissionModel {
  const _MissionModel({required this.id, required this.scope, required this.title, this.points = 10, this.status = 'pending', this.dayKey, this.weekKey, this.completedAt});
  factory _MissionModel.fromJson(Map<String, dynamic> json) => _$MissionModelFromJson(json);

@override final  String id;
@override final  String scope;
// daily|weekly
@override final  String title;
@override@JsonKey() final  int points;
@override@JsonKey() final  String status;
@override final  String? dayKey;
@override final  String? weekKey;
@override final  DateTime? completedAt;

/// Create a copy of MissionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionModelCopyWith<_MissionModel> get copyWith => __$MissionModelCopyWithImpl<_MissionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.title, title) || other.title == title)&&(identical(other.points, points) || other.points == points)&&(identical(other.status, status) || other.status == status)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.weekKey, weekKey) || other.weekKey == weekKey)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scope,title,points,status,dayKey,weekKey,completedAt);

@override
String toString() {
  return 'MissionModel(id: $id, scope: $scope, title: $title, points: $points, status: $status, dayKey: $dayKey, weekKey: $weekKey, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$MissionModelCopyWith<$Res> implements $MissionModelCopyWith<$Res> {
  factory _$MissionModelCopyWith(_MissionModel value, $Res Function(_MissionModel) _then) = __$MissionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String scope, String title, int points, String status, String? dayKey, String? weekKey, DateTime? completedAt
});




}
/// @nodoc
class __$MissionModelCopyWithImpl<$Res>
    implements _$MissionModelCopyWith<$Res> {
  __$MissionModelCopyWithImpl(this._self, this._then);

  final _MissionModel _self;
  final $Res Function(_MissionModel) _then;

/// Create a copy of MissionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scope = null,Object? title = null,Object? points = null,Object? status = null,Object? dayKey = freezed,Object? weekKey = freezed,Object? completedAt = freezed,}) {
  return _then(_MissionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,dayKey: freezed == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String?,weekKey: freezed == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
