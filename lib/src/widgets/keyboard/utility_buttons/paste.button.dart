import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clipboard_provider.dart';
import '../../../core/extensions.dart';
import '../keyboard_utility_buttons.dart';

class PasteButton extends GazeKeyboardUtilityButton {
  const PasteButton({super.key, required super.state, required super.node, super.label = 'Paste', super.textStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final clipboardContent = ref.watch(clipboardProvider);
    final disabled = ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      state: state,
      icon: Icons.paste,
      route: state.route,
      gazeInteractive: clipboardContent != '' && disabled == false,
      iconColor: clipboardContent != '' && !disabled ? null : Colors.grey,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: clipboardContent != '' && disabled == false ? null : Colors.grey),
      onTap: clipboardContent != '' && !disabled
          ? () async {
              node.requestFocus();
              await state.controller.paste(selecting: selecting);
              ref.read(state.selectingStateProvider.notifier).state = false;
              ref.read(state.selectingWordStateProvider.notifier).state = false;
            }
          : null,
    );
  }
}
