import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class CutButton extends GazeKeyboardUtilityButton {
  CutButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: selecting ? 'Cut' : 'Cut All',
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: disabled ? Colors.grey : null),
      icon: Icons.cut,
      iconColor: disabled ? Colors.grey : null,
      gazeInteractive: disabled == false,
      route: state.route,
      onTap: disabled
          ? null
          : () => {
                node.requestFocus(),
                state.controller.cut(),
                // change selection state after cut of selection
                if (selecting)
                  {
                    state.controller.selection = TextSelection(
                      baseOffset: state.controller.selection.extentOffset,
                      extentOffset: state.controller.selection.extentOffset,
                    ),
                    ref.read(state.selectingStateProvider.notifier).state = false,
                  }
              },
    );
  }
}
