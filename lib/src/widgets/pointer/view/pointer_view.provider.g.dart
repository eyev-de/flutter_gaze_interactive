// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pointer_view.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Animation Controller

@ProviderFor(PointerAnimationController)
final pointerAnimationControllerProvider = PointerAnimationControllerFamily._();

/// Animation Controller
final class PointerAnimationControllerProvider extends $NotifierProvider<PointerAnimationController, AnimationController> {
  /// Animation Controller
  PointerAnimationControllerProvider._({required PointerAnimationControllerFamily super.from, required TickerProvider super.argument})
    : super(retry: null, name: r'pointerAnimationControllerProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$pointerAnimationControllerHash();

  @override
  String toString() {
    return r'pointerAnimationControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PointerAnimationController create() => PointerAnimationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnimationController value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AnimationController>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is PointerAnimationControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pointerAnimationControllerHash() => r'6e071f419b81615ab7f6403e91282cf6b658bd32';

/// Animation Controller

final class PointerAnimationControllerFamily extends $Family
    with $ClassFamilyOverride<PointerAnimationController, AnimationController, AnimationController, AnimationController, TickerProvider> {
  PointerAnimationControllerFamily._()
    : super(retry: null, name: r'pointerAnimationControllerProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// Animation Controller

  PointerAnimationControllerProvider call({required TickerProvider vsync}) => PointerAnimationControllerProvider._(argument: vsync, from: this);

  @override
  String toString() => r'pointerAnimationControllerProvider';
}

/// Animation Controller

abstract class _$PointerAnimationController extends $Notifier<AnimationController> {
  late final _$args = ref.$arg as TickerProvider;
  TickerProvider get vsync => _$args;

  AnimationController build({required TickerProvider vsync});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AnimationController, AnimationController>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AnimationController, AnimationController>, AnimationController, Object?, Object?>;
    element.handleCreate(ref, () => build(vsync: _$args));
  }
}

@ProviderFor(PointerAnimation)
final pointerAnimationProvider = PointerAnimationFamily._();

final class PointerAnimationProvider extends $NotifierProvider<PointerAnimation, Animation<double>> {
  PointerAnimationProvider._({required PointerAnimationFamily super.from, required TickerProvider super.argument})
    : super(retry: null, name: r'pointerAnimationProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$pointerAnimationHash();

  @override
  String toString() {
    return r'pointerAnimationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PointerAnimation create() => PointerAnimation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Animation<double> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Animation<double>>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is PointerAnimationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pointerAnimationHash() => r'334d78d535c1a588bea85cd0f06f81c3597d0e4e';

final class PointerAnimationFamily extends $Family
    with $ClassFamilyOverride<PointerAnimation, Animation<double>, Animation<double>, Animation<double>, TickerProvider> {
  PointerAnimationFamily._() : super(retry: null, name: r'pointerAnimationProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  PointerAnimationProvider call({required TickerProvider vsync}) => PointerAnimationProvider._(argument: vsync, from: this);

  @override
  String toString() => r'pointerAnimationProvider';
}

abstract class _$PointerAnimation extends $Notifier<Animation<double>> {
  late final _$args = ref.$arg as TickerProvider;
  TickerProvider get vsync => _$args;

  Animation<double> build({required TickerProvider vsync});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Animation<double>, Animation<double>>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Animation<double>, Animation<double>>, Animation<double>, Object?, Object?>;
    element.handleCreate(ref, () => build(vsync: _$args));
  }
}

@ProviderFor(PointerIsMoving)
final pointerIsMovingProvider = PointerIsMovingProvider._();

final class PointerIsMovingProvider extends $NotifierProvider<PointerIsMoving, bool> {
  PointerIsMovingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointerIsMovingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointerIsMovingHash();

  @$internal
  @override
  PointerIsMoving create() => PointerIsMoving();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$pointerIsMovingHash() => r'1b8ce36b3352a45ba2cd969ced738e780eed33b6';

abstract class _$PointerIsMoving extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Gaze Pointer appears shortly and is then faded out -> current opacity

@ProviderFor(PointerOpacity)
final pointerOpacityProvider = PointerOpacityProvider._();

/// Gaze Pointer appears shortly and is then faded out -> current opacity
final class PointerOpacityProvider extends $NotifierProvider<PointerOpacity, double> {
  /// Gaze Pointer appears shortly and is then faded out -> current opacity
  PointerOpacityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointerOpacityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointerOpacityHash();

  @$internal
  @override
  PointerOpacity create() => PointerOpacity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<double>(value));
  }
}

String _$pointerOpacityHash() => r'727d06f62551cab2f88e727bb0ec4e7794ea245f';

/// Gaze Pointer appears shortly and is then faded out -> current opacity

abstract class _$PointerOpacity extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<double, double>, double, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PointerColor)
final pointerColorProvider = PointerColorFamily._();

final class PointerColorProvider extends $NotifierProvider<PointerColor, Color> {
  PointerColorProvider._({required PointerColorFamily super.from, required GazePointerType super.argument})
    : super(retry: null, name: r'pointerColorProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$pointerColorHash();

  @override
  String toString() {
    return r'pointerColorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PointerColor create() => PointerColor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Color>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is PointerColorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pointerColorHash() => r'48c839ee1718a4ed70cb5c8b223875b8a188886c';

final class PointerColorFamily extends $Family with $ClassFamilyOverride<PointerColor, Color, Color, Color, GazePointerType> {
  PointerColorFamily._() : super(retry: null, name: r'pointerColorProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  PointerColorProvider call({required GazePointerType type}) => PointerColorProvider._(argument: type, from: this);

  @override
  String toString() => r'pointerColorProvider';
}

abstract class _$PointerColor extends $Notifier<Color> {
  late final _$args = ref.$arg as GazePointerType;
  GazePointerType get type => _$args;

  Color build({required GazePointerType type});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Color, Color>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Color, Color>, Color, Object?, Object?>;
    element.handleCreate(ref, () => build(type: _$args));
  }
}

/// Gaze Pointer Circle Size

@ProviderFor(PointerSize)
final pointerSizeProvider = PointerSizeFamily._();

/// Gaze Pointer Circle Size
final class PointerSizeProvider extends $NotifierProvider<PointerSize, double> {
  /// Gaze Pointer Circle Size
  PointerSizeProvider._({required PointerSizeFamily super.from, required GazePointerType super.argument})
    : super(retry: null, name: r'pointerSizeProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$pointerSizeHash();

  @override
  String toString() {
    return r'pointerSizeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PointerSize create() => PointerSize();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<double>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is PointerSizeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pointerSizeHash() => r'64e0f8e2c0cf221b3c380cce07bfd35bfc17f0c5';

/// Gaze Pointer Circle Size

final class PointerSizeFamily extends $Family with $ClassFamilyOverride<PointerSize, double, double, double, GazePointerType> {
  PointerSizeFamily._() : super(retry: null, name: r'pointerSizeProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  /// Gaze Pointer Circle Size

  PointerSizeProvider call({required GazePointerType type}) => PointerSizeProvider._(argument: type, from: this);

  @override
  String toString() => r'pointerSizeProvider';
}

/// Gaze Pointer Circle Size

abstract class _$PointerSize extends $Notifier<double> {
  late final _$args = ref.$arg as GazePointerType;
  GazePointerType get type => _$args;

  double build({required GazePointerType type});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<double, double>, double, Object?, Object?>;
    element.handleCreate(ref, () => build(type: _$args));
  }
}

/// Gaze Pointer Offset

@ProviderFor(PointerOffset)
final pointerOffsetProvider = PointerOffsetProvider._();

/// Gaze Pointer Offset
final class PointerOffsetProvider extends $NotifierProvider<PointerOffset, Offset> {
  /// Gaze Pointer Offset
  PointerOffsetProvider._()
    : super(from: null, argument: null, retry: null, name: r'pointerOffsetProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$pointerOffsetHash();

  @$internal
  @override
  PointerOffset create() => PointerOffset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Offset value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Offset>(value));
  }
}

String _$pointerOffsetHash() => r'b865fafaeea979307ea9327532cc8cfc2748eb1b';

/// Gaze Pointer Offset

abstract class _$PointerOffset extends $Notifier<Offset> {
  Offset build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Offset, Offset>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Offset, Offset>, Offset, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PointerHistory)
final pointerHistoryProvider = PointerHistoryProvider._();

final class PointerHistoryProvider extends $NotifierProvider<PointerHistory, Queue<(GlobalKey<State<StatefulWidget>>, Offset)>> {
  PointerHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointerHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointerHistoryHash();

  @$internal
  @override
  PointerHistory create() => PointerHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Queue<(GlobalKey<State<StatefulWidget>>, Offset)> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Queue<(GlobalKey<State<StatefulWidget>>, Offset)>>(value));
  }
}

String _$pointerHistoryHash() => r'5287b52caf12e35d985f7e96088f9c299b829105';

abstract class _$PointerHistory extends $Notifier<Queue<(GlobalKey<State<StatefulWidget>>, Offset)>> {
  Queue<(GlobalKey<State<StatefulWidget>>, Offset)> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Queue<(GlobalKey<State<StatefulWidget>>, Offset)>, Queue<(GlobalKey<State<StatefulWidget>>, Offset)>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Queue<(GlobalKey<State<StatefulWidget>>, Offset)>, Queue<(GlobalKey<State<StatefulWidget>>, Offset)>>,
              Queue<(GlobalKey<State<StatefulWidget>>, Offset)>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Gaze Pointer Fixation Point

@ProviderFor(PointerFixationPoint)
final pointerFixationPointProvider = PointerFixationPointProvider._();

/// Gaze Pointer Fixation Point
final class PointerFixationPointProvider extends $NotifierProvider<PointerFixationPoint, Offset> {
  /// Gaze Pointer Fixation Point
  PointerFixationPointProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointerFixationPointProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointerFixationPointHash();

  @$internal
  @override
  PointerFixationPoint create() => PointerFixationPoint();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Offset value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Offset>(value));
  }
}

String _$pointerFixationPointHash() => r'30365f0aa87b69a9e8a75ddc90185455ffd4a71a';

/// Gaze Pointer Fixation Point

abstract class _$PointerFixationPoint extends $Notifier<Offset> {
  Offset build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Offset, Offset>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<Offset, Offset>, Offset, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Gaze Pointer Snapping Point

@ProviderFor(SnapElement)
final snapElementProvider = SnapElementProvider._();

/// Gaze Pointer Snapping Point
final class SnapElementProvider extends $NotifierProvider<SnapElement, GazeElementData?> {
  /// Gaze Pointer Snapping Point
  SnapElementProvider._()
    : super(from: null, argument: null, retry: null, name: r'snapElementProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$snapElementHash();

  @$internal
  @override
  SnapElement create() => SnapElement();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GazeElementData? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GazeElementData?>(value));
  }
}

String _$snapElementHash() => r'ddf6ae096ef462be6329f6d12129fa8b8e5d39cb';

/// Gaze Pointer Snapping Point

abstract class _$SnapElement extends $Notifier<GazeElementData?> {
  GazeElementData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GazeElementData?, GazeElementData?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<GazeElementData?, GazeElementData?>, GazeElementData?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Gaze Pointer in snapp mode Point

@ProviderFor(SnappingState)
final snappingStateProvider = SnappingStateProvider._();

/// Gaze Pointer in snapp mode Point
final class SnappingStateProvider extends $NotifierProvider<SnappingState, SnapState> {
  /// Gaze Pointer in snapp mode Point
  SnappingStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snappingStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snappingStateHash();

  @$internal
  @override
  SnappingState create() => SnappingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SnapState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SnapState>(value));
  }
}

String _$snappingStateHash() => r'4dbdcdac784cb60eabecf180b809e3289015cec8';

/// Gaze Pointer in snapp mode Point

abstract class _$SnappingState extends $Notifier<SnapState> {
  SnapState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SnapState, SnapState>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<SnapState, SnapState>, SnapState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Gaze Pointer Fixation Radius

@ProviderFor(PointerFixationRadius)
final pointerFixationRadiusProvider = PointerFixationRadiusProvider._();

/// Gaze Pointer Fixation Radius
final class PointerFixationRadiusProvider extends $NotifierProvider<PointerFixationRadius, double> {
  /// Gaze Pointer Fixation Radius
  PointerFixationRadiusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointerFixationRadiusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointerFixationRadiusHash();

  @$internal
  @override
  PointerFixationRadius create() => PointerFixationRadius();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<double>(value));
  }
}

String _$pointerFixationRadiusHash() => r'9b571565e8267bb0ec6475b5227fe8d27c3b18f6';

/// Gaze Pointer Fixation Radius

abstract class _$PointerFixationRadius extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<double, double>, double, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Gaze Pointer Snapping Radius

@ProviderFor(PointerSnappingRadius)
final pointerSnappingRadiusProvider = PointerSnappingRadiusProvider._();

/// Gaze Pointer Snapping Radius
final class PointerSnappingRadiusProvider extends $NotifierProvider<PointerSnappingRadius, double> {
  /// Gaze Pointer Snapping Radius
  PointerSnappingRadiusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointerSnappingRadiusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointerSnappingRadiusHash();

  @$internal
  @override
  PointerSnappingRadius create() => PointerSnappingRadius();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<double>(value));
  }
}

String _$pointerSnappingRadiusHash() => r'1a98da0a320a1f8813095aa5ff6d875bd0d54339';

/// Gaze Pointer Snapping Radius

abstract class _$PointerSnappingRadius extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<double, double>, double, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Indicates if recently snapped and pointer is ignored by mouse

@ProviderFor(IgnorePointerState)
final ignorePointerStateProvider = IgnorePointerStateProvider._();

/// Indicates if recently snapped and pointer is ignored by mouse
final class IgnorePointerStateProvider extends $NotifierProvider<IgnorePointerState, bool> {
  /// Indicates if recently snapped and pointer is ignored by mouse
  IgnorePointerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ignorePointerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ignorePointerStateHash();

  @$internal
  @override
  IgnorePointerState create() => IgnorePointerState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$ignorePointerStateHash() => r'fd15cdd57247539445190998e274112b54f62ae5';

/// Indicates if recently snapped and pointer is ignored by mouse

abstract class _$IgnorePointerState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
