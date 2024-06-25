// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$switchButtonToggleWithDelayHash() =>
    r'6313a962ad792833105f4ca96810703944bb8b64';

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

abstract class _$SwitchButtonToggleWithDelay
    extends BuildlessAutoDisposeNotifier<bool> {
  late final GlobalKey<State<StatefulWidget>> key;

  bool build({
    required GlobalKey<State<StatefulWidget>> key,
  });
}

/// See also [SwitchButtonToggleWithDelay].
@ProviderFor(SwitchButtonToggleWithDelay)
const switchButtonToggleWithDelayProvider = SwitchButtonToggleWithDelayFamily();

/// See also [SwitchButtonToggleWithDelay].
class SwitchButtonToggleWithDelayFamily extends Family<bool> {
  /// See also [SwitchButtonToggleWithDelay].
  const SwitchButtonToggleWithDelayFamily();

  /// See also [SwitchButtonToggleWithDelay].
  SwitchButtonToggleWithDelayProvider call({
    required GlobalKey<State<StatefulWidget>> key,
  }) {
    return SwitchButtonToggleWithDelayProvider(
      key: key,
    );
  }

  @override
  SwitchButtonToggleWithDelayProvider getProviderOverride(
    covariant SwitchButtonToggleWithDelayProvider provider,
  ) {
    return call(
      key: provider.key,
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
  String? get name => r'switchButtonToggleWithDelayProvider';
}

/// See also [SwitchButtonToggleWithDelay].
class SwitchButtonToggleWithDelayProvider
    extends AutoDisposeNotifierProviderImpl<SwitchButtonToggleWithDelay, bool> {
  /// See also [SwitchButtonToggleWithDelay].
  SwitchButtonToggleWithDelayProvider({
    required GlobalKey<State<StatefulWidget>> key,
  }) : this._internal(
          () => SwitchButtonToggleWithDelay()..key = key,
          from: switchButtonToggleWithDelayProvider,
          name: r'switchButtonToggleWithDelayProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$switchButtonToggleWithDelayHash,
          dependencies: SwitchButtonToggleWithDelayFamily._dependencies,
          allTransitiveDependencies:
              SwitchButtonToggleWithDelayFamily._allTransitiveDependencies,
          key: key,
        );

  SwitchButtonToggleWithDelayProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final GlobalKey<State<StatefulWidget>> key;

  @override
  bool runNotifierBuild(
    covariant SwitchButtonToggleWithDelay notifier,
  ) {
    return notifier.build(
      key: key,
    );
  }

  @override
  Override overrideWith(SwitchButtonToggleWithDelay Function() create) {
    return ProviderOverride(
      origin: this,
      override: SwitchButtonToggleWithDelayProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SwitchButtonToggleWithDelay, bool>
      createElement() {
    return _SwitchButtonToggleWithDelayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SwitchButtonToggleWithDelayProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SwitchButtonToggleWithDelayRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `key` of this provider.
  GlobalKey<State<StatefulWidget>> get key;
}

class _SwitchButtonToggleWithDelayProviderElement
    extends AutoDisposeNotifierProviderElement<SwitchButtonToggleWithDelay,
        bool> with SwitchButtonToggleWithDelayRef {
  _SwitchButtonToggleWithDelayProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>> get key =>
      (origin as SwitchButtonToggleWithDelayProvider).key;
}

String _$switchButtonChangedHash() =>
    r'8837df6211634879324e30b49a4d436067993107';

abstract class _$SwitchButtonChanged
    extends BuildlessAutoDisposeNotifier<bool?> {
  late final GlobalKey<State<StatefulWidget>> key;

  bool? build({
    required GlobalKey<State<StatefulWidget>> key,
  });
}

/// See also [SwitchButtonChanged].
@ProviderFor(SwitchButtonChanged)
const switchButtonChangedProvider = SwitchButtonChangedFamily();

/// See also [SwitchButtonChanged].
class SwitchButtonChangedFamily extends Family<bool?> {
  /// See also [SwitchButtonChanged].
  const SwitchButtonChangedFamily();

  /// See also [SwitchButtonChanged].
  SwitchButtonChangedProvider call({
    required GlobalKey<State<StatefulWidget>> key,
  }) {
    return SwitchButtonChangedProvider(
      key: key,
    );
  }

  @override
  SwitchButtonChangedProvider getProviderOverride(
    covariant SwitchButtonChangedProvider provider,
  ) {
    return call(
      key: provider.key,
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
  String? get name => r'switchButtonChangedProvider';
}

/// See also [SwitchButtonChanged].
class SwitchButtonChangedProvider
    extends AutoDisposeNotifierProviderImpl<SwitchButtonChanged, bool?> {
  /// See also [SwitchButtonChanged].
  SwitchButtonChangedProvider({
    required GlobalKey<State<StatefulWidget>> key,
  }) : this._internal(
          () => SwitchButtonChanged()..key = key,
          from: switchButtonChangedProvider,
          name: r'switchButtonChangedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$switchButtonChangedHash,
          dependencies: SwitchButtonChangedFamily._dependencies,
          allTransitiveDependencies:
              SwitchButtonChangedFamily._allTransitiveDependencies,
          key: key,
        );

  SwitchButtonChangedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final GlobalKey<State<StatefulWidget>> key;

  @override
  bool? runNotifierBuild(
    covariant SwitchButtonChanged notifier,
  ) {
    return notifier.build(
      key: key,
    );
  }

  @override
  Override overrideWith(SwitchButtonChanged Function() create) {
    return ProviderOverride(
      origin: this,
      override: SwitchButtonChangedProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SwitchButtonChanged, bool?>
      createElement() {
    return _SwitchButtonChangedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SwitchButtonChangedProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SwitchButtonChangedRef on AutoDisposeNotifierProviderRef<bool?> {
  /// The parameter `key` of this provider.
  GlobalKey<State<StatefulWidget>> get key;
}

class _SwitchButtonChangedProviderElement
    extends AutoDisposeNotifierProviderElement<SwitchButtonChanged, bool?>
    with SwitchButtonChangedRef {
  _SwitchButtonChangedProviderElement(super.provider);

  @override
  GlobalKey<State<StatefulWidget>> get key =>
      (origin as SwitchButtonChangedProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
