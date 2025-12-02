// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'switch_button_state.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GazeSwitchButtonState {

 bool get toggled; bool get gazeInteractive;
/// Create a copy of GazeSwitchButtonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GazeSwitchButtonStateCopyWith<GazeSwitchButtonState> get copyWith => _$GazeSwitchButtonStateCopyWithImpl<GazeSwitchButtonState>(this as GazeSwitchButtonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GazeSwitchButtonState&&(identical(other.toggled, toggled) || other.toggled == toggled)&&(identical(other.gazeInteractive, gazeInteractive) || other.gazeInteractive == gazeInteractive));
}


@override
int get hashCode => Object.hash(runtimeType,toggled,gazeInteractive);

@override
String toString() {
  return 'GazeSwitchButtonState(toggled: $toggled, gazeInteractive: $gazeInteractive)';
}


}

/// @nodoc
abstract mixin class $GazeSwitchButtonStateCopyWith<$Res>  {
  factory $GazeSwitchButtonStateCopyWith(GazeSwitchButtonState value, $Res Function(GazeSwitchButtonState) _then) = _$GazeSwitchButtonStateCopyWithImpl;
@useResult
$Res call({
 bool toggled, bool gazeInteractive
});




}
/// @nodoc
class _$GazeSwitchButtonStateCopyWithImpl<$Res>
    implements $GazeSwitchButtonStateCopyWith<$Res> {
  _$GazeSwitchButtonStateCopyWithImpl(this._self, this._then);

  final GazeSwitchButtonState _self;
  final $Res Function(GazeSwitchButtonState) _then;

/// Create a copy of GazeSwitchButtonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toggled = null,Object? gazeInteractive = null,}) {
  return _then(_self.copyWith(
toggled: null == toggled ? _self.toggled : toggled // ignore: cast_nullable_to_non_nullable
as bool,gazeInteractive: null == gazeInteractive ? _self.gazeInteractive : gazeInteractive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GazeSwitchButtonState].
extension GazeSwitchButtonStatePatterns on GazeSwitchButtonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GazeSwitchButtonState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GazeSwitchButtonState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GazeSwitchButtonState value)  $default,){
final _that = this;
switch (_that) {
case _GazeSwitchButtonState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GazeSwitchButtonState value)?  $default,){
final _that = this;
switch (_that) {
case _GazeSwitchButtonState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool toggled,  bool gazeInteractive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GazeSwitchButtonState() when $default != null:
return $default(_that.toggled,_that.gazeInteractive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool toggled,  bool gazeInteractive)  $default,) {final _that = this;
switch (_that) {
case _GazeSwitchButtonState():
return $default(_that.toggled,_that.gazeInteractive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool toggled,  bool gazeInteractive)?  $default,) {final _that = this;
switch (_that) {
case _GazeSwitchButtonState() when $default != null:
return $default(_that.toggled,_that.gazeInteractive);case _:
  return null;

}
}

}

/// @nodoc


class _GazeSwitchButtonState extends GazeSwitchButtonState {
   _GazeSwitchButtonState({required this.toggled, this.gazeInteractive = false}): super._();
  

@override final  bool toggled;
@override@JsonKey() final  bool gazeInteractive;

/// Create a copy of GazeSwitchButtonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GazeSwitchButtonStateCopyWith<_GazeSwitchButtonState> get copyWith => __$GazeSwitchButtonStateCopyWithImpl<_GazeSwitchButtonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GazeSwitchButtonState&&(identical(other.toggled, toggled) || other.toggled == toggled)&&(identical(other.gazeInteractive, gazeInteractive) || other.gazeInteractive == gazeInteractive));
}


@override
int get hashCode => Object.hash(runtimeType,toggled,gazeInteractive);

@override
String toString() {
  return 'GazeSwitchButtonState(toggled: $toggled, gazeInteractive: $gazeInteractive)';
}


}

/// @nodoc
abstract mixin class _$GazeSwitchButtonStateCopyWith<$Res> implements $GazeSwitchButtonStateCopyWith<$Res> {
  factory _$GazeSwitchButtonStateCopyWith(_GazeSwitchButtonState value, $Res Function(_GazeSwitchButtonState) _then) = __$GazeSwitchButtonStateCopyWithImpl;
@override @useResult
$Res call({
 bool toggled, bool gazeInteractive
});




}
/// @nodoc
class __$GazeSwitchButtonStateCopyWithImpl<$Res>
    implements _$GazeSwitchButtonStateCopyWith<$Res> {
  __$GazeSwitchButtonStateCopyWithImpl(this._self, this._then);

  final _GazeSwitchButtonState _self;
  final $Res Function(_GazeSwitchButtonState) _then;

/// Create a copy of GazeSwitchButtonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toggled = null,Object? gazeInteractive = null,}) {
  return _then(_GazeSwitchButtonState(
toggled: null == toggled ? _self.toggled : toggled // ignore: cast_nullable_to_non_nullable
as bool,gazeInteractive: null == gazeInteractive ? _self.gazeInteractive : gazeInteractive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
