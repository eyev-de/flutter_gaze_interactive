//  Gaze Widgets Lib
//
//  Created by the eyeV App Dev Team.
//  Copyright © eyeV GmbH. All rights reserved.
//

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
    switch (type!) {
      case KeyboardType.editor:
        return Row(
          children: [
            GazeKeyboardUtilitySelectButton(state: state, node: node),
            GazeKeyboardUtilityMoveCursorLeftButton(state: state, node: node),
            GazeKeyboardUtilityMoveCursorRightButton(state: state, node: node),
            GazeKeyboardUtilityCopyButton(state: state, node: node),
            GazeKeyboardUtilityPasteButton(state: state, node: node),
            GazeKeyboardUtilityCutButton(state: state, node: node),
            GazeKeyboardUtilityDeleteButton(
              controller: state.controller,
              node: node,
              route: state.route,
              height: 80,
            ),
            GazeKeyboardUtilityDeleteWordButton(
              controller: state.controller,
              node: node,
              route: state.route,
              height: 80,
            ),
          ],
        );
      case KeyboardType.extended:
      case KeyboardType.speak:
        return Row(
          children: [
            GazeKeyboardUtilitySelectButton(state: state, node: node),
            GazeKeyboardUtilityMoveCursorLeftButton(state: state, node: node),
            GazeKeyboardUtilityMoveCursorRightButton(state: state, node: node),
            GazeKeyboardUtilityCopyButton(state: state, node: node),
            GazeKeyboardUtilityPasteButton(state: state, node: node),
            GazeKeyboardUtilityCutButton(state: state, node: node),
          ],
        );
    }
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
      icon: MdiIcons.select,
      route: state.route,
      onTap: () {
        node.requestFocus();
        ref.read(state.selectingStateProvider.notifier).state = !selecting;
      },
      backgroundColor: selecting ? Theme.of(context).primaryColor : Colors.grey.shade900,
      reselectable: false,
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
      onTap: () {
        node.requestFocus();
        state.controller.moveCursorRight(selecting: selecting);
      },
      reselectable: true,
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
      onTap: () {
        node.requestFocus();
        state.controller.moveCursorLeft(selecting: selecting);
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
      textStyle: textStyle?.copyWith(color: clipboardContent != '' ? Colors.white : Colors.grey),
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
  final TextEditingController controller;
  final FocusNode node;
  final double height;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: controller));

  GazeKeyboardUtilityDeleteButton({
    super.key,
    required this.controller,
    required this.node,
    required this.height,
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return SizedBox(
      height: height,
      child: GazeButton(
        properties: GazeButtonProperties(
          innerPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.grey.shade900,
          borderRadius: BorderRadius.zero,
          icon: Icon(
            Icons.keyboard_backspace_rounded,
            color: text == '' ? Colors.grey : Colors.white,
          ),
          horizontal: true,
          route: route,
          gazeInteractive: text != '',
          reselectable: true,
        ),
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
                  controller.text = controller.text.replaceRange(startIndex, endIndex, '');
                  controller.selection = TextSelection.fromPosition(TextPosition(offset: startIndex));
                }
              },
      ),
    );
  }
}

class GazeKeyboardUtilityDeleteAllButton extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode node;
  final double height;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: controller));

  GazeKeyboardUtilityDeleteAllButton({
    super.key,
    required this.controller,
    required this.node,
    required this.height,
    required this.route,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return SizedBox(
      height: height,
      child: GazeButton(
        properties: GazeButtonProperties(
          innerPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.grey.shade900,
          borderRadius: BorderRadius.zero,
          icon: Icon(
            Icons.delete,
            color: text == '' ? Colors.grey : Colors.red,
          ),
          horizontal: true,
          route: route,
          gazeInteractive: text != '',
        ),
        onTap: text == ''
            ? null
            : () {
                node.requestFocus();
                controller.text = '';
              },
      ),
    );
  }
}

class GazeKeyboardUtilityDeleteWordButton extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode node;
  final double height;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: controller));

  GazeKeyboardUtilityDeleteWordButton({
    super.key,
    required this.controller,
    required this.node,
    required this.height,
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return SizedBox(
      height: height,
      child: GazeButton(
        properties: GazeButtonProperties(
          text: 'Word',
          textColor: text == '' ? Colors.grey : Colors.red,
          innerPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.grey.shade900,
          borderRadius: BorderRadius.zero,
          icon: Icon(
            Icons.delete_sweep,
            color: text == '' ? Colors.grey : Colors.red,
          ),
          route: route,
          gazeInteractive: text != '',
          reselectable: true,
        ),
        onTap: text == ''
            ? null
            : () {
                node.requestFocus();
                if (controller.text[controller.text.length - 1] == ' ') {
                  final words = controller.text.trim().split(' ');
                  controller.text = '${words.sublist(0, words.length - 1).join(' ')} ';
                } else {
                  final words = controller.text.split(' ');
                  controller.text = words.sublist(0, words.length - 1).join(' ');
                }
                controller.moveCursorMostRight();
              },
      ),
    );
  }
}

class GazeKeyboardUtilityBaseButton extends StatelessWidget {
  final String route;
  final String? text;
  final TextStyle? textStyle;
  final IconData icon;
  final Color? iconColor;
  final Function()? onTap;
  final Color? backgroundColor;
  final bool reselectable;

  const GazeKeyboardUtilityBaseButton({
    super.key,
    required this.route,
    required this.icon,
    this.iconColor,
    this.textStyle,
    this.text,
    this.onTap,
    this.backgroundColor,
    this.reselectable = false,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 20;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: GazeButton(
          properties: GazeButtonProperties(
            text: text,
            textStyle: textStyle,
            innerPadding: const EdgeInsets.all(0),
            backgroundColor: backgroundColor ?? Colors.grey.shade900,
            borderRadius: BorderRadius.zero,
            reselectable: reselectable,
            icon: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: size,
            ),
            route: route,
            gazeInteractive: onTap != null,
            withSound: true,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
