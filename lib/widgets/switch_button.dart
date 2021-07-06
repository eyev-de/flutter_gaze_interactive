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
  GazeSwitchButtonProperties({
    required this.toggled,
    this.enabled = true,
    this.disabledColor = Colors.grey,
    this.unToggledColor = Colors.grey,
    this.toggledColor = Colors.blue,
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
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          clipBehavior: Clip.antiAlias,
          width: 80,
          height: 80,
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
                margin: Theme.of(context).switchButtonPadding,
                decoration: BoxDecoration(color: _getColor(), borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          height: 80,
          child: GazeButton(
            properties: GazeButtonProperties(
              key: GlobalKey(),
              text: ' ',
            ),
            onTap: properties.enabled
                ? () {
                    if (onToggled != null) onToggled!(!properties.toggled);
                  }
                : null,
          ),
        ),
      ],
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
