import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class MoveCursorRightButton extends GazeKeyboardUtilityButton {
  MoveCursorRightButton({super.key, required super.state, required super.node, super.label = 'Cursor'});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_forward,
      gazeInteractive: disabled == false,
      iconColor: disabled ? Colors.grey : null,
      route: state.route,
      reselectable: true,
      text: label,
      textStyle: TextStyle(color: disabled ? Colors.grey : null),
      onTap: disabled ? null : () => {node.requestFocus(), state.controller.moveCursorLeft(selecting: selecting)},
    );
  }
}
