import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_state.dart';
import '../keyboard_utility_buttons.dart';

class DeleteButton extends ConsumerWidget {
  DeleteButton({super.key, required this.state, required this.node});

  final GazeKeyboardState state;
  final FocusNode node;

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: selecting ? 'Select' : 'Character',
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
            },
    );
  }
}
