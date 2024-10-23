import 'package:flutter/cupertino.dart';

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

  IconData icon({bool active = false}) {
    return switch (this) {
      SoundVolume.val0 => active ? CupertinoIcons.speaker_slash_fill : CupertinoIcons.speaker_slash,
      SoundVolume.val3 => active ? CupertinoIcons.speaker_fill : CupertinoIcons.speaker,
      SoundVolume.val5 => active ? CupertinoIcons.speaker_1_fill : CupertinoIcons.speaker_1,
      SoundVolume.val7 => active ? CupertinoIcons.speaker_2_fill : CupertinoIcons.speaker_2,
      SoundVolume.val10 => active ? CupertinoIcons.speaker_3_fill : CupertinoIcons.speaker_3,
    };
  }
}
