// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClipboardText)
final clipboardTextProvider = ClipboardTextProvider._();

final class ClipboardTextProvider extends $NotifierProvider<ClipboardText, String> {
  ClipboardTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clipboardTextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clipboardTextHash();

  @$internal
  @override
  ClipboardText create() => ClipboardText();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String>(value));
  }
}

String _$clipboardTextHash() => r'bffd9fce703d1fbd60126f19eaebf951931f5917';

abstract class _$ClipboardText extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
