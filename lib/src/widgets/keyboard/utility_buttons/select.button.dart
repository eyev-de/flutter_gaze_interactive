import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class SelectButton extends GazeKeyboardUtilityButton {
  SelectButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      backgroundColor: selecting ? Theme.of(context).primaryColor : Colors.grey.shade900,
      gazeInteractive: disabled == false,
      icon: MdiIcons.select,
      iconColor: disabled ? Colors.grey : null,
      text: label,
      textStyle: TextStyle(color: disabled ? Colors.grey : null),
      route: state.route,
      onTap: disabled
          ? null
          : () {
              node.requestFocus();
              // selection to no selection -> move cursor at the end
              if (selecting) {
                state.controller.selection = TextSelection(
                  baseOffset: state.controller.selection.extentOffset,
                  extentOffset: state.controller.selection.extentOffset,
                );
              }
              ref.read(state.selectingStateProvider.notifier).state = !selecting;
            },
    );
  }
}
