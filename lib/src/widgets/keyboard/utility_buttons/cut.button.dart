import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/text_editing_controller_notifier.dart';

class CutButton extends GazeKeyboardUtilityButton {
  CutButton({super.key, required super.state, required super.node, super.label = 'Cut', super.textStyle});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final wordSelected = ref.watch(state.selectingWordStateProvider);
    final disabled = (selecting && !wordSelected) || ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      state: state,
      icon: Icons.cut,
      route: state.route,
      gazeInteractive: disabled == false,
      iconColor: disabled ? textDisabledColor : null,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: disabled ? textDisabledColor : null),
      onTap: disabled
          ? null
          : () {
              node.requestFocus();
              state.controller.cut();
            },
    );
  }
}
