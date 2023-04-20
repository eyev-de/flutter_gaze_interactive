//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../state.dart';
import 'selection_animation.dart';

enum GazeButtonTapTypes { single, double }

class GazeButtonProperties {
  final String? text;
  final Color textColor;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  final Icon? icon;

  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  final Color backgroundColor;
  final EdgeInsets innerPadding;
  final bool horizontal;

  final MainAxisAlignment horizontalAlignment;
  final MainAxisAlignment verticalAlignment;

  final bool gazeInteractive;
  final String route;
  final Widget? child;
  final GazeButtonTapTypes tapType;
  final GazeSelectionAnimationType gazeSelectionAnimationType;
  final Color animationColor;
  final bool reselectable;
  final bool withSound;
  GazeButtonProperties({
    this.route = '/',
    this.text,
    this.textColor = Colors.white,
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.icon,
    this.borderColor,
    this.borderWidth = 3,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.horizontal = false,
    this.horizontalAlignment = MainAxisAlignment.center,
    this.verticalAlignment = MainAxisAlignment.center,
    this.innerPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.gazeInteractive = true,
    this.child,
    this.tapType = GazeButtonTapTypes.single,
    this.gazeSelectionAnimationType = GazeSelectionAnimationType.progress,
    this.animationColor = Colors.black,
    this.reselectable = false,
    this.withSound = false,
  });
}

class GazeButton extends StatelessWidget {
  final GazeButtonProperties properties;
  final void Function()? onTap;
  GazeButton({Key? key, required this.properties, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GazeSelectionAnimation(
      properties: GazeSelectionAnimationProperties(
        route: properties.route,
        borderRadius: properties.borderRadius,
        borderWidth: properties.borderWidth,
        backgroundColor: properties.backgroundColor,
        gazeInteractive: properties.gazeInteractive,
        type: properties.gazeSelectionAnimationType,
        animationColor: properties.animationColor,
        reselectable: properties.reselectable,
      ),
      wrappedKey: GlobalKey(),
      wrappedWidget: _buildButton(context),
      onGazed: _tap(),
    );
  }

  void Function()? _determineTap(GazeButtonTapTypes type) {
    if (properties.tapType == type) {
      return _tap();
    }
    return null;
  }

  void Function()? _tap() {
    if (onTap != null) unawaited(_maybePlaySound());
    return onTap;
  }

  Future<void> _maybePlaySound() async {
    if (properties.withSound) {
      if (player.state == PlayerState.playing) await player.stop();
      await player.play(clickSoundSource);
    }
  }

  Widget _buildButton(BuildContext context) {
    return InkWell(
      borderRadius: properties.borderRadius,
      hoverColor: properties.textColor.withAlpha(20),
      splashColor: properties.textColor.withAlpha(60),
      focusColor: properties.textColor.withAlpha(20),
      highlightColor: properties.textColor.withAlpha(20),
      onTap: _determineTap(GazeButtonTapTypes.single),
      onDoubleTap: _determineTap(GazeButtonTapTypes.double),
      child: AnimatedContainer(
        padding: properties.child != null ? null : properties.innerPadding,
        decoration: properties.child != null
            ? null
            : BoxDecoration(
                borderRadius: properties.borderRadius,
                border: properties.borderColor != null
                    ? Border.all(
                        color: properties.borderColor!,
                        width: properties.borderWidth,
                      )
                    : null,
              ),
        duration: const Duration(milliseconds: 150),
        child: properties.child ?? (properties.horizontal ? _buildHorizontal(context) : _buildVertical(context)),
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
    final rightInnerPadding = properties.text == null ? 0.0 : 20.0;
    return Row(
      mainAxisAlignment: properties.horizontalAlignment,
      children: [
        if (properties.icon != null)
          Column(
            mainAxisAlignment: properties.verticalAlignment,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, rightInnerPadding, 0),
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
      child: Text(
        properties.text!,
        textAlign: properties.textAlign,
        // maxLines: 1,
        style: properties.textStyle ??
            TextStyle(
              color: properties.textColor,
              fontSize: Theme.of(context).primaryTextTheme.bodyLarge!.fontSize,
            ),
      ),
    );
  }
}
