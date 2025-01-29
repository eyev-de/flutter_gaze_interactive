import 'package:flutter/material.dart';

import '../../../api.dart';
import '../../core/extensions.dart';

class GazeToggleButton {
  GazeToggleButton({required this.label, this.icon, this.onTap, this.active = false, this.onButtonColor});

  final Text label;
  final IconData? icon;
  final void Function()? onTap;
  final bool active;
  final Color? onButtonColor;
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
            onButtonColor: button.onButtonColor,
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
  const _GazeToggleButton({
    required this.button,
    required this.route,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.color,
    this.onButtonColor,
  });

  final GazeToggleButton button;
  final String route;
  final Color? color;
  final Color? onButtonColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final _buttonColor = color ?? Theme.of(context).primaryColor;
    final _onButtonColor = onButtonColor ?? Theme.of(context).colorScheme.onPrimary;
    return Flexible(
      child: GazeButton(
        onTap: button.onTap,
        color: button.active ? _buttonColor : _buttonColor.withValues(alpha: 0.1),
        properties: GazeButtonProperties(
          gazeSelectionAnimationType: GazeSelectionAnimationType.fade,
          animationColor: color ?? Theme.of(context).primaryColor,
          route: route,
          gazeInteractive: button.active != true,
          direction: Axis.horizontal,
          borderRadius: borderRadius,
          text: Text(
            button.label.data ?? '',
            overflow: button.label.overflow,
            maxLines: button.label.maxLines,
            softWrap: button.label.softWrap,
            textAlign: button.label.textAlign,
            style: TextStyle(color: button.active ? _onButtonColor : _onButtonColor.withValues(alpha: 0.5)).merge(button.label.style),
          ),
          icon: button.icon != null ? Icon(button.icon, color: button.active ? _onButtonColor : _onButtonColor.withValues(alpha: 0.5)) : null,
          borderColor: Colors.transparent,
        ),
      ),
    );
  }
}
