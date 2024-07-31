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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GazePointerState {
// type: passive (static circle), active (circle with animation on fixation)
  GazePointerType get type =>
      throw _privateConstructorUsedError; // ignore gesture on pointer
  bool get ignorePointer =>
      throw _privateConstructorUsedError; // ignore gesture on pointer
  bool get invisible => throw _privateConstructorUsedError; // action on pointer
  GazePointerAction get action => throw _privateConstructorUsedError;
  dynamic Function(Offset)? get onAction => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      bool invisible,
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? ignorePointer = null,
    Object? invisible = null,
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
      invisible: null == invisible
          ? _value.invisible
          : invisible // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_GazePointerStateCopyWith<$Res>
    implements $GazePointerStateCopyWith<$Res> {
  factory _$$_GazePointerStateCopyWith(
          _$_GazePointerState value, $Res Function(_$_GazePointerState) then) =
      __$$_GazePointerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GazePointerType type,
      bool ignorePointer,
      bool invisible,
      GazePointerAction action,
      dynamic Function(Offset)? onAction});
}

/// @nodoc
class __$$_GazePointerStateCopyWithImpl<$Res>
    extends _$GazePointerStateCopyWithImpl<$Res, _$_GazePointerState>
    implements _$$_GazePointerStateCopyWith<$Res> {
  __$$_GazePointerStateCopyWithImpl(
      _$_GazePointerState _value, $Res Function(_$_GazePointerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? ignorePointer = null,
    Object? invisible = null,
    Object? action = null,
    Object? onAction = freezed,
  }) {
    return _then(_$_GazePointerState(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as GazePointerType,
      ignorePointer: null == ignorePointer
          ? _value.ignorePointer
          : ignorePointer // ignore: cast_nullable_to_non_nullable
              as bool,
      invisible: null == invisible
          ? _value.invisible
          : invisible // ignore: cast_nullable_to_non_nullable
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

class _$_GazePointerState extends _GazePointerState {
  _$_GazePointerState(
      {this.type = GazePointerType.passive,
      this.ignorePointer = false,
      this.invisible = false,
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
  final bool invisible;
// action on pointer
  @override
  @JsonKey()
  final GazePointerAction action;
  @override
  final dynamic Function(Offset)? onAction;

  @override
  String toString() {
    return 'GazePointerState(type: $type, ignorePointer: $ignorePointer, invisible: $invisible, action: $action, onAction: $onAction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GazePointerState &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.ignorePointer, ignorePointer) ||
                other.ignorePointer == ignorePointer) &&
            (identical(other.invisible, invisible) ||
                other.invisible == invisible) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.onAction, onAction) ||
                other.onAction == onAction));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, type, ignorePointer, invisible, action, onAction);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GazePointerStateCopyWith<_$_GazePointerState> get copyWith =>
      __$$_GazePointerStateCopyWithImpl<_$_GazePointerState>(this, _$identity);
}

abstract class _GazePointerState extends GazePointerState {
  factory _GazePointerState(
      {final GazePointerType type,
      final bool ignorePointer,
      final bool invisible,
      final GazePointerAction action,
      final dynamic Function(Offset)? onAction}) = _$_GazePointerState;
  _GazePointerState._() : super._();

  @override // type: passive (static circle), active (circle with animation on fixation)
  GazePointerType get type;
  @override // ignore gesture on pointer
  bool get ignorePointer;
  @override // ignore gesture on pointer
  bool get invisible;
  @override // action on pointer
  GazePointerAction get action;
  @override
  dynamic Function(Offset)? get onAction;
  @override
  @JsonKey(ignore: true)
  _$$_GazePointerStateCopyWith<_$_GazePointerState> get copyWith =>
      throw _privateConstructorUsedError;
}
