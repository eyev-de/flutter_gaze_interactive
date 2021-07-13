//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../state.dart';
import 'button_wrapper.dart';

class GazeButtonProperties {
  final Key? key;
  final int id;
  final bool selected;
  final String? text;
  final Color textColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? iconColor;
  final Color? borderColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets innerPadding;
  final BorderRadius borderRadius;
  final bool horizontal;
  final bool gazeInteractive;
  final Color? color;
  final String? route;
  final Widget? child;
  GazeButtonProperties({
    this.key,
    this.id = 0,
    this.selected = true,
    this.text,
    this.textColor = Colors.white,
    this.textStyle,
    this.icon,
    this.iconColor,
    this.borderColor,
    this.backgroundColor = Colors.transparent,
    this.width = 220.0,
    this.height = 60.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.horizontal = false,
    this.padding = const EdgeInsets.all(0),
    this.innerPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.gazeInteractive = true,
    this.color,
    this.route,
    this.child,
  });
}

class GazeButton extends StatelessWidget {
  final GazeButtonProperties properties;
  final GlobalKey gazeInteractiveKey = GlobalKey();
  final void Function()? onTap;
  GazeButton({required this.properties, this.onTap}) : super(key: properties.key);

  @override
  Widget build(BuildContext context) {
    if (properties.gazeInteractive) {
      return Container(
        padding: properties.padding,
        child: GazeButtonWrapper(
          properties: GazeButtonWrapperProperties(
            borderRadius: properties.borderRadius,
            route: properties.route,
          ),
          gazeInteractive: GazeInteractive(),
          wrappedKey: gazeInteractiveKey,
          wrappedWidget: _buildButton(context),
          onGazed: () {
            if (onTap != null) onTap!();
          },
        ),
      );
    }
    return Container(
      padding: properties.padding,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Material(
      color: properties.selected ? properties.backgroundColor : Colors.transparent,
      borderRadius: properties.borderRadius,
      child: InkWell(
        borderRadius: properties.borderRadius,
        hoverColor: properties.textColor.withAlpha(20),
        splashColor: properties.textColor.withAlpha(60),
        focusColor: properties.textColor.withAlpha(20),
        highlightColor: properties.textColor.withAlpha(20),
        onTap: onTap,
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
      ),
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (properties.iconColor != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Icon(
                  properties.icon,
                  color: properties.iconColor,
                  size: 30,
                ),
              )
            ],
          ),
        if (properties.text != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
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
              ),
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
        if (properties.iconColor != Colors.transparent)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, _rightInnerPadding, 0),
                child: Icon(
                  properties.icon,
                  color: properties.iconColor,
                  size: 35,
                ),
              )
            ],
          ),
        if (properties.text != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
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
              ),
            ],
          )
      ],
    );
  }
}
