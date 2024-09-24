import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/text_editing_controller_notifier.dart';

class MoveCursorUpButton extends GazeKeyboardUtilityButton {
  MoveCursorUpButton({super.key, required super.state, required super.node, super.label = 'Cursor'});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      route: state.route,
      reselectable: true,
      icon: Icons.arrow_upward,
      gazeInteractive: disabled == false,
      iconColor: disabled ? textDisabledColor : null,
      textStyle: TextStyle(color: disabled ? textDisabledColor : null),
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
