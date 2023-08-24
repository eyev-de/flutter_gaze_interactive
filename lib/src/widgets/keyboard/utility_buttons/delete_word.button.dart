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
    final text = ref.watch(controllerTextProvider);
    return GazeKeyboardUtilityBaseButton(
      text: 'Word',
      textStyle: TextStyle(color: text == '' ? Colors.grey : Colors.red),
      backgroundColor: Colors.grey.shade900,
      icon: CupertinoIcons.delete_left_fill,
      iconColor: text == '' ? Colors.grey : Colors.red,
      route: state.route,
      gazeInteractive: text != '',
      reselectable: true,
      onTap: text == ''
          ? null
          : () {
              final int oldOffset = state.controller.selection.base.offset;
              bool cursorAtMostExtend = false;
              int wordLength = 0;
              if (state.controller.text.length == oldOffset || state.controller.text.trim().length == oldOffset) {
                cursorAtMostExtend = true;
              }
              node.requestFocus();
              String text = state.controller.text;
              final originalTextLength = text.length;
              String rest = '';
              if (!cursorAtMostExtend) {
                text = state.controller.text.substring(0, oldOffset);
                rest = state.controller.text.substring(oldOffset, originalTextLength);
              }
              if (text[text.length - 1] == ' ') {
                final words = text.trim().split(' ');
                wordLength = words[words.length - 1].length + 1;
                state.controller.text = '${words.sublist(0, words.length - 1).join(' ')} ';
              } else {
                final words = text.split(' ');
                wordLength = words[words.length - 1].length;
                state.controller.text = words.sublist(0, words.length - 1).join(' ');
              }
              if (cursorAtMostExtend) {
                state.controller.moveCursorMostRight();
              } else {
                state.controller.text += rest;
                final int newOffset = oldOffset - wordLength;

                node.requestFocus();
                state.controller.selection = TextSelection.fromPosition(TextPosition(offset: newOffset));
              }
            },
    );
  }
}
