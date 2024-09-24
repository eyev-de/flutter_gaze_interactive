import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/text_editing_controller_notifier.dart';

class MoveCursorRightButton extends GazeKeyboardUtilityButton {
  MoveCursorRightButton({super.key, required super.state, required super.node, super.label = 'Cursor'});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      route: state.route,
      reselectable: true,
      icon: Icons.arrow_forward,
      gazeInteractive: disabled == false,
      iconColor: disabled ? textDisabledColor : null,
      textStyle: TextStyle(color: disabled ? textDisabledColor : null),
      onTap: disabled
          ? null
          : () {
              node.requestFocus();
              state.controller.moveCursorLeft(selecting: selecting);
              ref.read(state.selectingWordStateProvider.notifier).state = state.controller.selection.textInside(state.controller.text).isNotEmpty;
            },
    );
  }
}
