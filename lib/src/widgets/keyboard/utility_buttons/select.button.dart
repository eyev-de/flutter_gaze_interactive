import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../api.dart';
import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';

class SelectButton extends GazeKeyboardUtilityButton {
  SelectButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);

    // Disable select button if text is empty
    ref.listen(controllerTextProvider, (prev, next) {
      if (next == '' && selecting) ref.read(state.selectingStateProvider.notifier).state = false;
    });

    final enabledColor = selecting ? tealColor : tealColor.disabled;
    final backgroundColor = disabled ? tealColor.disabled : enabledColor;
    return GazeKeyboardUtilityBaseButton(
      text: label,
      route: state.route,
      icon: MdiIcons.select,
      gazeInteractive: disabled == false,
      iconColor: backgroundColor.onColor(disabled: disabled),
      textStyle: TextStyle(color: backgroundColor.onColor(disabled: disabled)),
      backgroundColor: backgroundColor,
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
              ref.read(state.selectingWordStateProvider.notifier).state = state.controller.selection.textInside(state.controller.text).isNotEmpty;
            },
    );
  }
}
