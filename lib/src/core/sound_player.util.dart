import 'package:audioplayers/audioplayers.dart';

import 'sound_type.enum.dart';
import 'sound_volume.enum.dart';

final defaultClickSoundSource = AssetSource('packages/gaze_interactive/lib/assets/click.mp3');
final player = AudioPlayer()..setSource(defaultClickSoundSource);

class SoundPlayerUtil {
  static Future<void> playClickSound(SoundVolume volume, SoundType type) async {
    AudioCache.instance.prefix = '';
    if (volume == SoundVolume.val0) return;
    if (player.state == PlayerState.playing) await player.stop();
    await player.setVolume(volume.value / 10);
    await player.play(AssetSource(type.source));
  }
}
