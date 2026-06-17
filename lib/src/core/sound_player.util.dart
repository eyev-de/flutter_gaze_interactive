//  Gaze Interactive
//  Created by the eyeV app dev team.
//  Copyright eyeV GmbH. All rights reserved.

import 'package:audioplayers/audioplayers.dart';

import 'sound_type.enum.dart';
import 'sound_volume.enum.dart';

/// Plays the short keyboard click sounds with minimal latency.
///
/// A single [AudioPlayer] keeps its source preloaded, so a click only costs a
/// `seek(0)` + `resume()` round-trip instead of the previous
/// stop → setVolume → play chain — the old `play(AssetSource(...))` re-loaded
/// and decoded the asset on every press, which was the main source of click
/// latency. The source and volume are only re-sent to the platform when they
/// actually change.
class SoundPlayerUtil {
  // ReleaseMode.stop keeps the decoded source loaded after a click finishes,
  // so the next click can just seek+resume instead of re-loading the asset.
  static final AudioPlayer player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  static SoundType? _loadedType;
  static double? _loadedVolume;

  /// Preloads [type] so the first click doesn't pay the asset load/decode cost.
  /// Safe to call repeatedly; only (re)loads when the type changes.
  static Future<void> preload(SoundType type) async {
    AudioCache.instance.prefix = '';
    if (_loadedType == type) return;
    _loadedType = type;
    await player.setSource(AssetSource(type.source));
  }

  static Future<void> playClickSound(SoundVolume volume, SoundType type) async {
    if (volume == SoundVolume.val0) return;

    await preload(type);

    final normalizedVolume = volume.value / 10;
    if (_loadedVolume != normalizedVolume) {
      _loadedVolume = normalizedVolume;
      await player.setVolume(normalizedVolume);
    }

    // Restart from the beginning so rapid presses re-trigger the click, then
    // resume — no stop() and no asset reload needed.
    await player.seek(Duration.zero);
    await player.resume();
  }
}
