import 'package:audioplayers/audioplayers.dart';

import 'sound_type.enum.dart';
import 'sound_volume.enum.dart';

class SoundPlayerUtil {
  static final player = AudioPlayer()..setSource(AssetSource(SoundType.typeWriter.source));

  static Future<void> playClickSound(SoundVolume volume, SoundType type) async {
    AudioCache.instance.prefix = '';
    if (volume == SoundVolume.val0) return;
    if (player.state == PlayerState.playing) await player.stop();
    await player.setVolume(volume.value / 10);
    await player.play(AssetSource(type.source));
  }
}
