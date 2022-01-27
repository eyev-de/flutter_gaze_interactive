//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'button.dart';

class GazeSwitchButtonState extends ChangeNotifier {
  bool _toggled;
  bool get toggled => _toggled;
  set toggled(bool value) {
    if (value != _toggled) {
      _toggled = value;
      notifyListeners();
    }
  }

  GazeSwitchButtonState({required bool toggled}) : _toggled = toggled;
}

class GazeSwitchButtonProperties {
  final bool enabled;

  final Color disabledColor;
  final Color unToggledColor;
  final Color toggledColor;
  final EdgeInsets innerPadding;
  final Size size;
  final EdgeInsets margin;
  final String route;
  final GazeSwitchButtonState state;
  GazeSwitchButtonProperties({
    required this.state,
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
  late Animation<double> animation = Tween<double>(begin: math.pi, end: math.pi / 2).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    ),
  );

  _GazeSwitchButtonState();

  @override
  void initState() {
    super.initState();
    if (widget.properties.state.toggled) {
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
    return ChangeNotifierProvider.value(
      value: widget.properties.state,
      builder: (context, child) => Consumer<GazeSwitchButtonState>(
        builder: (context, _state, child) => GazeButton(
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
                  color: _getColor(_state.toggled),
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
                    decoration: BoxDecoration(color: _getColor(_state.toggled), borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
            ),
          ),
          onTap: widget.properties.enabled
              ? () async {
                  _toggle(_state.toggled);
                  if (widget.onToggled != null) {
                    if (!await widget.onToggled!(widget.properties.state.toggled)) {
                      _toggle(_state.toggled);
                    }
                  }
                }
              : null,
        ),
      ),
    );
  }

  void _toggle(bool toggled) {
    if (toggled) {
      controller.reverse();
    } else {
      controller.forward();
    }
    widget.properties.state.toggled = !toggled;
  }

  Color _getColor(bool toggled) {
    return widget.properties.enabled
        ? toggled
            ? widget.properties.toggledColor
            : widget.properties.unToggledColor
        : widget.properties.disabledColor;
  }
}
