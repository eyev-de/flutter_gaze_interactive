import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../keyboard_utility_buttons.dart';

class MoveCursorUpButton extends GazeKeyboardUtilityButton {
  const MoveCursorUpButton({super.key, required super.state, required super.node}) : super(label: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_upward,
      reselectable: true,
      route: state.route,
      onTap: () {
        node.requestFocus();
        if (state.onMoveCursorUp != null) {
          state.onMoveCursorUp!(selecting: selecting);
        }
        state.controller.moveCursorLeft(selecting: selecting);
      },
    );
  }
}
