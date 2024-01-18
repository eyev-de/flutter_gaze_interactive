// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pointer_view.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pointerAnimationControllerHash() =>
    r'ed5780ae4a596257bd0c145f2b5fc6937f52acd6';

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

  AnimationController build({
    required TickerProvider vsync,
  });
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
  PointerAnimationControllerProvider call({
    required TickerProvider vsync,
  }) {
    return PointerAnimationControllerProvider(
      vsync: vsync,
    );
  }

  @override
  PointerAnimationControllerProvider getProviderOverride(
    covariant PointerAnimationControllerProvider provider,
  ) {
    return call(
      vsync: provider.vsync,
    );
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
    extends AutoDisposeNotifierProviderImpl<PointerAnimationController,
        AnimationController> {
  /// Animation Controller
  ///
  /// Copied from [PointerAnimationController].
  PointerAnimationControllerProvider({
    required TickerProvider vsync,
  }) : this._internal(
          () => PointerAnimationController()..vsync = vsync,
          from: pointerAnimationControllerProvider,
          name: r'pointerAnimationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
    return notifier.build(
      vsync: vsync,
    );
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
  AutoDisposeNotifierProviderElement<PointerAnimationController,
      AnimationController> createElement() {
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

mixin PointerAnimationControllerRef
    on AutoDisposeNotifierProviderRef<AnimationController> {
  /// The parameter `vsync` of this provider.
  TickerProvider get vsync;
}

class _PointerAnimationControllerProviderElement
    extends AutoDisposeNotifierProviderElement<PointerAnimationController,
        AnimationController> with PointerAnimationControllerRef {
  _PointerAnimationControllerProviderElement(super.provider);

  @override
  TickerProvider get vsync =>
      (origin as PointerAnimationControllerProvider).vsync;
}

String _$pointerAnimationHash() => r'334d78d535c1a588bea85cd0f06f81c3597d0e4e';

abstract class _$PointerAnimation
    extends BuildlessAutoDisposeNotifier<Animation<double>> {
  late final TickerProvider vsync;

  Animation<double> build({
    required TickerProvider vsync,
  });
}

/// See also [PointerAnimation].
@ProviderFor(PointerAnimation)
const pointerAnimationProvider = PointerAnimationFamily();

/// See also [PointerAnimation].
class PointerAnimationFamily extends Family<Animation<double>> {
  /// See also [PointerAnimation].
  const PointerAnimationFamily();

  /// See also [PointerAnimation].
  PointerAnimationProvider call({
    required TickerProvider vsync,
  }) {
    return PointerAnimationProvider(
      vsync: vsync,
    );
  }

  @override
  PointerAnimationProvider getProviderOverride(
    covariant PointerAnimationProvider provider,
  ) {
    return call(
      vsync: provider.vsync,
    );
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
class PointerAnimationProvider extends AutoDisposeNotifierProviderImpl<
    PointerAnimation, Animation<double>> {
  /// See also [PointerAnimation].
  PointerAnimationProvider({
    required TickerProvider vsync,
  }) : this._internal(
          () => PointerAnimation()..vsync = vsync,
          from: pointerAnimationProvider,
          name: r'pointerAnimationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
  Animation<double> runNotifierBuild(
    covariant PointerAnimation notifier,
  ) {
    return notifier.build(
      vsync: vsync,
    );
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

mixin PointerAnimationRef on AutoDisposeNotifierProviderRef<Animation<double>> {
  /// The parameter `vsync` of this provider.
  TickerProvider get vsync;
}

class _PointerAnimationProviderElement
    extends AutoDisposeNotifierProviderElement<PointerAnimation,
        Animation<double>> with PointerAnimationRef {
  _PointerAnimationProviderElement(super.provider);

  @override
  TickerProvider get vsync => (origin as PointerAnimationProvider).vsync;
}

String _$pointerIsMovingHash() => r'835c8beea2014703bea9af72bfbd9b246bf5cd1a';

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
String _$pointerOpacityHash() => r'20fb379b1a3b7db46eb9a12335bc3cee533ad6b1';

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
String _$pointerColorHash() => r'2a932c21f10c317d29204a849a0ce2c0b8311deb';

abstract class _$PointerColor extends BuildlessAutoDisposeNotifier<Color> {
  late final GazePointerType type;

  Color build({
    required GazePointerType type,
  });
}

/// See also [PointerColor].
@ProviderFor(PointerColor)
const pointerColorProvider = PointerColorFamily();

/// See also [PointerColor].
class PointerColorFamily extends Family<Color> {
  /// See also [PointerColor].
  const PointerColorFamily();

  /// See also [PointerColor].
  PointerColorProvider call({
    required GazePointerType type,
  }) {
    return PointerColorProvider(
      type: type,
    );
  }

  @override
  PointerColorProvider getProviderOverride(
    covariant PointerColorProvider provider,
  ) {
    return call(
      type: provider.type,
    );
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
  PointerColorProvider({
    required GazePointerType type,
  }) : this._internal(
          () => PointerColor()..type = type,
          from: pointerColorProvider,
          name: r'pointerColorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
  Color runNotifierBuild(
    covariant PointerColor notifier,
  ) {
    return notifier.build(
      type: type,
    );
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

String _$pointerSizeHash() => r'0a869ad6583a1631ee8d72b4dfda9e19dffa13bf';

abstract class _$PointerSize extends BuildlessAutoDisposeNotifier<double> {
  late final GazePointerType type;

  double build({
    required GazePointerType type,
  });
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
  PointerSizeProvider call({
    required GazePointerType type,
  }) {
    return PointerSizeProvider(
      type: type,
    );
  }

  @override
  PointerSizeProvider getProviderOverride(
    covariant PointerSizeProvider provider,
  ) {
    return call(
      type: provider.type,
    );
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
  PointerSizeProvider({
    required GazePointerType type,
  }) : this._internal(
          () => PointerSize()..type = type,
          from: pointerSizeProvider,
          name: r'pointerSizeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pointerSizeHash,
          dependencies: PointerSizeFamily._dependencies,
          allTransitiveDependencies:
              PointerSizeFamily._allTransitiveDependencies,
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
  double runNotifierBuild(
    covariant PointerSize notifier,
  ) {
    return notifier.build(
      type: type,
    );
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

String _$pointerOffsetHash() => r'7a1bdcac8bf969b231b19b7e0675b628782d7d86';

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
String _$pointerFixationPointHash() =>
    r'f46a0a2eda2db84cc179dc2eb436781c520f71d3';

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
String _$snapElementHash() => r'a111b876829fe178b4dc947c065cbeedf6ee9e84';

/// Gaze Pointer Snapping Point
///
/// Copied from [SnapElement].
@ProviderFor(SnapElement)
final snapElementProvider =
    NotifierProvider<SnapElement, GazeElementData?>.internal(
  SnapElement.new,
  name: r'snapElementProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$snapElementHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SnapElement = Notifier<GazeElementData?>;
String _$snappingStateHash() => r'a7a304f469bef13f422513f5a20d9f8bd68f2fce';

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
    r'cb3a8a4204caa0e05d5c01d3415317553325f5ba';

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
    r'1ccf0729b21b413d0e8070565d9424aa8c670b78';

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
    r'c44e590e846ae76f62162d00fdceede62c89c7a8';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
