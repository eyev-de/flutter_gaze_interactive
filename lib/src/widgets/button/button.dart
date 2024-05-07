//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../state.dart';
import 'button_selection_animation.dart';

enum GazeButtonTapTypes { single, double }

class GazeButtonProperties {
  GazeButtonProperties({
    required this.route,
    this.text,
    this.icon,
    this.iconPadding,
    this.borderColor,
    this.borderWidth = 3,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.innerPadding = const EdgeInsets.all(20),
    this.direction = Axis.vertical,
    this.alignment = Alignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.gazeInteractive = true,
    this.tapType = GazeButtonTapTypes.single,
    this.gazeSelectionAnimationType = GazeSelectionAnimationType.progress,
    this.animationColor = Colors.black,
    this.reselectableCount,
    this.reselectable = false,
    this.withSound = false,
    this.snappable = true,
  });

  final String route;
  final Text? text;
  final Icon? icon;
  final EdgeInsets? iconPadding;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final EdgeInsets innerPadding;
  final Axis direction;
  final Alignment alignment;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool gazeInteractive;
  final GazeButtonTapTypes tapType;
  final GazeSelectionAnimationType gazeSelectionAnimationType;
  final Color animationColor;
  final int? reselectableCount;
  final bool reselectable;
  final bool snappable;
  final bool withSound;
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
    final disabledColor = color == Colors.transparent ? color : color.withOpacity(0.3);
    return GazeSelectionAnimation(
      onGazed: onTap != null ? () => {unawaited(_maybePlaySound()), onTap!()} : null,
      wrappedKey: GlobalKey(),
      wrappedWidget: _Button(properties: properties, onTap: onTap != null ? () => {unawaited(_maybePlaySound()), onTap!()} : null, child: child),
      properties: GazeSelectionAnimationProperties(
        backgroundColor: onTap != null ? color : disabledColor,
        route: properties.route,
        borderRadius: properties.borderRadius,
        borderWidth: properties.borderWidth,
        gazeInteractive: onTap != null && properties.gazeInteractive,
        type: properties.gazeSelectionAnimationType,
        animationColor: properties.animationColor,
        reselectable: properties.reselectable,
        reselectableCount: properties.reselectableCount,
        snappable: properties.snappable,
      ),
    );
  }

  Future<void> _maybePlaySound() async {
    if (properties.withSound == false) return;
    if (player.state == PlayerState.playing) await player.stop();
    await player.play(clickSoundSource);
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.properties, required this.onTap, required this.child});

  final GazeButtonProperties properties;
  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final textColor = properties.text?.style?.color ?? Colors.white;
    final disabled = onTap != null;
    return InkWell(
      borderRadius: properties.borderRadius,
      hoverColor: textColor.withAlpha(20),
      focusColor: textColor.withAlpha(20),
      splashColor: textColor.withAlpha(60),
      highlightColor: textColor.withAlpha(20),
      splashFactory: disabled ? null : NoSplash.splashFactory,
      onTap: disabled && properties.tapType == GazeButtonTapTypes.single ? onTap : null,
      onDoubleTap: disabled && properties.tapType == GazeButtonTapTypes.double ? onTap : null,
      child: child != null
          ? AnimatedContainer(duration: const Duration(milliseconds: 150), child: child)
          : AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: properties.innerPadding,
              decoration: BoxDecoration(
                borderRadius: properties.borderRadius,
                border: properties.borderColor != null
                    ? Border.all(
                        color: disabled ? properties.borderColor! : properties.borderColor!.withOpacity(0.3),
                        width: properties.borderWidth,
                      )
                    : null,
              ),
              child: _ButtonChild(properties: properties),
            ),
    );
  }
}

class _ButtonChild extends StatelessWidget {
  const _ButtonChild({required this.properties});

  final GazeButtonProperties properties;

  @override
  Widget build(BuildContext context) {
    final padding = properties.text == null
        ? EdgeInsets.zero
        : EdgeInsets.only(right: properties.direction == Axis.horizontal ? 10 : 0, bottom: properties.direction == Axis.vertical ? 5 : 0);
    return Align(
      alignment: properties.alignment,
      child: Flex(
        direction: properties.direction,
        mainAxisAlignment: properties.mainAxisAlignment,
        crossAxisAlignment: properties.crossAxisAlignment,
        children: [
          if (properties.icon != null) Padding(padding: properties.iconPadding ?? padding, child: properties.icon),
          if (properties.text != null)
            DefaultTextStyle.merge(
              style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
              child: properties.text!,
            )
        ],
      ),
    );
  }
}
