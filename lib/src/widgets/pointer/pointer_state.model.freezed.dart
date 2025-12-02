// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pointer_state.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GazePointerState {

// type: passive (static circle), active (circle with animation on fixation)
 GazePointerType get type;// ignore gesture on pointer
 bool get ignorePointer;// ignore gesture on pointer
 double? get absoluteOpacityValue;// can leave the view bounds, used for windows on desktop platforms that are partially interactive
 bool get canLeaveBounds;// action on pointer
 GazePointerAction get action;  Function(Offset)? get onAction;
/// Create a copy of GazePointerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GazePointerStateCopyWith<GazePointerState> get copyWith => _$GazePointerStateCopyWithImpl<GazePointerState>(this as GazePointerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GazePointerState&&(identical(other.type, type) || other.type == type)&&(identical(other.ignorePointer, ignorePointer) || other.ignorePointer == ignorePointer)&&(identical(other.absoluteOpacityValue, absoluteOpacityValue) || other.absoluteOpacityValue == absoluteOpacityValue)&&(identical(other.canLeaveBounds, canLeaveBounds) || other.canLeaveBounds == canLeaveBounds)&&(identical(other.action, action) || other.action == action)&&(identical(other.onAction, onAction) || other.onAction == onAction));
}


@override
int get hashCode => Object.hash(runtimeType,type,ignorePointer,absoluteOpacityValue,canLeaveBounds,action,onAction);

@override
String toString() {
  return 'GazePointerState(type: $type, ignorePointer: $ignorePointer, absoluteOpacityValue: $absoluteOpacityValue, canLeaveBounds: $canLeaveBounds, action: $action, onAction: $onAction)';
}


}

/// @nodoc
abstract mixin class $GazePointerStateCopyWith<$Res>  {
  factory $GazePointerStateCopyWith(GazePointerState value, $Res Function(GazePointerState) _then) = _$GazePointerStateCopyWithImpl;
@useResult
$Res call({
 GazePointerType type, bool ignorePointer, double? absoluteOpacityValue, bool canLeaveBounds, GazePointerAction action,  Function(Offset)? onAction
});




}
/// @nodoc
class _$GazePointerStateCopyWithImpl<$Res>
    implements $GazePointerStateCopyWith<$Res> {
  _$GazePointerStateCopyWithImpl(this._self, this._then);

  final GazePointerState _self;
  final $Res Function(GazePointerState) _then;

/// Create a copy of GazePointerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? ignorePointer = null,Object? absoluteOpacityValue = freezed,Object? canLeaveBounds = null,Object? action = null,Object? onAction = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GazePointerType,ignorePointer: null == ignorePointer ? _self.ignorePointer : ignorePointer // ignore: cast_nullable_to_non_nullable
as bool,absoluteOpacityValue: freezed == absoluteOpacityValue ? _self.absoluteOpacityValue : absoluteOpacityValue // ignore: cast_nullable_to_non_nullable
as double?,canLeaveBounds: null == canLeaveBounds ? _self.canLeaveBounds : canLeaveBounds // ignore: cast_nullable_to_non_nullable
as bool,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as GazePointerAction,onAction: freezed == onAction ? _self.onAction : onAction // ignore: cast_nullable_to_non_nullable
as  Function(Offset)?,
  ));
}

}


/// Adds pattern-matching-related methods to [GazePointerState].
extension GazePointerStatePatterns on GazePointerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GazePointerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GazePointerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GazePointerState value)  $default,){
final _that = this;
switch (_that) {
case _GazePointerState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GazePointerState value)?  $default,){
final _that = this;
switch (_that) {
case _GazePointerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GazePointerType type,  bool ignorePointer,  double? absoluteOpacityValue,  bool canLeaveBounds,  GazePointerAction action,   Function(Offset)? onAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GazePointerState() when $default != null:
return $default(_that.type,_that.ignorePointer,_that.absoluteOpacityValue,_that.canLeaveBounds,_that.action,_that.onAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GazePointerType type,  bool ignorePointer,  double? absoluteOpacityValue,  bool canLeaveBounds,  GazePointerAction action,   Function(Offset)? onAction)  $default,) {final _that = this;
switch (_that) {
case _GazePointerState():
return $default(_that.type,_that.ignorePointer,_that.absoluteOpacityValue,_that.canLeaveBounds,_that.action,_that.onAction);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GazePointerType type,  bool ignorePointer,  double? absoluteOpacityValue,  bool canLeaveBounds,  GazePointerAction action,   Function(Offset)? onAction)?  $default,) {final _that = this;
switch (_that) {
case _GazePointerState() when $default != null:
return $default(_that.type,_that.ignorePointer,_that.absoluteOpacityValue,_that.canLeaveBounds,_that.action,_that.onAction);case _:
  return null;

}
}

}

/// @nodoc


class _GazePointerState extends GazePointerState {
   _GazePointerState({this.type = GazePointerType.passive, this.ignorePointer = false, this.absoluteOpacityValue = null, this.canLeaveBounds = false, this.action = GazePointerAction.click, this.onAction}): super._();
  

// type: passive (static circle), active (circle with animation on fixation)
@override@JsonKey() final  GazePointerType type;
// ignore gesture on pointer
@override@JsonKey() final  bool ignorePointer;
// ignore gesture on pointer
@override@JsonKey() final  double? absoluteOpacityValue;
// can leave the view bounds, used for windows on desktop platforms that are partially interactive
@override@JsonKey() final  bool canLeaveBounds;
// action on pointer
@override@JsonKey() final  GazePointerAction action;
@override final   Function(Offset)? onAction;

/// Create a copy of GazePointerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GazePointerStateCopyWith<_GazePointerState> get copyWith => __$GazePointerStateCopyWithImpl<_GazePointerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GazePointerState&&(identical(other.type, type) || other.type == type)&&(identical(other.ignorePointer, ignorePointer) || other.ignorePointer == ignorePointer)&&(identical(other.absoluteOpacityValue, absoluteOpacityValue) || other.absoluteOpacityValue == absoluteOpacityValue)&&(identical(other.canLeaveBounds, canLeaveBounds) || other.canLeaveBounds == canLeaveBounds)&&(identical(other.action, action) || other.action == action)&&(identical(other.onAction, onAction) || other.onAction == onAction));
}


@override
int get hashCode => Object.hash(runtimeType,type,ignorePointer,absoluteOpacityValue,canLeaveBounds,action,onAction);

@override
String toString() {
  return 'GazePointerState(type: $type, ignorePointer: $ignorePointer, absoluteOpacityValue: $absoluteOpacityValue, canLeaveBounds: $canLeaveBounds, action: $action, onAction: $onAction)';
}


}

/// @nodoc
abstract mixin class _$GazePointerStateCopyWith<$Res> implements $GazePointerStateCopyWith<$Res> {
  factory _$GazePointerStateCopyWith(_GazePointerState value, $Res Function(_GazePointerState) _then) = __$GazePointerStateCopyWithImpl;
@override @useResult
$Res call({
 GazePointerType type, bool ignorePointer, double? absoluteOpacityValue, bool canLeaveBounds, GazePointerAction action,  Function(Offset)? onAction
});




}
/// @nodoc
class __$GazePointerStateCopyWithImpl<$Res>
    implements _$GazePointerStateCopyWith<$Res> {
  __$GazePointerStateCopyWithImpl(this._self, this._then);

  final _GazePointerState _self;
  final $Res Function(_GazePointerState) _then;

/// Create a copy of GazePointerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? ignorePointer = null,Object? absoluteOpacityValue = freezed,Object? canLeaveBounds = null,Object? action = null,Object? onAction = freezed,}) {
  return _then(_GazePointerState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GazePointerType,ignorePointer: null == ignorePointer ? _self.ignorePointer : ignorePointer // ignore: cast_nullable_to_non_nullable
as bool,absoluteOpacityValue: freezed == absoluteOpacityValue ? _self.absoluteOpacityValue : absoluteOpacityValue // ignore: cast_nullable_to_non_nullable
as double?,canLeaveBounds: null == canLeaveBounds ? _self.canLeaveBounds : canLeaveBounds // ignore: cast_nullable_to_non_nullable
as bool,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as GazePointerAction,onAction: freezed == onAction ? _self.onAction : onAction // ignore: cast_nullable_to_non_nullable
as  Function(Offset)?,
  ));
}


}

// dart format on
