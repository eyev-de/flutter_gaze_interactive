import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class DeleteButton extends GazeKeyboardUtilityButton {
  DeleteButton({super.key, required super.state, required super.node, super.label = 'Character'});

  late final controllerProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final wordSelected = ref.watch(state.selectingWordStateProvider);
    final disabled = (selecting && !wordSelected) || (ref.watch(controllerProvider) == '' || ref.watch(state.disableStateProvider));
    return GazeKeyboardUtilityBaseButton(
      text: label,
      textStyle: TextStyle(color: disabled ? Colors.grey : Colors.red),
      backgroundColor: Colors.grey.shade900,
      icon: CupertinoIcons.delete_left,
      iconColor: disabled ? Colors.grey : Colors.red,
      route: state.route,
      gazeInteractive: disabled == false,
      reselectable: true,
      onTap: disabled
          ? null
          : () {
              node.requestFocus();
              // If select mode is activated but no text is selected -> nothing is deleted
              if (selecting && state.controller.selection.textInside(state.controller.text).isEmpty) {
                return null;
              }
              final selection = state.controller.selection;
              if (state.controller.text.isNotEmpty) {
                var startIndex = selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
                final endIndex = selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;
                startIndex = selection.baseOffset == selection.extentOffset ? startIndex - 1 : startIndex;
                if (startIndex.isNegative) startIndex = 0;
                state.controller
                  ..text = state.controller.text.replaceRange(startIndex, endIndex, '')
                  ..selection = TextSelection.fromPosition(TextPosition(offset: startIndex));
              }
              ref.read(state.selectingWordStateProvider.notifier).state = state.controller.selection.textInside(state.controller.text).isNotEmpty;
            },
    );
  }
}
