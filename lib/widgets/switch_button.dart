//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../extensions.dart';
import 'button.dart';

class GazeSwitchButtonProperties {
  final bool toggled;
  final bool enabled;
  final Color disabledColor;
  final Color unToggledColor;
  final Color toggledColor;
  final EdgeInsets innerPadding;
  final Size size;
  final EdgeInsets margin;
  final String? route;
  GazeSwitchButtonProperties({
    required this.toggled,
    this.enabled = true,
    this.disabledColor = Colors.grey,
    this.unToggledColor = Colors.grey,
    this.toggledColor = Colors.blue,
    this.innerPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.size = const Size(80, 80),
    this.margin = const EdgeInsets.fromLTRB(15, 35, 15, 35),
    this.route,
  });
}

class GazeSwitchButton extends StatelessWidget {
  final GazeSwitchButtonProperties properties;
  final void Function(bool)? onToggled;
  GazeSwitchButton({
    Key? key,
    required this.properties,
    required this.onToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GazeButton(
      properties: GazeButtonProperties(
        key: GlobalKey(),
        innerPadding: const EdgeInsets.all(0),
        route: properties.route,
        child: AnimatedContainer(
          width: properties.size.width,
          height: properties.size.height,
          duration: const Duration(milliseconds: 300),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getColor(),
              width: 3,
            ),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: !properties.toggled ? math.pi / 2 : math.pi,
              end: !properties.toggled ? math.pi : math.pi / 2,
            ),
            curve: Curves.elasticInOut,
            duration: const Duration(milliseconds: 300),
            builder: (context, angle, child) => Transform.rotate(
              angle: angle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: properties.margin,
                decoration: BoxDecoration(color: _getColor(), borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ),
      ),
      onTap: properties.enabled
          ? () {
              if (onToggled != null) onToggled!(!properties.toggled);
            }
          : null,
    );
  }

  Color _getColor() {
    return properties.enabled
        ? properties.toggled
            ? properties.toggledColor
            : properties.unToggledColor
        : properties.disabledColor;
  }
}
