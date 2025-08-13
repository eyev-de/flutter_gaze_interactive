// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
  bool get toggled;
  bool get gazeInteractive;

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GazeSwitchButtonStateCopyWith<GazeSwitchButtonState> get copyWith =>
      _$GazeSwitchButtonStateCopyWithImpl<GazeSwitchButtonState>(
          this as GazeSwitchButtonState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GazeSwitchButtonState &&
            (identical(other.toggled, toggled) || other.toggled == toggled) &&
            (identical(other.gazeInteractive, gazeInteractive) ||
                other.gazeInteractive == gazeInteractive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, toggled, gazeInteractive);

  @override
  String toString() {
    return 'GazeSwitchButtonState(toggled: $toggled, gazeInteractive: $gazeInteractive)';
  }
}

/// @nodoc
abstract mixin class $GazeSwitchButtonStateCopyWith<$Res> {
  factory $GazeSwitchButtonStateCopyWith(GazeSwitchButtonState value,
          $Res Function(GazeSwitchButtonState) _then) =
      _$GazeSwitchButtonStateCopyWithImpl;
  @useResult
  $Res call({bool toggled, bool gazeInteractive});
}

/// @nodoc
class _$GazeSwitchButtonStateCopyWithImpl<$Res>
    implements $GazeSwitchButtonStateCopyWith<$Res> {
  _$GazeSwitchButtonStateCopyWithImpl(this._self, this._then);

  final GazeSwitchButtonState _self;
  final $Res Function(GazeSwitchButtonState) _then;

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toggled = null,
    Object? gazeInteractive = null,
  }) {
    return _then(_self.copyWith(
      toggled: null == toggled
          ? _self.toggled
          : toggled // ignore: cast_nullable_to_non_nullable
              as bool,
      gazeInteractive: null == gazeInteractive
          ? _self.gazeInteractive
          : gazeInteractive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _GazeSwitchButtonState extends GazeSwitchButtonState {
  _GazeSwitchButtonState({required this.toggled, this.gazeInteractive = false})
      : super._();

  @override
  final bool toggled;
  @override
  @JsonKey()
  final bool gazeInteractive;

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GazeSwitchButtonStateCopyWith<_GazeSwitchButtonState> get copyWith =>
      __$GazeSwitchButtonStateCopyWithImpl<_GazeSwitchButtonState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GazeSwitchButtonState &&
            (identical(other.toggled, toggled) || other.toggled == toggled) &&
            (identical(other.gazeInteractive, gazeInteractive) ||
                other.gazeInteractive == gazeInteractive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, toggled, gazeInteractive);

  @override
  String toString() {
    return 'GazeSwitchButtonState(toggled: $toggled, gazeInteractive: $gazeInteractive)';
  }
}

/// @nodoc
abstract mixin class _$GazeSwitchButtonStateCopyWith<$Res>
    implements $GazeSwitchButtonStateCopyWith<$Res> {
  factory _$GazeSwitchButtonStateCopyWith(_GazeSwitchButtonState value,
          $Res Function(_GazeSwitchButtonState) _then) =
      __$GazeSwitchButtonStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool toggled, bool gazeInteractive});
}

/// @nodoc
class __$GazeSwitchButtonStateCopyWithImpl<$Res>
    implements _$GazeSwitchButtonStateCopyWith<$Res> {
  __$GazeSwitchButtonStateCopyWithImpl(this._self, this._then);

  final _GazeSwitchButtonState _self;
  final $Res Function(_GazeSwitchButtonState) _then;

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? toggled = null,
    Object? gazeInteractive = null,
  }) {
    return _then(_GazeSwitchButtonState(
      toggled: null == toggled
          ? _self.toggled
          : toggled // ignore: cast_nullable_to_non_nullable
              as bool,
      gazeInteractive: null == gazeInteractive
          ? _self.gazeInteractive
          : gazeInteractive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
