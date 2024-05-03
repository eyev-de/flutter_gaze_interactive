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
    // disable selected letters after onTap is finished
    this.disablesSelection = false,
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
  final bool disablesSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double size = 20;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: GazeButton(
        onTap: () {
          onTap!.call();
          if (disablesSelection && state != null) {
            final selecting = ref.read(state!.selectingStateProvider);
            if (selecting) {
              state!.controller.selection = TextSelection(
                baseOffset: state!.controller.selection.extentOffset,
                extentOffset: state!.controller.selection.extentOffset,
              );
              ref.read(state!.selectingStateProvider.notifier).state = false;
            }
          }
        },
        color: backgroundColor ?? Colors.grey.shade900,
        properties: GazeButtonProperties(
          text: text != null ? Text(text!, style: textStyle) : null,
          route: route,
          withSound: true,
          reselectable: reselectable,
          direction: Axis.horizontal,
          borderRadius: borderRadius,
          innerPadding: innerPadding,
          gazeInteractive: gazeInteractive,
          icon: Icon(icon, color: iconColor ?? Colors.white, size: size),
          // Gaze Keyboard Utility Buttons should be snapped to
          // This includes (copy, cut, delete_all, delete_word, delete, move cursors, paste, select)
          snappable: true,
        ),
      ),
    );
  }
}
