//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../extensions.dart';
import '../button/button.dart';
import 'state.dart';

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
        GazeKeyboardUtilityCutButton(state: state, node: node),
        GazeKeyboardUtilityPasteButton(state: state, node: node),
        const Spacer(flex: 3),
      ],
    );
  }
}

abstract class GazeKeyboardUtilityButton extends StatelessWidget {
  final GazeKeyboardState state;
  final FocusNode node;
  final String label;
  const GazeKeyboardUtilityButton({super.key, required this.state, required this.node, required this.label});
}

class GazeKeyboardUtilitySelectButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilitySelectButton({super.key, required super.state, required super.node, super.label = 'Select'});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: GazeButton(
          properties: GazeButtonProperties(
            text: label,
            innerPadding: const EdgeInsets.all(0),
            backgroundColor: state.selecting ? Theme.of(context).primaryColor : Colors.grey.shade900,
            borderRadius: BorderRadius.zero,
            icon: const Icon(
              MdiIcons.select,
              color: Colors.white,
            ),
            route: state.route,
          ),
          onTap: () {
            node.requestFocus();
            state.selecting = !state.selecting;
          },
        ),
      ),
    );
  }
}

class GazeKeyboardUtilityMoveCursorLeftButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityMoveCursorLeftButton({super.key, required super.state, required super.node}) : super(label: '');
  @override
  Widget build(BuildContext context) {
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_back,
      route: state.route,
      onTap: () {
        node.requestFocus();
        state.controller.moveCursorRight(selecting: state.selecting);
      },
    );
  }
}

class GazeKeyboardUtilityMoveCursorRightButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityMoveCursorRightButton({super.key, required super.state, required super.node}) : super(label: '');

  @override
  Widget build(BuildContext context) {
    return GazeKeyboardUtilityBaseButton(
      icon: Icons.arrow_forward,
      route: state.route,
      onTap: () {
        node.requestFocus();
        state.controller.moveCursorLeft(selecting: state.selecting);
      },
    );
  }
}

class GazeKeyboardUtilityCopyButton extends GazeKeyboardUtilityButton {
  const GazeKeyboardUtilityCopyButton({super.key, required super.state, required super.node, super.label = 'Copy'});

  @override
  Widget build(BuildContext context) {
    return GazeKeyboardUtilityBaseButton(
      text: label,
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
  const GazeKeyboardUtilityCutButton({super.key, required super.state, required super.node, super.label = 'Cut'});

  @override
  Widget build(BuildContext context) {
    return GazeKeyboardUtilityBaseButton(
      text: label,
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
  const GazeKeyboardUtilityPasteButton({super.key, required super.state, required super.node, super.label = 'Paste'});

  @override
  Widget build(BuildContext context) {
    return GazeKeyboardUtilityBaseButton(
      text: label,
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
  final IconData icon;
  final Function()? onTap;

  const GazeKeyboardUtilityBaseButton({
    super.key,
    required this.route,
    required this.icon,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: GazeButton(
          properties: GazeButtonProperties(
            text: text,
            innerPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.grey.shade900,
            borderRadius: BorderRadius.zero,
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            route: route,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
