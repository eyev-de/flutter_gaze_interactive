import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

enum SoundType {
  // always for volume 3,5,7,10
  typeWriter('Typewriter'),
  laptopKeyboard('Laptop Keyboard');

  const SoundType(this.name);

  final String name;

  static SoundType getByName(String name) {
    return switch (name) {
      'Typewriter' => SoundType.typeWriter,
      'Laptop Keyboard' => SoundType.laptopKeyboard,
      _ => throw Exception('$name is not a sound type we support, just ${SoundType.values.map((v) => v.name).join(',')}'),
    };
  }

  String get source {
    return switch (this) {
      SoundType.typeWriter => 'packages/gaze_interactive/lib/assets/click.mp3',
      SoundType.laptopKeyboard => 'packages/gaze_interactive/lib/assets/space_click.m4a',
    };
  }

  IconData icon() {
    return switch (this) {
      SoundType.typeWriter => MdiIcons.typewriter,
      SoundType.laptopKeyboard => MdiIcons.keyboard,
    };
  }
}
