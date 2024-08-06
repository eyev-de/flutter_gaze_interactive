import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class CopyButton extends GazeKeyboardUtilityButton {
  CopyButton({super.key, required super.state, required super.node, super.label = 'Copy', super.textStyle});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      state: state,
      icon: Icons.copy,
      route: state.route,
      gazeInteractive: disabled == false,
      iconColor: disabled ? Colors.grey : null,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: disabled ? Colors.grey : null),
      disablesSelection: true, // change selection state after copy of selection
      onTap: disabled ? null : () => {node.requestFocus(), state.controller.copy()},
    );
  }
}
