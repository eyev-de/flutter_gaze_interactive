//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'button.dart';

class GazeSwitchButtonProperties {
  final bool initial;
  final bool enabled;

  final Color disabledColor;
  final Color unToggledColor;
  final Color toggledColor;
  final EdgeInsets innerPadding;
  final Size size;
  final EdgeInsets margin;
  final String route;
  GazeSwitchButtonProperties({
    required this.initial,
    this.enabled = true,
    this.disabledColor = Colors.grey,
    this.unToggledColor = Colors.grey,
    this.toggledColor = Colors.blue,
    this.innerPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.size = const Size(80, 80),
    this.margin = const EdgeInsets.fromLTRB(15, 35, 15, 35),
    this.route = '/',
  });
}

class GazeSwitchButton extends StatefulWidget {
  final GazeSwitchButtonProperties properties;
  final Future<bool> Function(bool)? onToggled;
  GazeSwitchButton({
    Key? key,
    required this.properties,
    required this.onToggled,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GazeSwitchButtonState();
}

class _GazeSwitchButtonState extends State<GazeSwitchButton> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  late Animation<double> animation;
  late bool toggled;

  _GazeSwitchButtonState();

  @override
  void initState() {
    super.initState();
    toggled = widget.properties.initial;
    animation = Tween<double>(begin: math.pi, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticInOut,
      ),
    );
    if (toggled) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GazeButton(
      properties: GazeButtonProperties(
        key: GlobalKey(),
        innerPadding: const EdgeInsets.all(0),
        route: widget.properties.route,
        child: AnimatedContainer(
          width: widget.properties.size.width,
          height: widget.properties.size.height,
          duration: const Duration(milliseconds: 300),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getColor(),
              width: 3,
            ),
          ),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.rotate(
              angle: animation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: widget.properties.margin,
                decoration: BoxDecoration(color: _getColor(), borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ),
      ),
      onTap: widget.properties.enabled
          ? () async {
              _toggle();
              if (widget.onToggled != null) {
                if (!await widget.onToggled!(toggled)) {
                  _toggle();
                }
              }
            }
          : null,
    );
  }

  void _toggle() {
    if (toggled) {
      controller.reverse();
    } else {
      controller.forward();
    }
    setState(() {
      toggled = !toggled;
    });
  }

  Color _getColor() {
    return widget.properties.enabled
        ? toggled
            ? widget.properties.toggledColor
            : widget.properties.unToggledColor
        : widget.properties.disabledColor;
  }
}
