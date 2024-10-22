import 'package:flutter/cupertino.dart';

enum SoundVolume {
  val0(0, Icon(CupertinoIcons.speaker_slash)),
  val3(3, Icon(CupertinoIcons.speaker)),
  val5(5, Icon(CupertinoIcons.speaker_1)),
  val7(7, Icon(CupertinoIcons.speaker_2)),
  val10(10, Icon(CupertinoIcons.speaker_3));

  const SoundVolume(this.value, this.icon);

  final int value;
  final Icon icon;

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
