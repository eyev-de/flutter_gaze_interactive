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
    final disabled = ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      state: state,
      text: label,
      gazeInteractive: clipboardContent != '' && disabled == false,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: clipboardContent != '' && disabled == false ? null : Colors.grey),
      icon: Icons.paste,
      iconColor: clipboardContent != '' && !disabled ? null : Colors.grey,
      route: state.route,
      // change selection state after paste when before selection
      disablesSelection: true,
      onTap: clipboardContent != '' && !disabled
          ? () async {
              node.requestFocus();
              await state.controller.paste();
            }
          : null,
    );
  }
}
