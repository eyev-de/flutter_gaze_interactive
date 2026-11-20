//  Gaze Interactive
//  Created by the eyeV app dev team.
//  Copyright eyeV GmbH. All rights reserved.

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'sound_type.enum.dart';
import 'sound_volume.enum.dart';

/// Runs async jobs strictly one after the other and never lets a failing job break the chain.
@visibleForTesting
class SerialJobQueue {
  Future<void> _tail = Future<void>.value();

  /// Completes when everything queued so far has finished.
  Future<void> get idle => _tail;

  /// Queues [job]; it starts after all earlier jobs finished. The result completes when [job] did, errors are swallowed (logged in debug).
  Future<void> run(Future<void> Function() job) {
    final done = _tail.then((_) async {
      try {
        await job();
      } catch (e) {
        debugPrint('SoundPlayerUtil: $e');
      }
    });
    _tail = done;
    return done;
  }
}

/// Index of the pool player after [current] (round robin).
@visibleForTesting
int nextPoolIndex(int current, int size) => (current + 1) % size;

/// One preloaded player of the pool with its own serial job queue, so platform calls for one player never interleave.
class _ClickPlayer {
  _ClickPlayer() {
    // The default FramePositionUpdater polls getCurrentPosition over the platform channel on every frame while playing - useless for a click.
    player.positionUpdater = null;
    queue.run(_configure);
  }

  final AudioPlayer player = AudioPlayer();
  final SerialJobQueue queue = SerialJobQueue();

  /// Source generation currently loaded into [player] (see [SoundPlayerUtil._generation]).
  int? loadedGeneration;

  /// Volume last sent to the platform for this player.
  double? volume;

  Future<void> _configure() async {
    // ReleaseMode.stop: after a click the native player rewinds itself and keeps the source loaded, so no seek() is needed for the next one.
    await player.setReleaseMode(ReleaseMode.stop);
    // Android: a key click must not request audio focus (an IPC per press) and thereby pause the user's music. Everything except the focus
    // equals the defaults audioplayers uses. Must happen before setSource (changing the context re-prepares a loaded source). Other platforms
    // are not touched, so nothing changes there.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await player.setAudioContext(AudioContext(android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.none)));
    }
  }

  Future<void> load(SoundType type, int generation) async {
    await player.setSource(AssetSource(type.source));
    loadedGeneration = generation;
  }
}

/// Plays the short keyboard click sounds with minimal latency.
///
/// A round-robin pool of [poolSize] preloaded players (default media player mode, no AudioPool / low latency mode) lets rapid presses overlap
/// instead of cutting each other off. A press picks the next player synchronously and chains its work (stop if still playing, resume) on that
/// player's own queue, so calls for one player never interleave. A sound type change reloads all players behind a generation counter; a press
/// queued behind a stale source is dropped instead of playing the wrong sound.
class SoundPlayerUtil {
  static const int poolSize = 4;

  static List<_ClickPlayer>? _pool;
  static int _next = 0;
  static SoundType? _type;

  /// Bumped on every sound type change; jobs of an older generation are dropped.
  static int _generation = 0;

  static List<_ClickPlayer> _ensurePool() {
    AudioCache.instance.prefix = '';
    return _pool ??= List.generate(poolSize, (_) => _ClickPlayer());
  }

  /// Makes [type] the current type and (re)loads all players when it changed. Synchronous part only, returns the pool.
  static List<_ClickPlayer> _prepare(SoundType type) {
    final pool = _ensurePool();
    if (_type != type) {
      _type = type;
      final generation = ++_generation;
      for (final p in pool) {
        p.queue.run(() => p.load(type, generation));
      }
    }
    return pool;
  }

  /// Preloads [type] so the first click doesn't pay the asset load/decode cost. Safe to call repeatedly; only reloads when the type changes.
  static Future<void> preload(SoundType type) async {
    final pool = _prepare(type);
    await Future.wait(pool.map((p) => p.queue.idle));
  }

  /// Plays one click. The returned future completes when the click was started (or dropped); callers on the press path must not await it.
  static Future<void> playClickSound(SoundVolume volume, SoundType type) {
    if (volume == SoundVolume.val0) return Future<void>.value();
    final pool = _prepare(type);
    final generation = _generation;
    final p = pool[_next];
    _next = nextPoolIndex(_next, pool.length);
    final normalizedVolume = volume.value / 10;
    return p.queue.run(() async {
      // The type changed after this press: the click would be the wrong sound.
      if (generation != _generation) return;
      // The initial load failed or was superseded: load once more rather than staying silent.
      if (p.loadedGeneration != generation) await p.load(type, generation);
      if (p.volume != normalizedVolume) {
        await p.player.setVolume(normalizedVolume);
        p.volume = normalizedVolume;
      }
      // Still ringing from an earlier press (the native completion that rewinds it has not arrived yet): stop() rewinds it, then restart.
      if (p.player.state == PlayerState.playing) await p.player.stop();
      await p.player.resume();
    });
  }
}
