import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class MoveCursorUpButton extends GazeKeyboardUtilityButton {
  MoveCursorUpButton({super.key, required super.state, required super.node, super.label = 'Cursor'});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_upward,
      iconColor: disabled ? Colors.grey : null,
      gazeInteractive: disabled == false,
      reselectable: true,
      route: state.route,
      text: label,
      textStyle: TextStyle(color: disabled ? Colors.grey : null),
      onTap: disabled
          ? null
          : () {
              node.requestFocus();
              if (state.onMoveCursorUp != null) state.onMoveCursorUp!(selecting: selecting);
              state.controller.moveCursorLeft(selecting: selecting);
            },
    );
  }
}
