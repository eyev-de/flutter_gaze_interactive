//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../button/button.dart';
import 'keyboard_state.dart';
import 'keyboards.dart';
import 'utility_buttons/copy.button.dart';
import 'utility_buttons/cut.button.dart';
import 'utility_buttons/delete.button.dart';
import 'utility_buttons/delete_word.button.dart';
import 'utility_buttons/move_cursor_down.button.dart';
import 'utility_buttons/move_cursor_left.button.dart';
import 'utility_buttons/move_cursor_right.button.dart';
import 'utility_buttons/move_cursor_up.button.dart';
import 'utility_buttons/paste.button.dart';
import 'utility_buttons/select.button.dart';

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
        Flexible(
          child: SelectButton(state: state, node: node),
        ),
        Flexible(
          child: MoveCursorLeftButton(state: state, node: node),
        ),
        Flexible(
          child: MoveCursorRightButton(state: state, node: node),
        ),
        if (state.onMoveCursorUp != null && state.type == KeyboardType.editor)
          Flexible(
            child: MoveCursorUpButton(state: state, node: node),
          ),
        if (state.onMoveCursorDown != null && state.type == KeyboardType.editor)
          Flexible(
            child: MoveCursorDownButton(state: state, node: node),
          ),
        Flexible(
          child: CopyButton(state: state, node: node),
        ),
        Flexible(
          child: PasteButton(state: state, node: node),
        ),
        Flexible(
          child: CutButton(state: state, node: node),
        ),
        if (selecting)
          Flexible(flex: 2, child: DeleteButton(state: state, node: node))
        else ...[
          Flexible(
            child: DeleteButton(state: state, node: node),
          ),
          Flexible(
            child: DeleteWordButton(state: state, node: node),
          ),
        ]
      ],
    );
  }
}

abstract class GazeKeyboardUtilityButton extends ConsumerWidget {
  const GazeKeyboardUtilityButton({super.key, required this.state, required this.node, required this.label, this.textStyle});

  final GazeKeyboardState state;
  final FocusNode node;
  final String? label;
  final TextStyle? textStyle;
}

class GazeKeyboardUtilityMoveCursorDownButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityMoveCursorDownButton({super.key, required super.state, required super.node}) : super(label: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_downward,
      route: state.route,
      onTap: () {
        node.requestFocus();
        if (state.onMoveCursorDown != null) {
          state.onMoveCursorDown!(selecting: selecting);
        }
      },
      reselectable: true,
    );
  }
}

class GazeKeyboardUtilityBaseButton extends StatelessWidget {
  const GazeKeyboardUtilityBaseButton({
    super.key,
    required this.route,
    required this.icon,
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
  Widget build(BuildContext context) {
    const double size = 20;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: GazeButton(
        onTap: onTap,
        properties: GazeButtonProperties(
          text: text,
          route: route,
          withSound: true,
          textStyle: textStyle,
          textColor: textStyle?.color ?? Colors.white,
          reselectable: reselectable,
          horizontal: horizontal,
          borderRadius: borderRadius,
          innerPadding: innerPadding,
          gazeInteractive: gazeInteractive,
          backgroundColor: backgroundColor ?? Colors.grey.shade900,
          icon: Icon(icon, color: iconColor ?? Colors.white, size: size),
          // Gaze Keyboard Utility Buttons should be snapped to
          // This includes (copy, cut, delete_all, delete_word, delete, move cursors, paste, select)
          snappable: true,
        ),
      ),
    );
  }
}
