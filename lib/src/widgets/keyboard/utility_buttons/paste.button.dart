import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clipboard_provider.dart';
import '../../../core/extensions.dart';
import '../keyboard_utility_buttons.dart';

class PasteButton extends GazeKeyboardUtilityButton {
  const PasteButton({super.key, required super.state, required super.node, super.label = 'Paste', super.textStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clipboardContent = ref.watch(clipboardProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: clipboardContent != '' ? Colors.white : Colors.grey),
      icon: Icons.paste,
      iconColor: clipboardContent != '' ? Colors.white : Colors.grey,
      route: state.route,
      onTap: clipboardContent != ''
          ? () async {
              node.requestFocus();
              await state.controller.paste();
            }
          : null,
    );
  }
}
