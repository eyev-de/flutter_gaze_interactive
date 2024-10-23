//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api.dart';
import '../../core/extensions.dart';

class GazeKeyboardUtilityButtons extends ConsumerWidget {
  GazeKeyboardUtilityButtons({super.key, required this.state, required this.node, this.type = KeyboardType.extended});

  final GazeKeyboardState state;
  final FocusNode node;
  final KeyboardType? type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return Row(
      children: [
        Flexible(child: SelectButton(state: state, node: node)),
        Flexible(child: MoveCursorLeftButton(state: state, node: node)),
        Flexible(child: MoveCursorRightButton(state: state, node: node)),
        if (state.onMoveCursorUp != null && state.type == KeyboardType.editor) Flexible(child: MoveCursorUpButton(state: state, node: node)),
        if (state.onMoveCursorDown != null && state.type == KeyboardType.editor) Flexible(child: MoveCursorDownButton(state: state, node: node)),
        Flexible(child: CopyButton(state: state, node: node, label: selecting ? 'Copy' : 'Copy All')),
        Flexible(child: PasteButton(state: state, node: node)),
        Flexible(child: CutButton(state: state, node: node, label: selecting ? 'Cut' : 'Cut All')),
        if (selecting)
          Flexible(flex: 2, child: DeleteButton(state: state, node: node, label: 'Select'))
        else ...[
          Flexible(child: DeleteButton(state: state, node: node)),
          Flexible(child: DeleteWordButton(state: state, node: node)),
        ]
      ],
    );
  }
}

// Gaze Keyboard Utility Buttons should be snapped to
// This includes (copy, cut, delete_all, delete_word, delete, move cursors, paste, select)
abstract class GazeKeyboardUtilityButton extends ConsumerWidget {
  const GazeKeyboardUtilityButton({super.key, required this.state, required this.node, required this.label, this.textStyle});

  final GazeKeyboardState state;
  final FocusNode node;
  final String? label;
  final TextStyle? textStyle;
}

class GazeKeyboardUtilityBaseButton extends ConsumerWidget {
  const GazeKeyboardUtilityBaseButton({
    super.key,
    required this.route,
    required this.icon,
    this.state,
    this.iconColor,
    this.text,
    this.textStyle,
    this.onTap,
    this.backgroundColor,
    this.innerPadding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.reselectable = false,
    this.horizontal = false,
    this.gazeInteractive = true,
  });

  final String route;
  final IconData icon;
  final GazeKeyboardState? state;

  final Color? iconColor;
  final String? text;
  final TextStyle? textStyle;
  final Function()? onTap;
  final Color? backgroundColor;
  final EdgeInsets innerPadding;
  final BorderRadius borderRadius;
  final bool reselectable;
  final bool horizontal;
  final bool gazeInteractive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabled = state == null ? false : ref.watch(state!.disableStateProvider);
    const double size = 20;
    final buttonColor = disabled ? disabledBaseButtonColor : backgroundColor ?? tealColor.disabled;
    final signColor = buttonColor.onColor(disabled: disabled);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: GazeButton(
        onTap: () => onTap?.call(), // should not be null -> avoid disabled state
        color: buttonColor,
        properties: GazeButtonProperties(
          route: route,
          withSound: true,
          reselectable: reselectable,
          borderRadius: borderRadius,
          innerPadding: innerPadding,
          gazeInteractive: gazeInteractive,
          direction: horizontal ? Axis.horizontal : Axis.vertical,
          icon: Icon(icon, color: iconColor ?? signColor, size: size),
          text: text != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: FittedBox(fit: BoxFit.fitHeight, child: Text(text!, style: textStyle?.copyWith(color: signColor))),
                )
              : null,
        ),
      ),
    );
  }
}
