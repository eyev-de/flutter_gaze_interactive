// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pointer_state.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GazePointerState {
// type: passive (static circle), active (circle with animation on fixation)
  GazePointerType get type =>
      throw _privateConstructorUsedError; // ignore gesture on pointer
  bool get ignorePointer =>
      throw _privateConstructorUsedError; // ignore gesture on pointer
  double? get absoluteOpacityValue =>
      throw _privateConstructorUsedError; // can leave the view bounds, used for windows on desktop platforms that are partially interactive
  bool get canLeaveBounds =>
      throw _privateConstructorUsedError; // action on pointer
  GazePointerAction get action => throw _privateConstructorUsedError;
  dynamic Function(Offset)? get onAction => throw _privateConstructorUsedError;

  /// Create a copy of GazePointerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GazePointerStateCopyWith<GazePointerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GazePointerStateCopyWith<$Res> {
  factory $GazePointerStateCopyWith(
          GazePointerState value, $Res Function(GazePointerState) then) =
      _$GazePointerStateCopyWithImpl<$Res, GazePointerState>;
  @useResult
  $Res call(
      {GazePointerType type,
      bool ignorePointer,
      double? absoluteOpacityValue,
      bool canLeaveBounds,
      GazePointerAction action,
      dynamic Function(Offset)? onAction});
}

/// @nodoc
class _$GazePointerStateCopyWithImpl<$Res, $Val extends GazePointerState>
    implements $GazePointerStateCopyWith<$Res> {
  _$GazePointerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GazePointerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? ignorePointer = null,
    Object? absoluteOpacityValue = freezed,
    Object? canLeaveBounds = null,
    Object? action = null,
    Object? onAction = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GazePointerType,
      ignorePointer: null == ignorePointer
          ? _value.ignorePointer
          : ignorePointer // ignore: cast_nullable_to_non_nullable
              as bool,
      absoluteOpacityValue: freezed == absoluteOpacityValue
          ? _value.absoluteOpacityValue
          : absoluteOpacityValue // ignore: cast_nullable_to_non_nullable
              as double?,
      canLeaveBounds: null == canLeaveBounds
          ? _value.canLeaveBounds
          : canLeaveBounds // ignore: cast_nullable_to_non_nullable
              as bool,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as GazePointerAction,
      onAction: freezed == onAction
          ? _value.onAction
          : onAction // ignore: cast_nullable_to_non_nullable
              as dynamic Function(Offset)?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GazePointerStateImplCopyWith<$Res>
    implements $GazePointerStateCopyWith<$Res> {
  factory _$$GazePointerStateImplCopyWith(_$GazePointerStateImpl value,
          $Res Function(_$GazePointerStateImpl) then) =
      __$$GazePointerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GazePointerType type,
      bool ignorePointer,
      double? absoluteOpacityValue,
      bool canLeaveBounds,
      GazePointerAction action,
      dynamic Function(Offset)? onAction});
}

/// @nodoc
class __$$GazePointerStateImplCopyWithImpl<$Res>
    extends _$GazePointerStateCopyWithImpl<$Res, _$GazePointerStateImpl>
    implements _$$GazePointerStateImplCopyWith<$Res> {
  __$$GazePointerStateImplCopyWithImpl(_$GazePointerStateImpl _value,
      $Res Function(_$GazePointerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GazePointerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? ignorePointer = null,
    Object? absoluteOpacityValue = freezed,
    Object? canLeaveBounds = null,
    Object? action = null,
    Object? onAction = freezed,
  }) {
    return _then(_$GazePointerStateImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GazePointerType,
      ignorePointer: null == ignorePointer
          ? _value.ignorePointer
          : ignorePointer // ignore: cast_nullable_to_non_nullable
              as bool,
      absoluteOpacityValue: freezed == absoluteOpacityValue
          ? _value.absoluteOpacityValue
          : absoluteOpacityValue // ignore: cast_nullable_to_non_nullable
              as double?,
      canLeaveBounds: null == canLeaveBounds
          ? _value.canLeaveBounds
          : canLeaveBounds // ignore: cast_nullable_to_non_nullable
              as bool,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as GazePointerAction,
      onAction: freezed == onAction
          ? _value.onAction
          : onAction // ignore: cast_nullable_to_non_nullable
              as dynamic Function(Offset)?,
    ));
  }
}

/// @nodoc

class _$GazePointerStateImpl extends _GazePointerState {
  _$GazePointerStateImpl(
      {this.type = GazePointerType.passive,
      this.ignorePointer = false,
      this.absoluteOpacityValue = null,
      this.canLeaveBounds = false,
      this.action = GazePointerAction.click,
      this.onAction})
      : super._();

// type: passive (static circle), active (circle with animation on fixation)
  @override
  @JsonKey()
  final GazePointerType type;
// ignore gesture on pointer
  @override
  @JsonKey()
  final bool ignorePointer;
// ignore gesture on pointer
  @override
  @JsonKey()
  final double? absoluteOpacityValue;
// can leave the view bounds, used for windows on desktop platforms that are partially interactive
  @override
  @JsonKey()
  final bool canLeaveBounds;
// action on pointer
  @override
  @JsonKey()
  final GazePointerAction action;
  @override
  final dynamic Function(Offset)? onAction;

  @override
  String toString() {
    return 'GazePointerState(type: $type, ignorePointer: $ignorePointer, absoluteOpacityValue: $absoluteOpacityValue, canLeaveBounds: $canLeaveBounds, action: $action, onAction: $onAction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GazePointerStateImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.ignorePointer, ignorePointer) ||
                other.ignorePointer == ignorePointer) &&
            (identical(other.absoluteOpacityValue, absoluteOpacityValue) ||
                other.absoluteOpacityValue == absoluteOpacityValue) &&
            (identical(other.canLeaveBounds, canLeaveBounds) ||
                other.canLeaveBounds == canLeaveBounds) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.onAction, onAction) ||
                other.onAction == onAction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, ignorePointer,
      absoluteOpacityValue, canLeaveBounds, action, onAction);

  /// Create a copy of GazePointerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GazePointerStateImplCopyWith<_$GazePointerStateImpl> get copyWith =>
      __$$GazePointerStateImplCopyWithImpl<_$GazePointerStateImpl>(
          this, _$identity);
}

abstract class _GazePointerState extends GazePointerState {
  factory _GazePointerState(
      {final GazePointerType type,
      final bool ignorePointer,
      final double? absoluteOpacityValue,
      final bool canLeaveBounds,
      final GazePointerAction action,
      final dynamic Function(Offset)? onAction}) = _$GazePointerStateImpl;
  _GazePointerState._() : super._();

// type: passive (static circle), active (circle with animation on fixation)
  @override
  GazePointerType get type; // ignore gesture on pointer
  @override
  bool get ignorePointer; // ignore gesture on pointer
  @override
  double?
      get absoluteOpacityValue; // can leave the view bounds, used for windows on desktop platforms that are partially interactive
  @override
  bool get canLeaveBounds; // action on pointer
  @override
  GazePointerAction get action;
  @override
  dynamic Function(Offset)? get onAction;

  /// Create a copy of GazePointerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GazePointerStateImplCopyWith<_$GazePointerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
