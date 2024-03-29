import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/text_editing_controller_notifier.dart';

class DeleteWordButton extends ConsumerWidget {
  DeleteWordButton({super.key, required this.state, required this.node});

  final GazeKeyboardState state;
  final FocusNode node;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabled = ref.watch(controllerTextProvider) == '' || ref.watch(state.disableStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: 'Word',
      textStyle: TextStyle(color: disabled ? Colors.grey : Colors.red),
      backgroundColor: Colors.grey.shade900,
      icon: CupertinoIcons.delete_left_fill,
      iconColor: disabled ? Colors.grey : Colors.red,
      route: state.route,
      gazeInteractive: disabled == false,
      reselectable: true,
      onTap: disabled
          ? null
          : () {
              node.requestFocus();
              final selection = state.controller.selection;
              final textBefore = state.controller.selection.textBefore(state.controller.text);
              // Check if the cursor is next to nothing, at the beginning of the text -> do nothing
              if (textBefore.isEmpty) {
                return;
              }
              // Check if the cursor is next to a space, break or tab -> remove only one character
              if (textBefore[textBefore.length - 1].contains(RegExp(r'\s+'))) {
                var startIndex = selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
                final endIndex = selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;
                startIndex = selection.baseOffset == state.controller.selection.extentOffset ? startIndex - 1 : startIndex;
                if (startIndex.isNegative) startIndex = 0;
                state.controller
                  ..text = state.controller.text.replaceRange(startIndex, endIndex, '')
                  ..selection = TextSelection.fromPosition(TextPosition(offset: startIndex));
                return;
              }
              // Identify the word to be deleted -> remove word
              final word = textBefore.trim().split(RegExp(r'\s+')).last;
              state.controller
                ..text = state.controller.text.replaceRange(selection.baseOffset - word.length, selection.baseOffset, '')
                ..selection = TextSelection.fromPosition(TextPosition(offset: selection.baseOffset - word.length));
            },
    );
  }
}
