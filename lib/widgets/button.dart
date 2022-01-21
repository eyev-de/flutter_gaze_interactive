//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'selection_animation.dart';

enum GazeButtonTapTypes { single, double }

class GazeButtonProperties {
  final GlobalKey key;
  final String? text;
  final Color textColor;
  final TextStyle? textStyle;
  final Icon? icon;
  final Color? borderColor;
  final Color backgroundColor;
  final EdgeInsets innerPadding;
  final BorderRadius borderRadius;
  final bool horizontal;
  final bool gazeInteractive;
  final String route;
  final Widget? child;
  final GazeButtonTapTypes tapType;
  final GazeSelectionAnimationType gazeSelectionAnimationType;
  final Color animationColor;
  GazeButtonProperties({
    required this.key,
    required this.route,
    this.text,
    this.textColor = Colors.white,
    this.textStyle,
    this.icon,
    this.borderColor,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.horizontal = false,
    this.innerPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.gazeInteractive = true,
    this.child,
    this.tapType = GazeButtonTapTypes.single,
    this.gazeSelectionAnimationType = GazeSelectionAnimationType.progress,
    this.animationColor = Colors.black,
  });
}

class GazeButton extends StatelessWidget {
  final GazeButtonProperties properties;
  final void Function()? onTap;
  GazeButton({required this.properties, this.onTap}) : super(key: properties.key);

  @override
  Widget build(BuildContext context) {
    return GazeSelectionAnimation(
      properties: GazeSelectionAnimationProperties(
        borderRadius: properties.borderRadius,
        backgroundColor: properties.backgroundColor,
        route: properties.route,
        gazeInteractive: properties.gazeInteractive,
        type: properties.gazeSelectionAnimationType,
        animationColor: properties.animationColor,
      ),
      wrappedKey: properties.key,
      wrappedWidget: _buildButton(context),
      onGazed: () {
        onTap?.call();
      },
    );
  }

  void Function()? _determineTap(GazeButtonTapTypes type) {
    if (properties.tapType == type) {
      return onTap;
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
      child: Container(
        padding: properties.innerPadding,
        decoration: BoxDecoration(
          borderRadius: properties.borderRadius,
          border: properties.borderColor != null
              ? Border.all(
                  color: properties.borderColor!,
                  width: 3,
                )
              : null,
        ),
        child: properties.child ?? (properties.horizontal ? _buildHorizontal(context) : _buildVertical(context)),
      ),
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (properties.icon != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: properties.icon,
              )
            ],
          ),
        if (properties.text != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _text(context),
            ],
          )
      ],
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    final _rightInnerPadding = properties.text == null ? 0.0 : 20.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (properties.icon != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, _rightInnerPadding, 0),
                child: properties.icon,
              )
            ],
          ),
        if (properties.text != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _text(context),
            ],
          )
      ],
    );
  }

  Widget _text(BuildContext context) {
    return Flexible(
      child: AutoSizeText(
        properties.text!,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: properties.textStyle ??
            TextStyle(
              color: properties.textColor,
              fontSize: Theme.of(context).primaryTextTheme.bodyText1!.fontSize,
            ),
      ),
    );
  }
}
