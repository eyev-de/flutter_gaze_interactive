//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

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
  final MainAxisAlignment horizontalAlignment;
  final MainAxisAlignment verticalAlignment;
  final bool gazeInteractive;
  final String route;
  final Widget? child;
  final GazeButtonTapTypes tapType;
  final GazeSelectionAnimationType gazeSelectionAnimationType;
  final Color animationColor;
  final bool reselectable;
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
    this.horizontalAlignment = MainAxisAlignment.center,
    this.verticalAlignment = MainAxisAlignment.center,
    this.innerPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.gazeInteractive = true,
    this.child,
    this.tapType = GazeButtonTapTypes.single,
    this.gazeSelectionAnimationType = GazeSelectionAnimationType.progress,
    this.animationColor = Colors.black,
    this.reselectable = false,
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
        borderRadius: properties.borderRadius,
        backgroundColor: properties.backgroundColor,
        route: properties.route,
        gazeInteractive: properties.gazeInteractive,
        type: properties.gazeSelectionAnimationType,
        animationColor: properties.animationColor,
        reselectable: properties.reselectable,
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
    return null;
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
        padding: properties.child != null ? null : properties.innerPadding,
        decoration: properties.child != null
            ? null
            : BoxDecoration(
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
      mainAxisAlignment: properties.verticalAlignment,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (properties.icon != null)
          Row(
            mainAxisAlignment: properties.horizontalAlignment,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
          Column(
            mainAxisAlignment: properties.verticalAlignment,
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
      child: Text(
        properties.text!,
        textAlign: TextAlign.center,
        // maxLines: 1,
        style: properties.textStyle ??
            TextStyle(
              color: properties.textColor,
              fontSize: Theme.of(context).primaryTextTheme.bodyText1!.fontSize,
            ),
      ),
    );
  }
}
