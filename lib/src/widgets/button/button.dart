//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../state.dart';
import 'selection_animation.dart';

enum GazeButtonTapTypes { single, double }

class GazeButtonProperties {
  GazeButtonProperties({
    required this.route,
    this.text,
    this.icon,
    this.borderColor,
    this.borderWidth = 3,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.horizontal = false,
    this.horizontalAlignment = MainAxisAlignment.center,
    this.verticalAlignment = MainAxisAlignment.center,
    this.innerPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.iconPadding,
    this.gazeInteractive = true,
    this.tapType = GazeButtonTapTypes.single,
    this.gazeSelectionAnimationType = GazeSelectionAnimationType.progress,
    this.animationColor = Colors.black,
    this.reselectable = false,
    this.reselectableCount,
    this.withSound = false,
    this.snappable = true,
  });

  final Text? text;
  final Icon? icon;
  final EdgeInsets? iconPadding;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final EdgeInsets innerPadding;
  final bool horizontal;
  final MainAxisAlignment horizontalAlignment;
  final MainAxisAlignment verticalAlignment;
  final bool gazeInteractive;
  final String route;
  final GazeButtonTapTypes tapType;
  final GazeSelectionAnimationType gazeSelectionAnimationType;
  final Color animationColor;
  final bool reselectable;
  final bool snappable;
  final bool withSound;
  final int? reselectableCount;
}

class GazeButton extends StatelessWidget {
  GazeButton({super.key, required this.properties, this.child, this.color = Colors.transparent, this.onTap})
      : assert(
          (child == null || properties.text == null) && (child == null || properties.icon == null),
          'You cannot specify a child widget as well as a text or icon. The child widget replaces all previously specified properties',
        );

  final GazeButtonProperties properties;
  final Widget? child;
  final Color color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GazeSelectionAnimation(
      onGazed: _tap,
      wrappedKey: GlobalKey(),
      wrappedWidget: _buildButton(context),
      properties: GazeSelectionAnimationProperties(
        backgroundColor: color,
        route: properties.route,
        borderRadius: properties.borderRadius,
        borderWidth: properties.borderWidth,
        gazeInteractive: properties.gazeInteractive,
        type: properties.gazeSelectionAnimationType,
        animationColor: properties.animationColor,
        reselectable: properties.reselectable,
        reselectableCount: properties.reselectableCount,
        snappable: properties.snappable,
      ),
    );
  }

  void Function()? _determineTap(GazeButtonTapTypes type) {
    if (properties.tapType == type && onTap != null) {
      return _tap;
    }
    return null;
  }

  void _tap() {
    if (onTap != null) unawaited(_maybePlaySound());
    return onTap?.call();
  }

  Future<void> _maybePlaySound() async {
    if (properties.withSound) {
      if (player.state == PlayerState.playing) await player.stop();
      await player.play(clickSoundSource);
    }
  }

  Widget _buildButton(BuildContext context) {
    final textColor = properties.text?.style?.color ?? Colors.white;
    return InkWell(
      borderRadius: properties.borderRadius,
      hoverColor: textColor.withAlpha(20),
      splashColor: textColor.withAlpha(60),
      focusColor: textColor.withAlpha(20),
      highlightColor: textColor.withAlpha(20),
      onTap: _determineTap(GazeButtonTapTypes.single),
      onDoubleTap: _determineTap(GazeButtonTapTypes.double),
      child: child != null
          ? AnimatedContainer(duration: const Duration(milliseconds: 150), child: child)
          : AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: properties.innerPadding,
              decoration: BoxDecoration(
                borderRadius: properties.borderRadius,
                border: properties.borderColor != null ? Border.all(color: properties.borderColor!, width: properties.borderWidth) : null,
              ),
              child: properties.horizontal ? _buildHorizontal(context) : _buildVertical(context),
            ),
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Column(
      mainAxisAlignment: properties.verticalAlignment,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (properties.icon != null)
          Row(
            mainAxisAlignment: properties.horizontalAlignment,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, properties.text != null ? 10 : 0),
                child: properties.icon,
              )
            ],
          ),
        if (properties.text != null)
          Row(
            mainAxisAlignment: properties.horizontalAlignment,
            mainAxisSize: MainAxisSize.min,
            children: [
              _text(context),
            ],
          )
      ],
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    // final rightInnerPadding = properties.text == null ? 0.0 : 20.0;
    final iconPadding = properties.iconPadding ?? (properties.text == null ? const EdgeInsets.all(0) : const EdgeInsets.fromLTRB(0, 0, 20, 0));

    return Row(
      mainAxisAlignment: properties.horizontalAlignment,
      children: [
        if (properties.icon != null)
          Column(
            mainAxisAlignment: properties.verticalAlignment,
            children: [
              Container(
                padding: iconPadding,
                child: properties.icon,
              )
            ],
          ),
        if (properties.text != null)
          Flexible(
            child: Column(
              mainAxisAlignment: properties.verticalAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                _text(context),
              ],
            ),
          ),
      ],
    );
  }

  Widget _text(BuildContext context) {
    return Flexible(
      child: DefaultTextStyle.merge(
        style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
        child: properties.text!,
      ),
    );
  }
}
