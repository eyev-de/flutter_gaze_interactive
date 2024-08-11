// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'switch_button_state.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GazeSwitchButtonState {
  bool get toggled => throw _privateConstructorUsedError;
  bool get gazeInteractive => throw _privateConstructorUsedError;

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GazeSwitchButtonStateCopyWith<GazeSwitchButtonState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GazeSwitchButtonStateCopyWith<$Res> {
  factory $GazeSwitchButtonStateCopyWith(GazeSwitchButtonState value,
          $Res Function(GazeSwitchButtonState) then) =
      _$GazeSwitchButtonStateCopyWithImpl<$Res, GazeSwitchButtonState>;
  @useResult
  $Res call({bool toggled, bool gazeInteractive});
}

/// @nodoc
class _$GazeSwitchButtonStateCopyWithImpl<$Res,
        $Val extends GazeSwitchButtonState>
    implements $GazeSwitchButtonStateCopyWith<$Res> {
  _$GazeSwitchButtonStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toggled = null,
    Object? gazeInteractive = null,
  }) {
    return _then(_value.copyWith(
      toggled: null == toggled
          ? _value.toggled
          : toggled // ignore: cast_nullable_to_non_nullable
              as bool,
      gazeInteractive: null == gazeInteractive
          ? _value.gazeInteractive
          : gazeInteractive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GazeSwitchButtonStateImplCopyWith<$Res>
    implements $GazeSwitchButtonStateCopyWith<$Res> {
  factory _$$GazeSwitchButtonStateImplCopyWith(
          _$GazeSwitchButtonStateImpl value,
          $Res Function(_$GazeSwitchButtonStateImpl) then) =
      __$$GazeSwitchButtonStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool toggled, bool gazeInteractive});
}

/// @nodoc
class __$$GazeSwitchButtonStateImplCopyWithImpl<$Res>
    extends _$GazeSwitchButtonStateCopyWithImpl<$Res,
        _$GazeSwitchButtonStateImpl>
    implements _$$GazeSwitchButtonStateImplCopyWith<$Res> {
  __$$GazeSwitchButtonStateImplCopyWithImpl(_$GazeSwitchButtonStateImpl _value,
      $Res Function(_$GazeSwitchButtonStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toggled = null,
    Object? gazeInteractive = null,
  }) {
    return _then(_$GazeSwitchButtonStateImpl(
      toggled: null == toggled
          ? _value.toggled
          : toggled // ignore: cast_nullable_to_non_nullable
              as bool,
      gazeInteractive: null == gazeInteractive
          ? _value.gazeInteractive
          : gazeInteractive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$GazeSwitchButtonStateImpl extends _GazeSwitchButtonState {
  _$GazeSwitchButtonStateImpl(
      {required this.toggled, this.gazeInteractive = false})
      : super._();

  @override
  final bool toggled;
  @override
  @JsonKey()
  final bool gazeInteractive;

  @override
  String toString() {
    return 'GazeSwitchButtonState(toggled: $toggled, gazeInteractive: $gazeInteractive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GazeSwitchButtonStateImpl &&
            (identical(other.toggled, toggled) || other.toggled == toggled) &&
            (identical(other.gazeInteractive, gazeInteractive) ||
                other.gazeInteractive == gazeInteractive));
  }

  @override
  int get hashCode => Object.hash(runtimeType, toggled, gazeInteractive);

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GazeSwitchButtonStateImplCopyWith<_$GazeSwitchButtonStateImpl>
      get copyWith => __$$GazeSwitchButtonStateImplCopyWithImpl<
          _$GazeSwitchButtonStateImpl>(this, _$identity);
}

abstract class _GazeSwitchButtonState extends GazeSwitchButtonState {
  factory _GazeSwitchButtonState(
      {required final bool toggled,
      final bool gazeInteractive}) = _$GazeSwitchButtonStateImpl;
  _GazeSwitchButtonState._() : super._();

  @override
  bool get toggled;
  @override
  bool get gazeInteractive;

  /// Create a copy of GazeSwitchButtonState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GazeSwitchButtonStateImplCopyWith<_$GazeSwitchButtonStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
