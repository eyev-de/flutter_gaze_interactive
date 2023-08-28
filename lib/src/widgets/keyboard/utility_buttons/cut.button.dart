import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions.dart';
import '../keyboard_utility_buttons.dart';

class CutButton extends GazeKeyboardUtilityButton {
  const CutButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      text: selecting ? 'Cut' : 'Cut All',
      textStyle: textStyle,
      icon: Icons.cut,
      route: state.route,
      onTap: () {
        node.requestFocus();
        state.controller.cut();
      },
    );
  }
}
