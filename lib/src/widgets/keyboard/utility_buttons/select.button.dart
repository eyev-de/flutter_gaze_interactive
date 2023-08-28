import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../keyboard_utility_buttons.dart';

class SelectButton extends GazeKeyboardUtilityButton {
  const SelectButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      backgroundColor: selecting ? Theme.of(context).primaryColor : Colors.grey.shade900,
      icon: MdiIcons.select,
      route: state.route,
      onTap: () {
        node.requestFocus();
        ref.read(state.selectingStateProvider.notifier).state = !selecting;
      },
    );
  }
}
