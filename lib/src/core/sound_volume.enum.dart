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
