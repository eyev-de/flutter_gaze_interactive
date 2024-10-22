import 'package:flutter/cupertino.dart';

enum SoundVolume {
  val0(0, CupertinoIcons.speaker_slash),
  val3(3, CupertinoIcons.speaker),
  val5(5, CupertinoIcons.speaker_1),
  val7(7, CupertinoIcons.speaker_2),
  val10(10, CupertinoIcons.speaker_3);

  const SoundVolume(this.value, this.iconData);

  final int value;
  final IconData iconData;

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
