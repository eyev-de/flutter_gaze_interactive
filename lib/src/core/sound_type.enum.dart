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
