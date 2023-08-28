import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../keyboard_utility_buttons.dart';

class MoveCursorLeftButton extends GazeKeyboardUtilityButton {
  const MoveCursorLeftButton({super.key, required super.state, required super.node}) : super(label: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_back,
      route: state.route,
      reselectable: true,
      onTap: () {
        node.requestFocus();
        state.controller.moveCursorRight(selecting: selecting);
      },
    );
  }
}
