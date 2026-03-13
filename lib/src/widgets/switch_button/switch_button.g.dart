// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_button.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SwitchButtonToggleWithDelay)
final switchButtonToggleWithDelayProvider = SwitchButtonToggleWithDelayFamily._();

final class SwitchButtonToggleWithDelayProvider extends $NotifierProvider<SwitchButtonToggleWithDelay, bool> {
  SwitchButtonToggleWithDelayProvider._({required SwitchButtonToggleWithDelayFamily super.from, required GlobalKey<State<StatefulWidget>> super.argument})
    : super(retry: null, name: r'switchButtonToggleWithDelayProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$switchButtonToggleWithDelayHash();

  @override
  String toString() {
    return r'switchButtonToggleWithDelayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SwitchButtonToggleWithDelay create() => SwitchButtonToggleWithDelay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is SwitchButtonToggleWithDelayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$switchButtonToggleWithDelayHash() => r'6313a962ad792833105f4ca96810703944bb8b64';

final class SwitchButtonToggleWithDelayFamily extends $Family
    with $ClassFamilyOverride<SwitchButtonToggleWithDelay, bool, bool, bool, GlobalKey<State<StatefulWidget>>> {
  SwitchButtonToggleWithDelayFamily._()
    : super(retry: null, name: r'switchButtonToggleWithDelayProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  SwitchButtonToggleWithDelayProvider call({required GlobalKey<State<StatefulWidget>> key}) => SwitchButtonToggleWithDelayProvider._(argument: key, from: this);

  @override
  String toString() => r'switchButtonToggleWithDelayProvider';
}

abstract class _$SwitchButtonToggleWithDelay extends $Notifier<bool> {
  late final _$args = ref.$arg as GlobalKey<State<StatefulWidget>>;
  GlobalKey<State<StatefulWidget>> get key => _$args;

  bool build({required GlobalKey<State<StatefulWidget>> key});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, () => build(key: _$args));
  }
}

@ProviderFor(SwitchButtonChanged)
final switchButtonChangedProvider = SwitchButtonChangedFamily._();

final class SwitchButtonChangedProvider extends $NotifierProvider<SwitchButtonChanged, bool?> {
  SwitchButtonChangedProvider._({required SwitchButtonChangedFamily super.from, required GlobalKey<State<StatefulWidget>> super.argument})
    : super(retry: null, name: r'switchButtonChangedProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$switchButtonChangedHash();

  @override
  String toString() {
    return r'switchButtonChangedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SwitchButtonChanged create() => SwitchButtonChanged();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is SwitchButtonChangedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$switchButtonChangedHash() => r'6f647605224b7827a5ffd198be9eae756c4ce8ca';

final class SwitchButtonChangedFamily extends $Family with $ClassFamilyOverride<SwitchButtonChanged, bool?, bool?, bool?, GlobalKey<State<StatefulWidget>>> {
  SwitchButtonChangedFamily._()
    : super(retry: null, name: r'switchButtonChangedProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  SwitchButtonChangedProvider call({required GlobalKey<State<StatefulWidget>> key}) => SwitchButtonChangedProvider._(argument: key, from: this);

  @override
  String toString() => r'switchButtonChangedProvider';
}

abstract class _$SwitchButtonChanged extends $Notifier<bool?> {
  late final _$args = ref.$arg as GlobalKey<State<StatefulWidget>>;
  GlobalKey<State<StatefulWidget>> get key => _$args;

  bool? build({required GlobalKey<State<StatefulWidget>> key});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool?, bool?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool?, bool?>, bool?, Object?, Object?>;
    element.handleCreate(ref, () => build(key: _$args));
  }
}
