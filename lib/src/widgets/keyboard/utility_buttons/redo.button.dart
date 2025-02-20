import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/text_editing_controller_notifier.dart';

class RedoButton extends GazeKeyboardUtilityButton {
  RedoButton({super.key, required super.state, required super.node, super.label = 'Redo', super.textStyle});

  late final redoControllerProvider =
      StateNotifierProvider((ref) => RedoHistoryControllerNotifier(controller: state.undoHistoryController ?? UndoHistoryController()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canRedo = ref.watch(redoControllerProvider);
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(state.disableStateProvider);
    final enable = selecting == false && canRedo == true && disabled == false;
    return GazeKeyboardUtilityBaseButton(
      text: label,
      route: state.route,
      gazeInteractive: enable == true,
      iconColor: enable == true ? Colors.white : textDisabledColor,
      icon: Platform.isIOS || Platform.isMacOS ? CupertinoIcons.arrow_turn_up_right : Icons.redo,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: enable == true ? Colors.white : textDisabledColor),
      onTap: enable == true ? () => {node.requestFocus(), state.undoHistoryController?.redo()} : null,
    );
  }
}
