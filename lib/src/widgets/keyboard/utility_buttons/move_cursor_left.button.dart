import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class MoveCursorLeftButton extends GazeKeyboardUtilityButton {
  MoveCursorLeftButton({super.key, required super.state, required super.node, super.label = 'Cursor'});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      reselectable: true,
      route: state.route,
      icon: Icons.arrow_back,
      iconColor: disabled ? Colors.grey : null,
      gazeInteractive: disabled == false,
      textStyle: TextStyle(color: disabled ? Colors.grey : null),
      onTap: disabled
          ? null
          : () {
              node.requestFocus();
              state.controller.moveCursorRight(selecting: selecting);
              ref.read(state.selectingWordStateProvider.notifier).state = state.controller.selection.textInside(state.controller.text).isNotEmpty;
            },
    );
  }
}
