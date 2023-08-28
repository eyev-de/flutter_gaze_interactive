import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../keyboard_utility_buttons.dart';

class CopyButton extends GazeKeyboardUtilityButton {
  const CopyButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: selecting ? 'Copy' : 'Copy All',
      textStyle: textStyle,
      icon: Icons.copy,
      route: state.route,
      onTap: () {
        node.requestFocus();
        state.controller.copy();
      },
    );
  }
}
