import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../keyboard_utility_buttons.dart';

class MoveCursorDownButton extends GazeKeyboardUtilityButton {
  const MoveCursorDownButton({super.key, required super.state, required super.node}) : super(label: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_downward,
      reselectable: true,
      route: state.route,
      onTap: () {
        node.requestFocus();
        if (state.onMoveCursorDown != null) {
          state.onMoveCursorDown!(selecting: selecting);
        }
      },
    );
  }
}
