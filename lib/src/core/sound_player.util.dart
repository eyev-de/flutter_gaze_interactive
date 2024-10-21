import 'package:audioplayers/audioplayers.dart';

final defaultClickSoundSource = AssetSource('packages/gaze_interactive/lib/assets/click.mp3');
final player = AudioPlayer()..setSource(defaultClickSoundSource);

enum SoundVolume {
  val0(0),
  val3(3),
  val5(5),
  val7(7),
  val10(10);

  const SoundVolume(this.value);

  final int value;

  static SoundVolume getDefault() => val5;

  static SoundVolume getByNumber(int num) {
    return switch (num) {
      0 => val0,
      3 => val3,
      5 => val5,
      7 => val7,
      10 => val10,
      _ => throw Exception('$num is not a sound level we support, just (0,3,5,7,10)'),
    };
  }
}

enum SoundType {
  // always for volume 3,5,7,10
  typeWriter(
    'Typewriter',
    'packages/gaze_interactive/lib/assets/click.mp3',
  ),
  laptopKeyboard('Laptop Keyboard', 'packages/gaze_interactive/lib/assets/space_click.m4a');

  const SoundType(this.name, this.source);

  final String source;
  final String name;

  static SoundType getByName(String name) {
    return switch (name) {
      'Typewriter' => SoundType.typeWriter,
      'Laptop Keyboard' => SoundType.laptopKeyboard,
      _ => throw Exception('$name is not a sound type we support, just ${SoundType.values.map((v) => v.name).join(',')}'),
    };
  }
}

class SoundPlayerUtil {
  static Future<void> playClickSound(SoundVolume volume, SoundType type) async {
    AudioCache.instance.prefix = '';
    if (volume == SoundVolume.val0) return;
    if (player.state == PlayerState.playing) await player.stop();
    await player.setVolume(volume.value / 10);
    await player.play(AssetSource(type.source));
  }
}
