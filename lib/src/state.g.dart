// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$buttonMaybePlaySoundHash() =>
    r'60568887b377b6e5ffbae511c651204bc3c1cf88';

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

/// See also [buttonMaybePlaySound].
@ProviderFor(buttonMaybePlaySound)
const buttonMaybePlaySoundProvider = ButtonMaybePlaySoundFamily();

/// See also [buttonMaybePlaySound].
class ButtonMaybePlaySoundFamily extends Family<AsyncValue<void>> {
  /// See also [buttonMaybePlaySound].
  const ButtonMaybePlaySoundFamily();

  /// See also [buttonMaybePlaySound].
  ButtonMaybePlaySoundProvider call({
    bool defaultVolume = false,
  }) {
    return ButtonMaybePlaySoundProvider(
      defaultVolume: defaultVolume,
    );
  }

  @override
  ButtonMaybePlaySoundProvider getProviderOverride(
    covariant ButtonMaybePlaySoundProvider provider,
  ) {
    return call(
      defaultVolume: provider.defaultVolume,
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
  String? get name => r'buttonMaybePlaySoundProvider';
}

/// See also [buttonMaybePlaySound].
class ButtonMaybePlaySoundProvider extends AutoDisposeFutureProvider<void> {
  /// See also [buttonMaybePlaySound].
  ButtonMaybePlaySoundProvider({
    bool defaultVolume = false,
  }) : this._internal(
          (ref) => buttonMaybePlaySound(
            ref as ButtonMaybePlaySoundRef,
            defaultVolume: defaultVolume,
          ),
          from: buttonMaybePlaySoundProvider,
          name: r'buttonMaybePlaySoundProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$buttonMaybePlaySoundHash,
          dependencies: ButtonMaybePlaySoundFamily._dependencies,
          allTransitiveDependencies:
              ButtonMaybePlaySoundFamily._allTransitiveDependencies,
          defaultVolume: defaultVolume,
        );

  ButtonMaybePlaySoundProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.defaultVolume,
  }) : super.internal();

  final bool defaultVolume;

  @override
  Override overrideWith(
    FutureOr<void> Function(ButtonMaybePlaySoundRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ButtonMaybePlaySoundProvider._internal(
        (ref) => create(ref as ButtonMaybePlaySoundRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        defaultVolume: defaultVolume,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ButtonMaybePlaySoundProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ButtonMaybePlaySoundProvider &&
        other.defaultVolume == defaultVolume;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, defaultVolume.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ButtonMaybePlaySoundRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `defaultVolume` of this provider.
  bool get defaultVolume;
}

class _ButtonMaybePlaySoundProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with ButtonMaybePlaySoundRef {
  _ButtonMaybePlaySoundProviderElement(super.provider);

  @override
  bool get defaultVolume =>
      (origin as ButtonMaybePlaySoundProvider).defaultVolume;
}

String _$snapActiveStateHash() => r'0ba78c6a0da56e78bf57e560e759113c94e72461';

/// See also [SnapActiveState].
@ProviderFor(SnapActiveState)
final snapActiveStateProvider =
    NotifierProvider<SnapActiveState, bool>.internal(
  SnapActiveState.new,
  name: r'snapActiveStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$snapActiveStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SnapActiveState = Notifier<bool>;
String _$snapIconStateHash() => r'9beed2dc0f83941f0875b87008af21cfe0f35ee0';

/// See also [SnapIconState].
@ProviderFor(SnapIconState)
final snapIconStateProvider = NotifierProvider<SnapIconState, bool>.internal(
  SnapIconState.new,
  name: r'snapIconStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$snapIconStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SnapIconState = Notifier<bool>;
String _$gazePointerAlwaysVisibleHash() =>
    r'5c00d0ee6c8ec9b094e12e1d1459227b1e09fd34';

/// See also [GazePointerAlwaysVisible].
@ProviderFor(GazePointerAlwaysVisible)
final gazePointerAlwaysVisibleProvider =
    NotifierProvider<GazePointerAlwaysVisible, bool>.internal(
  GazePointerAlwaysVisible.new,
  name: r'gazePointerAlwaysVisibleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gazePointerAlwaysVisibleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GazePointerAlwaysVisible = Notifier<bool>;
String _$gazePointerHistoryNumberHash() =>
    r'8872f13512cdbcaa4bd698272692384592b6ad70';

/// See also [GazePointerHistoryNumber].
@ProviderFor(GazePointerHistoryNumber)
final gazePointerHistoryNumberProvider =
    NotifierProvider<GazePointerHistoryNumber, int>.internal(
  GazePointerHistoryNumber.new,
  name: r'gazePointerHistoryNumberProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gazePointerHistoryNumberHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GazePointerHistoryNumber = Notifier<int>;
String _$keyboardSpeechToTextIsListeningHash() =>
    r'a83f38824105c6f822b7de5ee8b5f2b55d8a934e';

/// See also [KeyboardSpeechToTextIsListening].
@ProviderFor(KeyboardSpeechToTextIsListening)
final keyboardSpeechToTextIsListeningProvider =
    AutoDisposeNotifierProvider<KeyboardSpeechToTextIsListening, bool>.internal(
  KeyboardSpeechToTextIsListening.new,
  name: r'keyboardSpeechToTextIsListeningProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyboardSpeechToTextIsListeningHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyboardSpeechToTextIsListening = AutoDisposeNotifier<bool>;
String _$keyboardSpeechToTextAvailableHash() =>
    r'c3d280809930eebe3a6ff5b6826347c0108596e2';

/// See also [KeyboardSpeechToTextAvailable].
@ProviderFor(KeyboardSpeechToTextAvailable)
final keyboardSpeechToTextAvailableProvider =
    NotifierProvider<KeyboardSpeechToTextAvailable, AsyncValue<bool?>>.internal(
  KeyboardSpeechToTextAvailable.new,
  name: r'keyboardSpeechToTextAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyboardSpeechToTextAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyboardSpeechToTextAvailable = Notifier<AsyncValue<bool?>>;
String _$keyboardSpeechToTextStatusHash() =>
    r'2d8f951f703a51f31ec7c3345cd47c43e28fa2a1';

/// See also [KeyboardSpeechToTextStatus].
@ProviderFor(KeyboardSpeechToTextStatus)
final keyboardSpeechToTextStatusProvider = AutoDisposeNotifierProvider<
    KeyboardSpeechToTextStatus, KeyboardTextFieldStatus?>.internal(
  KeyboardSpeechToTextStatus.new,
  name: r'keyboardSpeechToTextStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyboardSpeechToTextStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyboardSpeechToTextStatus
    = AutoDisposeNotifier<KeyboardTextFieldStatus?>;
String _$keyboardSpeechToTextLocalesHash() =>
    r'540fffee052b22becae3048463367bf0bf36abc6';

/// See also [KeyboardSpeechToTextLocales].
@ProviderFor(KeyboardSpeechToTextLocales)
final keyboardSpeechToTextLocalesProvider = NotifierProvider<
    KeyboardSpeechToTextLocales, AsyncValue<List<LocaleName>>>.internal(
  KeyboardSpeechToTextLocales.new,
  name: r'keyboardSpeechToTextLocalesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyboardSpeechToTextLocalesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyboardSpeechToTextLocales = Notifier<AsyncValue<List<LocaleName>>>;
String _$keyboardSpeechToTextLocaleHash() =>
    r'29317a8fc5a0360bbf3c89a8dfb9751d814c08bf';

/// See also [KeyboardSpeechToTextLocale].
@ProviderFor(KeyboardSpeechToTextLocale)
final keyboardSpeechToTextLocaleProvider =
    NotifierProvider<KeyboardSpeechToTextLocale, String>.internal(
  KeyboardSpeechToTextLocale.new,
  name: r'keyboardSpeechToTextLocaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyboardSpeechToTextLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyboardSpeechToTextLocale = Notifier<String>;
String _$keyboardSpeechToTextHash() =>
    r'5b523dd7c07272b37d0c85a3c0b0a9d1b7c2ac86';

/// See also [KeyboardSpeechToText].
@ProviderFor(KeyboardSpeechToText)
final keyboardSpeechToTextProvider =
    NotifierProvider<KeyboardSpeechToText, SpeechToText>.internal(
  KeyboardSpeechToText.new,
  name: r'keyboardSpeechToTextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyboardSpeechToTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyboardSpeechToText = Notifier<SpeechToText>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
