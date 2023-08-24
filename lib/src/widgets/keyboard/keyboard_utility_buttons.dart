//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../core/clipboard_provider.dart';
import '../../core/extensions.dart';
import '../../core/text_editing_controller_notifier.dart';
import '../button/button.dart';
import 'keyboard_state.dart';
import 'keyboards.dart';

class GazeKeyboardUtilityButtons extends StatelessWidget {
  final GazeKeyboardState state;
  final FocusNode node;
  final KeyboardType? type;

  GazeKeyboardUtilityButtons({super.key, required this.state, required this.node, this.type = KeyboardType.extended});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: GazeKeyboardUtilitySelectButton(state: state, node: node),
        ),
        Flexible(
          child: GazeKeyboardUtilityMoveCursorLeftButton(state: state, node: node),
        ),
        if (state.onMoveCursorUp != null && state.type == KeyboardType.editor)
          Flexible(
            child: GazeKeyboardUtilityMoveCursorUpButton(state: state, node: node),
          ),
        if (state.onMoveCursorDown != null && state.type == KeyboardType.editor)
          Flexible(
            child: GazeKeyboardUtilityMoveCursorDownButton(state: state, node: node),
          ),
        Flexible(
          child: GazeKeyboardUtilityMoveCursorRightButton(state: state, node: node),
        ),
        Flexible(
          child: GazeKeyboardUtilityCopyButton(state: state, node: node),
        ),
        Flexible(
          child: GazeKeyboardUtilityPasteButton(state: state, node: node),
        ),
        Flexible(
          child: GazeKeyboardUtilityCutButton(state: state, node: node),
        ),
        Flexible(
          child: GazeKeyboardUtilityDeleteButton(controller: state.controller, node: node, route: state.route),
        ),
        Flexible(
          child: GazeKeyboardUtilityDeleteWordButton(controller: state.controller, node: node, route: state.route),
        ),
      ],
    );
  }
}

abstract class GazeKeyboardUtilityButton extends ConsumerWidget {
  final GazeKeyboardState state;
  final FocusNode node;
  final String? label;
  final TextStyle? textStyle;

  const GazeKeyboardUtilityButton({super.key, required this.state, required this.node, required this.label, this.textStyle});
}

class GazeKeyboardUtilitySelectButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilitySelectButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

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

class GazeKeyboardUtilityMoveCursorLeftButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityMoveCursorLeftButton({super.key, required super.state, required super.node}) : super(label: '');

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

class GazeKeyboardUtilityMoveCursorRightButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityMoveCursorRightButton({super.key, required super.state, required super.node}) : super(label: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_forward,
      route: state.route,
      reselectable: true,
      onTap: () {
        node.requestFocus();
        state.controller.moveCursorLeft(selecting: selecting);
      },
    );
  }
}

class GazeKeyboardUtilityMoveCursorUpButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityMoveCursorUpButton({super.key, required super.state, required super.node}) : super(label: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_upward,
      route: state.route,
      onTap: () {
        node.requestFocus();
        if (state.onMoveCursorUp != null) {
          state.onMoveCursorUp!(selecting: selecting);
        }
        state.controller.moveCursorLeft(selecting: selecting);
      },
      reselectable: true,
    );
  }
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

class GazeKeyboardUtilityCopyButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityCopyButton({super.key, required super.state, super.label, required super.node, super.textStyle});

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

class GazeKeyboardUtilityCutButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityCutButton({super.key, required super.state, required super.node, super.label, super.textStyle});

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

class GazeKeyboardUtilityPasteButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityPasteButton({super.key, required super.state, required super.node, super.label = 'Paste', super.textStyle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clipboardContent = ref.watch(clipboardProvider);
    return GazeKeyboardUtilityBaseButton(
      text: label,
      textStyle: (textStyle ?? const TextStyle()).copyWith(color: clipboardContent != '' ? Colors.white : Colors.grey),
      icon: Icons.paste,
      iconColor: clipboardContent != '' ? Colors.white : Colors.grey,
      route: state.route,
      onTap: clipboardContent != ''
          ? () async {
              node.requestFocus();
              await state.controller.paste();
            }
          : null,
    );
  }
}

// class GazeKeyboardUtilityDeleteButton extends GazeKeyboardUtilityButton {
//   const GazeKeyboardUtilityDeleteButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selecting = ref.watch(state.selectingStateProvider);
//     return GazeKeyboardUtilityBaseButton(
//       icon: Icons.delete,
//       iconColor: Colors.red,
//       text: 'Delete All',
//       textStyle: const TextStyle(color: Colors.red),
//       route: state.route,
//       onTap: () {
//         node.requestFocus();
//         state.controller.text = '';
//       },
//       backgroundColor: selecting ? Theme.of(context).primaryColor : Colors.grey.shade900,
//     );
//   }
// }

// class GazeKeyboardUtilityDeleteWordButton extends GazeKeyboardUtilityButton {
//   const GazeKeyboardUtilityDeleteWordButton({super.key, required super.state, required super.node, super.label = 'Select', super.textStyle});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selecting = ref.watch(state.selectingStateProvider);
//     return GazeKeyboardUtilityBaseButton(
//       icon: Icons.delete_sweep,
//       iconColor: Colors.red,
//       text: 'Delete Word',
//       textStyle: const TextStyle(color: Colors.red),
//       route: state.route,
//       onTap: () {
//         node.requestFocus();
//         if (state.controller.text[state.controller.text.length - 1] == ' ') {
//           final words = state.controller.text.trim().split(' ');
//           state.controller.text = '${words.sublist(0, words.length - 1).join(' ')} ';
//         } else {
//           final words = state.controller.text.split(' ');
//           state.controller.text = words.sublist(0, words.length - 1).join(' ');
//         }
//         state.controller.moveCursorMostRight();
//       },
//       backgroundColor: selecting ? Theme.of(context).primaryColor : Colors.grey.shade900,
//     );
//   }
// }

class GazeKeyboardUtilityDeleteButton extends ConsumerWidget {
  GazeKeyboardUtilityDeleteButton({super.key, required this.controller, required this.node, required this.route});

  final TextEditingController controller;
  final FocusNode node;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return GazeKeyboardUtilityBaseButton(
      text: 'Character',
      textStyle: TextStyle(color: text == '' ? Colors.grey : Colors.red),
      backgroundColor: Colors.grey.shade900,
      icon: CupertinoIcons.delete_left,
      iconColor: text == '' ? Colors.grey : Colors.red,
      route: route,
      gazeInteractive: text != '',
      reselectable: true,
      onTap: text == ''
          ? null
          : () {
              node.requestFocus();
              final selection = controller.selection;
              if (controller.text.isNotEmpty) {
                var startIndex = selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
                final endIndex = selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;
                startIndex = selection.baseOffset == selection.extentOffset ? startIndex - 1 : startIndex;
                if (startIndex.isNegative) startIndex = 0;
                controller
                  ..text = controller.text.replaceRange(startIndex, endIndex, '')
                  ..selection = TextSelection.fromPosition(TextPosition(offset: startIndex));
              }
            },
    );
  }
}

class GazeKeyboardUtilityDeleteAllButton extends ConsumerWidget {
  GazeKeyboardUtilityDeleteAllButton({super.key, required this.controller, required this.node, required this.route});

  final TextEditingController controller;
  final FocusNode node;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return GazeKeyboardUtilityBaseButton(
      backgroundColor: Colors.grey.shade800,
      icon: Icons.delete,
      iconColor: text == '' ? Colors.grey : Colors.red,
      horizontal: true,
      route: route,
      gazeInteractive: text != '',
      onTap: text == ''
          ? null
          : () {
              node.requestFocus();
              controller.text = '';
            },
    );
  }
}

class GazeKeyboardUtilityDeleteWordButton extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode node;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: controller));

  GazeKeyboardUtilityDeleteWordButton({
    super.key,
    required this.controller,
    required this.node,
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return GazeKeyboardUtilityBaseButton(
      text: 'Word',
      textStyle: TextStyle(color: text == '' ? Colors.grey : Colors.red),
      backgroundColor: Colors.grey.shade900,
      icon: CupertinoIcons.delete_left_fill,
      iconColor: text == '' ? Colors.grey : Colors.red,
      route: route,
      gazeInteractive: text != '',
      reselectable: true,
      onTap: text == ''
          ? null
          : () {
              final int oldOffset = controller.selection.base.offset;
              bool cursorAtMostExtend = false;
              int wordLength = 0;
              if (controller.text.length == oldOffset || controller.text.trim().length == oldOffset) {
                cursorAtMostExtend = true;
              }
              node.requestFocus();
              String text = controller.text;
              int originalTextLength = text.length;
              String rest = '';
              if (!cursorAtMostExtend) {
                text = controller.text.substring(0, oldOffset);
                rest = controller.text.substring(oldOffset, originalTextLength);
              }
              if (text[text.length - 1] == ' ') {
                final words = text.trim().split(' ');
                wordLength = words[words.length - 1].length + 1;
                controller.text = '${words.sublist(0, words.length - 1).join(' ')} ';
              } else {
                final words = text.split(' ');
                wordLength = words[words.length - 1].length;
                controller.text = words.sublist(0, words.length - 1).join(' ');
              }
              if (cursorAtMostExtend) {
                controller.moveCursorMostRight();
              } else {
                controller.text += rest;
                final int newOffset = oldOffset - wordLength;

                node.requestFocus();
                controller.selection = TextSelection.fromPosition(TextPosition(offset: newOffset));
              }
            },
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
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
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
        ),
      ),
    );
  }
}
