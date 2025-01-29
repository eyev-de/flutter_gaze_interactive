import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/clipboard_provider.dart';

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
      iconColor: clipboardContent != '' && !disabled ? null : textDisabledColor,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: clipboardContent != '' && disabled == false ? null : textDisabledColor),
      onTap: clipboardContent != '' && !disabled
          ? () async {
              node.requestFocus();
              await state.controller.paste(state.inputFormatters, selecting: selecting);
              ref.read(state.selectingStateProvider.notifier).state = false;
              ref.read(state.selectingWordStateProvider.notifier).state = false;
            }
          : null,
    );
  }
}
