// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgendaEventModel {

 String get id; String get title; String get description; String get location; String get participants; DateTime get startAt; DateTime get endAt; String get repeat; String get reminder; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaEventModelCopyWith<AgendaEventModel> get copyWith => _$AgendaEventModelCopyWithImpl<AgendaEventModel>(this as AgendaEventModel, _$identity);

  /// Serializes this AgendaEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.participants, participants) || other.participants == participants)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,location,participants,startAt,endAt,repeat,reminder,createdAt,updatedAt);

@override
String toString() {
  return 'AgendaEventModel(id: $id, title: $title, description: $description, location: $location, participants: $participants, startAt: $startAt, endAt: $endAt, repeat: $repeat, reminder: $reminder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AgendaEventModelCopyWith<$Res>  {
  factory $AgendaEventModelCopyWith(AgendaEventModel value, $Res Function(AgendaEventModel) _then) = _$AgendaEventModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String location, String participants, DateTime startAt, DateTime endAt, String repeat, String reminder, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$AgendaEventModelCopyWithImpl<$Res>
    implements $AgendaEventModelCopyWith<$Res> {
  _$AgendaEventModelCopyWithImpl(this._self, this._then);

  final AgendaEventModel _self;
  final $Res Function(AgendaEventModel) _then;

/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? location = null,Object? participants = null,Object? startAt = null,Object? endAt = null,Object? repeat = null,Object? reminder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as String,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgendaEventModel].
extension AgendaEventModelPatterns on AgendaEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaEventModel value)  $default,){
final _that = this;
switch (_that) {
case _AgendaEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String location,  String participants,  DateTime startAt,  DateTime endAt,  String repeat,  String reminder,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.location,_that.participants,_that.startAt,_that.endAt,_that.repeat,_that.reminder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String location,  String participants,  DateTime startAt,  DateTime endAt,  String repeat,  String reminder,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AgendaEventModel():
return $default(_that.id,_that.title,_that.description,_that.location,_that.participants,_that.startAt,_that.endAt,_that.repeat,_that.reminder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String location,  String participants,  DateTime startAt,  DateTime endAt,  String repeat,  String reminder,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AgendaEventModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.location,_that.participants,_that.startAt,_that.endAt,_that.repeat,_that.reminder,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgendaEventModel implements AgendaEventModel {
  const _AgendaEventModel({required this.id, required this.title, this.description = '', this.location = '', this.participants = 'both', required this.startAt, required this.endAt, this.repeat = 'none', this.reminder = 'none', this.createdAt, this.updatedAt});
  factory _AgendaEventModel.fromJson(Map<String, dynamic> json) => _$AgendaEventModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String location;
@override@JsonKey() final  String participants;
@override final  DateTime startAt;
@override final  DateTime endAt;
@override@JsonKey() final  String repeat;
@override@JsonKey() final  String reminder;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaEventModelCopyWith<_AgendaEventModel> get copyWith => __$AgendaEventModelCopyWithImpl<_AgendaEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgendaEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.participants, participants) || other.participants == participants)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,location,participants,startAt,endAt,repeat,reminder,createdAt,updatedAt);

@override
String toString() {
  return 'AgendaEventModel(id: $id, title: $title, description: $description, location: $location, participants: $participants, startAt: $startAt, endAt: $endAt, repeat: $repeat, reminder: $reminder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AgendaEventModelCopyWith<$Res> implements $AgendaEventModelCopyWith<$Res> {
  factory _$AgendaEventModelCopyWith(_AgendaEventModel value, $Res Function(_AgendaEventModel) _then) = __$AgendaEventModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String location, String participants, DateTime startAt, DateTime endAt, String repeat, String reminder, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$AgendaEventModelCopyWithImpl<$Res>
    implements _$AgendaEventModelCopyWith<$Res> {
  __$AgendaEventModelCopyWithImpl(this._self, this._then);

  final _AgendaEventModel _self;
  final $Res Function(_AgendaEventModel) _then;

/// Create a copy of AgendaEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? location = null,Object? participants = null,Object? startAt = null,Object? endAt = null,Object? repeat = null,Object? reminder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AgendaEventModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as String,reminder: null == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
