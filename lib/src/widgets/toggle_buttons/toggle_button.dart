import 'package:flutter/material.dart';

import '../../../api.dart';
import '../../core/extensions.dart';

class GazeToggleButton {
  GazeToggleButton({required this.label, this.icon, this.onTap, this.active = false});

  final Text label;
  final IconData? icon;
  final void Function()? onTap;
  final bool active;
}

class GazeToggleButtons extends StatelessWidget {
  const GazeToggleButtons({super.key, required this.route, required this.buttons, this.axis = Axis.horizontal, this.borderWidth = 3, this.color});

  const GazeToggleButtons.horizontal({super.key, required this.route, required this.buttons, this.borderWidth = 3, this.color}) : axis = Axis.horizontal;

  const GazeToggleButtons.vertical({super.key, required this.route, required this.buttons, this.borderWidth = 3, this.color}) : axis = Axis.vertical;

  final String route;
  final List<GazeToggleButton> buttons;
  final Axis axis;
  final double borderWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final _color = color ?? Theme.of(context).primaryColor;
    final _buttons = buttons
        .mapIndexed(
          (button, index) => _GazeToggleButton(
            button: button,
            route: route,
            color: _color,
            borderRadius: _getBorder(index: index, length: buttons.length, axis: axis),
          ),
        )
        .toList();
    final children = <Widget>[..._buttons]
        .superJoin(Container(width: axis == Axis.horizontal ? borderWidth : null, height: axis == Axis.vertical ? borderWidth : null, color: _color))
        .toList();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: borderWidth, color: _color),
        borderRadius: BorderRadius.all(Radius.circular(20 + borderWidth)),
      ),
      child: IntrinsicHeight(
        child: Flex(mainAxisSize: MainAxisSize.min, direction: axis, children: children),
      ),
    );
  }

  BorderRadius _getBorder({required int index, required int length, required Axis axis}) {
    const radius = Radius.circular(20);
    if (index == 0) return axis == Axis.horizontal ? const BorderRadius.horizontal(left: radius) : const BorderRadius.vertical(top: radius);
    if (index == length - 1) return axis == Axis.horizontal ? const BorderRadius.horizontal(right: radius) : const BorderRadius.vertical(bottom: radius);
    return BorderRadius.zero;
  }
}

class _GazeToggleButton extends StatelessWidget {
  const _GazeToggleButton({required this.button, required this.route, this.color, this.borderRadius = const BorderRadius.all(Radius.circular(20))});

  final GazeToggleButton button;
  final String route;
  final Color? color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).primaryColor;
    return Flexible(
      child: GazeButton(
        onTap: button.onTap,
        color: button.active ? buttonColor : buttonColor.withOpacity(0.1),
        properties: GazeButtonProperties(
          route: route,
          gazeInteractive: button.active != true,
          direction: Axis.horizontal,
          borderRadius: borderRadius,
          text: Text(button.label.data ?? '', style: TextStyle(color: button.active ? Colors.white : Colors.white54).merge(button.label.style)),
          icon: button.icon != null ? Icon(button.icon, color: button.active ? Colors.white : Colors.white38) : null,
          borderColor: Colors.transparent,
        ),
      ),
    );
  }
}
