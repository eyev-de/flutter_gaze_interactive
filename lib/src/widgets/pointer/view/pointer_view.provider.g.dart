// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pointer_view.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pointerAnimationControllerHash() =>
    r'6e071f419b81615ab7f6403e91282cf6b658bd32';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PointerAnimationController
    extends BuildlessAutoDisposeNotifier<AnimationController> {
  late final TickerProvider vsync;

  AnimationController build({required TickerProvider vsync});
}

/// Animation Controller
///
/// Copied from [PointerAnimationController].
@ProviderFor(PointerAnimationController)
const pointerAnimationControllerProvider = PointerAnimationControllerFamily();

/// Animation Controller
///
/// Copied from [PointerAnimationController].
class PointerAnimationControllerFamily extends Family<AnimationController> {
  /// Animation Controller
  ///
  /// Copied from [PointerAnimationController].
  const PointerAnimationControllerFamily();

  /// Animation Controller
  ///
  /// Copied from [PointerAnimationController].
  PointerAnimationControllerProvider call({required TickerProvider vsync}) {
    return PointerAnimationControllerProvider(vsync: vsync);
  }

  @override
  PointerAnimationControllerProvider getProviderOverride(
    covariant PointerAnimationControllerProvider provider,
  ) {
    return call(vsync: provider.vsync);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pointerAnimationControllerProvider';
}

/// Animation Controller
///
/// Copied from [PointerAnimationController].
class PointerAnimationControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          PointerAnimationController,
          AnimationController
        > {
  /// Animation Controller
  ///
  /// Copied from [PointerAnimationController].
  PointerAnimationControllerProvider({required TickerProvider vsync})
    : this._internal(
        () => PointerAnimationController()..vsync = vsync,
        from: pointerAnimationControllerProvider,
        name: r'pointerAnimationControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pointerAnimationControllerHash,
        dependencies: PointerAnimationControllerFamily._dependencies,
        allTransitiveDependencies:
            PointerAnimationControllerFamily._allTransitiveDependencies,
        vsync: vsync,
      );

  PointerAnimationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vsync,
  }) : super.internal();

  final TickerProvider vsync;

  @override
  AnimationController runNotifierBuild(
    covariant PointerAnimationController notifier,
  ) {
    return notifier.build(vsync: vsync);
  }

  @override
  Override overrideWith(PointerAnimationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PointerAnimationControllerProvider._internal(
        () => create()..vsync = vsync,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vsync: vsync,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    PointerAnimationController,
    AnimationController
  >
  createElement() {
    return _PointerAnimationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PointerAnimationControllerProvider && other.vsync == vsync;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vsync.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PointerAnimationControllerRef
    on AutoDisposeNotifierProviderRef<AnimationController> {
  /// The parameter `vsync` of this provider.
  TickerProvider get vsync;
}

class _PointerAnimationControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          PointerAnimationController,
          AnimationController
        >
    with PointerAnimationControllerRef {
  _PointerAnimationControllerProviderElement(super.provider);

  @override
  TickerProvider get vsync =>
      (origin as PointerAnimationControllerProvider).vsync;
}

String _$pointerAnimationHash() => r'334d78d535c1a588bea85cd0f06f81c3597d0e4e';

abstract class _$PointerAnimation
    extends BuildlessAutoDisposeNotifier<Animation<double>> {
  late final TickerProvider vsync;

  Animation<double> build({required TickerProvider vsync});
}

/// See also [PointerAnimation].
@ProviderFor(PointerAnimation)
const pointerAnimationProvider = PointerAnimationFamily();

/// See also [PointerAnimation].
class PointerAnimationFamily extends Family<Animation<double>> {
  /// See also [PointerAnimation].
  const PointerAnimationFamily();

  /// See also [PointerAnimation].
  PointerAnimationProvider call({required TickerProvider vsync}) {
    return PointerAnimationProvider(vsync: vsync);
  }

  @override
  PointerAnimationProvider getProviderOverride(
    covariant PointerAnimationProvider provider,
  ) {
    return call(vsync: provider.vsync);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pointerAnimationProvider';
}

/// See also [PointerAnimation].
class PointerAnimationProvider
    extends
        AutoDisposeNotifierProviderImpl<PointerAnimation, Animation<double>> {
  /// See also [PointerAnimation].
  PointerAnimationProvider({required TickerProvider vsync})
    : this._internal(
        () => PointerAnimation()..vsync = vsync,
        from: pointerAnimationProvider,
        name: r'pointerAnimationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pointerAnimationHash,
        dependencies: PointerAnimationFamily._dependencies,
        allTransitiveDependencies:
            PointerAnimationFamily._allTransitiveDependencies,
        vsync: vsync,
      );

  PointerAnimationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vsync,
  }) : super.internal();

  final TickerProvider vsync;

  @override
  Animation<double> runNotifierBuild(covariant PointerAnimation notifier) {
    return notifier.build(vsync: vsync);
  }

  @override
  Override overrideWith(PointerAnimation Function() create) {
    return ProviderOverride(
      origin: this,
      override: PointerAnimationProvider._internal(
        () => create()..vsync = vsync,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vsync: vsync,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PointerAnimation, Animation<double>>
  createElement() {
    return _PointerAnimationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PointerAnimationProvider && other.vsync == vsync;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vsync.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PointerAnimationRef on AutoDisposeNotifierProviderRef<Animation<double>> {
  /// The parameter `vsync` of this provider.
  TickerProvider get vsync;
}

class _PointerAnimationProviderElement
    extends
        AutoDisposeNotifierProviderElement<PointerAnimation, Animation<double>>
    with PointerAnimationRef {
  _PointerAnimationProviderElement(super.provider);

  @override
  TickerProvider get vsync => (origin as PointerAnimationProvider).vsync;
}

String _$pointerIsMovingHash() => r'1b8ce36b3352a45ba2cd969ced738e780eed33b6';

/// See also [PointerIsMoving].
@ProviderFor(PointerIsMoving)
final pointerIsMovingProvider =
    AutoDisposeNotifierProvider<PointerIsMoving, bool>.internal(
      PointerIsMoving.new,
      name: r'pointerIsMovingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pointerIsMovingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PointerIsMoving = AutoDisposeNotifier<bool>;
String _$pointerOpacityHash() => r'727d06f62551cab2f88e727bb0ec4e7794ea245f';

/// Gaze Pointer appears shortly and is then faded out -> current opacity
///
/// Copied from [PointerOpacity].
@ProviderFor(PointerOpacity)
final pointerOpacityProvider =
    AutoDisposeNotifierProvider<PointerOpacity, double>.internal(
      PointerOpacity.new,
      name: r'pointerOpacityProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pointerOpacityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PointerOpacity = AutoDisposeNotifier<double>;
String _$pointerColorHash() => r'48c839ee1718a4ed70cb5c8b223875b8a188886c';

abstract class _$PointerColor extends BuildlessAutoDisposeNotifier<Color> {
  late final GazePointerType type;

  Color build({required GazePointerType type});
}

/// See also [PointerColor].
@ProviderFor(PointerColor)
const pointerColorProvider = PointerColorFamily();

/// See also [PointerColor].
class PointerColorFamily extends Family<Color> {
  /// See also [PointerColor].
  const PointerColorFamily();

  /// See also [PointerColor].
  PointerColorProvider call({required GazePointerType type}) {
    return PointerColorProvider(type: type);
  }

  @override
  PointerColorProvider getProviderOverride(
    covariant PointerColorProvider provider,
  ) {
    return call(type: provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pointerColorProvider';
}

/// See also [PointerColor].
class PointerColorProvider
    extends AutoDisposeNotifierProviderImpl<PointerColor, Color> {
  /// See also [PointerColor].
  PointerColorProvider({required GazePointerType type})
    : this._internal(
        () => PointerColor()..type = type,
        from: pointerColorProvider,
        name: r'pointerColorProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pointerColorHash,
        dependencies: PointerColorFamily._dependencies,
        allTransitiveDependencies:
            PointerColorFamily._allTransitiveDependencies,
        type: type,
      );

  PointerColorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final GazePointerType type;

  @override
  Color runNotifierBuild(covariant PointerColor notifier) {
    return notifier.build(type: type);
  }

  @override
  Override overrideWith(PointerColor Function() create) {
    return ProviderOverride(
      origin: this,
      override: PointerColorProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PointerColor, Color> createElement() {
    return _PointerColorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PointerColorProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PointerColorRef on AutoDisposeNotifierProviderRef<Color> {
  /// The parameter `type` of this provider.
  GazePointerType get type;
}

class _PointerColorProviderElement
    extends AutoDisposeNotifierProviderElement<PointerColor, Color>
    with PointerColorRef {
  _PointerColorProviderElement(super.provider);

  @override
  GazePointerType get type => (origin as PointerColorProvider).type;
}

String _$pointerSizeHash() => r'64e0f8e2c0cf221b3c380cce07bfd35bfc17f0c5';

abstract class _$PointerSize extends BuildlessAutoDisposeNotifier<double> {
  late final GazePointerType type;

  double build({required GazePointerType type});
}

/// Gaze Pointer Circle Size
///
/// Copied from [PointerSize].
@ProviderFor(PointerSize)
const pointerSizeProvider = PointerSizeFamily();

/// Gaze Pointer Circle Size
///
/// Copied from [PointerSize].
class PointerSizeFamily extends Family<double> {
  /// Gaze Pointer Circle Size
  ///
  /// Copied from [PointerSize].
  const PointerSizeFamily();

  /// Gaze Pointer Circle Size
  ///
  /// Copied from [PointerSize].
  PointerSizeProvider call({required GazePointerType type}) {
    return PointerSizeProvider(type: type);
  }

  @override
  PointerSizeProvider getProviderOverride(
    covariant PointerSizeProvider provider,
  ) {
    return call(type: provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pointerSizeProvider';
}

/// Gaze Pointer Circle Size
///
/// Copied from [PointerSize].
class PointerSizeProvider
    extends AutoDisposeNotifierProviderImpl<PointerSize, double> {
  /// Gaze Pointer Circle Size
  ///
  /// Copied from [PointerSize].
  PointerSizeProvider({required GazePointerType type})
    : this._internal(
        () => PointerSize()..type = type,
        from: pointerSizeProvider,
        name: r'pointerSizeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pointerSizeHash,
        dependencies: PointerSizeFamily._dependencies,
        allTransitiveDependencies: PointerSizeFamily._allTransitiveDependencies,
        type: type,
      );

  PointerSizeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final GazePointerType type;

  @override
  double runNotifierBuild(covariant PointerSize notifier) {
    return notifier.build(type: type);
  }

  @override
  Override overrideWith(PointerSize Function() create) {
    return ProviderOverride(
      origin: this,
      override: PointerSizeProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PointerSize, double> createElement() {
    return _PointerSizeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PointerSizeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PointerSizeRef on AutoDisposeNotifierProviderRef<double> {
  /// The parameter `type` of this provider.
  GazePointerType get type;
}

class _PointerSizeProviderElement
    extends AutoDisposeNotifierProviderElement<PointerSize, double>
    with PointerSizeRef {
  _PointerSizeProviderElement(super.provider);

  @override
  GazePointerType get type => (origin as PointerSizeProvider).type;
}

String _$pointerOffsetHash() => r'b865fafaeea979307ea9327532cc8cfc2748eb1b';

/// Gaze Pointer Offset
///
/// Copied from [PointerOffset].
@ProviderFor(PointerOffset)
final pointerOffsetProvider =
    AutoDisposeNotifierProvider<PointerOffset, Offset>.internal(
      PointerOffset.new,
      name: r'pointerOffsetProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pointerOffsetHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PointerOffset = AutoDisposeNotifier<Offset>;
String _$pointerHistoryHash() => r'5287b52caf12e35d985f7e96088f9c299b829105';

/// See also [PointerHistory].
@ProviderFor(PointerHistory)
final pointerHistoryProvider =
    AutoDisposeNotifierProvider<
      PointerHistory,
      Queue<(GlobalKey key, Offset offset)>
    >.internal(
      PointerHistory.new,
      name: r'pointerHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pointerHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PointerHistory =
    AutoDisposeNotifier<Queue<(GlobalKey key, Offset offset)>>;
String _$pointerFixationPointHash() =>
    r'30365f0aa87b69a9e8a75ddc90185455ffd4a71a';

/// Gaze Pointer Fixation Point
///
/// Copied from [PointerFixationPoint].
@ProviderFor(PointerFixationPoint)
final pointerFixationPointProvider =
    NotifierProvider<PointerFixationPoint, Offset>.internal(
      PointerFixationPoint.new,
      name: r'pointerFixationPointProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pointerFixationPointHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PointerFixationPoint = Notifier<Offset>;
String _$snapElementHash() => r'ddf6ae096ef462be6329f6d12129fa8b8e5d39cb';

/// Gaze Pointer Snapping Point
///
/// Copied from [SnapElement].
@ProviderFor(SnapElement)
final snapElementProvider =
    NotifierProvider<SnapElement, GazeElementData?>.internal(
      SnapElement.new,
      name: r'snapElementProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$snapElementHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SnapElement = Notifier<GazeElementData?>;
String _$snappingStateHash() => r'4dbdcdac784cb60eabecf180b809e3289015cec8';

/// Gaze Pointer in snapp mode Point
///
/// Copied from [SnappingState].
@ProviderFor(SnappingState)
final snappingStateProvider =
    NotifierProvider<SnappingState, SnapState>.internal(
      SnappingState.new,
      name: r'snappingStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$snappingStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SnappingState = Notifier<SnapState>;
String _$pointerFixationRadiusHash() =>
    r'9b571565e8267bb0ec6475b5227fe8d27c3b18f6';

/// Gaze Pointer Fixation Radius
///
/// Copied from [PointerFixationRadius].
@ProviderFor(PointerFixationRadius)
final pointerFixationRadiusProvider =
    NotifierProvider<PointerFixationRadius, double>.internal(
      PointerFixationRadius.new,
      name: r'pointerFixationRadiusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pointerFixationRadiusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PointerFixationRadius = Notifier<double>;
String _$pointerSnappingRadiusHash() =>
    r'1a98da0a320a1f8813095aa5ff6d875bd0d54339';

/// Gaze Pointer Snapping Radius
///
/// Copied from [PointerSnappingRadius].
@ProviderFor(PointerSnappingRadius)
final pointerSnappingRadiusProvider =
    AutoDisposeNotifierProvider<PointerSnappingRadius, double>.internal(
      PointerSnappingRadius.new,
      name: r'pointerSnappingRadiusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pointerSnappingRadiusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PointerSnappingRadius = AutoDisposeNotifier<double>;
String _$ignorePointerStateHash() =>
    r'fd15cdd57247539445190998e274112b54f62ae5';

/// Indicates if recently snapped and pointer is ignored by mouse
///
/// Copied from [IgnorePointerState].
@ProviderFor(IgnorePointerState)
final ignorePointerStateProvider =
    AutoDisposeNotifierProvider<IgnorePointerState, bool>.internal(
      IgnorePointerState.new,
      name: r'ignorePointerStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ignorePointerStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IgnorePointerState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
