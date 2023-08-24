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
              node.requestFocus();
              if (state.controller.text[state.controller.text.length - 1] == ' ') {
                final words = state.controller.text.trim().split(r'[ \t\n\r]+');
                state.controller.text = '${words.sublist(0, words.length - 1).join(' ')} ';
              } else {
                final words = state.controller.text.split(r'[ \t\n\r]+');
                state.controller.text = words.sublist(0, words.length - 1).join(' ');
              }
              state.controller.moveCursorMostRight();
            },
    );
  }
}
