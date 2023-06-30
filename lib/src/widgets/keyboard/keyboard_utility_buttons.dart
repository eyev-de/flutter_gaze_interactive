//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../core/extensions.dart';
import '../../core/responsive.dart';
import '../button/button.dart';
import 'keyboard_state.dart';

class GazeKeyboardUtilityButtons extends StatelessWidget {
  final GazeKeyboardState state;
  final FocusNode node;

  const GazeKeyboardUtilityButtons({super.key, required this.state, required this.node});

  @override
  Widget build(BuildContext context) {
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
    print('Building multiple times???');
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
    return GazeKeyboardUtilityBaseButton(
      text: label,
      textStyle: textStyle,
      icon: Icons.paste,
      route: state.route,
      onTap: () async {
        node.requestFocus();
        await state.controller.paste();
      },
    );
  }
}

class GazeKeyboardUtilityBaseButton extends StatelessWidget {
  final String route;
  final String? text;
  final TextStyle? textStyle;
  final IconData icon;
  final Function()? onTap;
  final Color? backgroundColor;
  final bool reselectable;

  const GazeKeyboardUtilityBaseButton({
    super.key,
    required this.route,
    required this.icon,
    this.textStyle,
    this.text,
    this.onTap,
    this.backgroundColor,
    this.reselectable = false,
  });

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
              size: Responsive.getResponsiveValue(
                forVeryLargeScreen: 35,
                forLargeScreen: 20,
                forMediumScreen: 18,
                context: context,
              ),
            ),
            route: route,
            withSound: true,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
