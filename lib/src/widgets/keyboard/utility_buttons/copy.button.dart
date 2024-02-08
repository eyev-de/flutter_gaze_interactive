import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class CopyButton extends GazeKeyboardUtilityButton {
  CopyButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      state: state,
      text: selecting ? 'Copy' : 'Copy All',
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: disabled ? Colors.grey : null),
      icon: Icons.copy,
      iconColor: disabled ? Colors.grey : null,
      gazeInteractive: disabled == false,
      route: state.route,
      // change selection state after copy of selection
      disablesSelection: true,
      onTap: disabled
          ? null
          : () => {
                node.requestFocus(),
                state.controller.copy(),
              },
    );
  }
}
