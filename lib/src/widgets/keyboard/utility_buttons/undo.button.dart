import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class UndoButton extends GazeKeyboardUtilityButton {
  UndoButton({super.key, required super.state, required super.node, super.label = 'Undo', super.textStyle});

  late final undoControllerProvider =
      StateNotifierProvider((ref) => UndoHistoryControllerNotifier(controller: state.undoHistoryController ?? UndoHistoryController()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canUndo = ref.watch(undoControllerProvider);
    final selecting = ref.watch(state.selectingStateProvider);
    final disabled = ref.watch(state.disableStateProvider);
    final enable = selecting == false && canUndo == true && disabled == false;
    return GazeKeyboardUtilityBaseButton(
      text: label,
      route: state.route,
      gazeInteractive: enable == true,
      backgroundColor: Colors.grey.shade900,
      iconColor: enable == true ? Colors.white : Colors.grey,
      icon: Platform.isIOS ? CupertinoIcons.arrow_turn_up_left : Icons.undo,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: enable == true ? Colors.white : Colors.grey),
      onTap: enable == true ? () => {node.requestFocus(), state.undoHistoryController?.undo()} : null,
    );
  }
}
