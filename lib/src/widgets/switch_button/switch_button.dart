//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../button/button.dart';

part 'switch_button.g.dart';

@riverpod
class SwitchButtonToggleWithDelay extends _$SwitchButtonToggleWithDelay {
  @override
  bool build({required GlobalKey key}) => true;

  void toggle() {
    state = false;
    Future.delayed(const Duration(milliseconds: 300), () => state = true);
  }
}

@riverpod
class SwitchButtonChanged extends _$SwitchButtonChanged {
  @override
  bool? build({required GlobalKey key}) => false;

  void update({required bool? value}) => state = value;
}

class GazeSwitchButtonProperties {
  GazeSwitchButtonProperties({
    this.gazeInteractive = true,
    this.showLabel = true,
    this.labelTextStyle,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.red,
    this.disabledColor = Colors.grey,
    this.backgroundColor,
    this.size = const Size(80, 80),
    this.innerPadding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.fromLTRB(10, 33, 10, 33),
  });

  final bool gazeInteractive;
  final bool showLabel;
  final TextStyle? labelTextStyle;
  final Color disabledColor;
  final Color inactiveColor;
  final Color activeColor;
  final Color? backgroundColor;
  final Size size;
  final EdgeInsets innerPadding;
  final EdgeInsets margin;
}

class GazeSwitchButton extends ConsumerStatefulWidget {
  GazeSwitchButton({super.key, required this.route, required this.value, required this.onChanged, required this.properties});

  final String route;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final GazeSwitchButtonProperties properties;

  @override
  _GazeSwitchButtonState createState() => _GazeSwitchButtonState();
}

class _GazeSwitchButtonState extends ConsumerState<GazeSwitchButton> with SingleTickerProviderStateMixin {
  _GazeSwitchButtonState();

  late final AnimationController _controller;
  late final Animation<double> _animation;

  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(begin: math.pi, end: math.pi / 2).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));
    if (widget.value) _controller.forward();
    // // Change to initial value if value has not changed
    _controller.addStatusListener((status) {
      final changed = ref.watch(switchButtonChangedProvider(key: globalKey));
      if (changed == true) return;
      if (status == AnimationStatus.dismissed && widget.value == true) _controller.forward();
      if (status == AnimationStatus.completed && widget.value == false) _controller.reverse();
    });
  }

  @override
  void dispose() {
    if (mounted) _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GazeSwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ref.read(switchButtonChangedProvider(key: globalKey).notifier).update(value: oldWidget.value != widget.value);
      }
    });
    // toggle if value changed
    if (oldWidget.value != widget.value) {
      _toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color.alphaBlend(_color(widget.value).withOpacity(0.1), widget.properties.backgroundColor ?? Colors.black);
    return GazeButton(
      properties: GazeButtonProperties(
        route: widget.route,
        innerPadding: EdgeInsets.zero,
        gazeInteractive: widget.onChanged != null && widget.properties.gazeInteractive,
      ),
      onTap: widget.onChanged == null
          ? null
          : () async {
              _toggle();
              ref.read(switchButtonToggleWithDelayProvider(key: globalKey).notifier).toggle();
              widget.onChanged!(!widget.value);
            },
      child: AnimatedContainer(
        width: widget.properties.size.width,
        height: widget.properties.size.height,
        duration: const Duration(milliseconds: 300),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          border: Border.all(color: _color(widget.value), width: 3),
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                Transform.rotate(
                  angle: _animation.value,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: widget.properties.margin,
                    decoration: BoxDecoration(
                      color: _color(widget.value),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                if (widget.properties.showLabel)
                  _GazeSwitchButtonLabel(
                    color: color,
                    value: widget.value,
                    opacity: ref.watch(switchButtonToggleWithDelayProvider(key: globalKey)) ? 1 : 0,
                    style: widget.properties.labelTextStyle?.copyWith(color: _color(widget.value)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggle() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  Color _color(bool toggled) {
    if (widget.onChanged == null) return widget.properties.disabledColor.withOpacity(0.5);
    if (toggled) return widget.properties.activeColor;
    return widget.properties.inactiveColor;
  }
}

class _GazeSwitchButtonLabel extends StatelessWidget {
  const _GazeSwitchButtonLabel({required this.value, required this.color, this.opacity = 1.0, this.style});

  final bool value;
  final Color color;
  final double opacity;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Container(
          color: color,
          padding: EdgeInsets.all(value ? 0 : 2),
          child: FittedBox(
            child: Text(
              value ? 'ON' : 'OFF',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold).merge(style),
            ),
          ),
        ),
      ),
    );
  }
}
