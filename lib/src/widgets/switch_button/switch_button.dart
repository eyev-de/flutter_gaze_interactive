//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../button/button.dart';
import 'switch_button_state.model.dart';

part 'switch_button.g.dart';

@riverpod
class SwitchButtonToggleWithDelay extends _$SwitchButtonToggleWithDelay {
  @override
  bool build({required GlobalKey key}) {
    return true;
  }

  void toggle() {
    state = false;
    Future.delayed(const Duration(milliseconds: 300), () => state = true);
  }
}

class GazeSwitchButtonProperties {
  GazeSwitchButtonProperties({
    required this.state,
    required this.route,
    this.enabled = true,
    this.showLabel = true,
    this.labelTextStyle,
    this.disabledColor = Colors.grey,
    this.unToggledColor = Colors.grey,
    this.toggledColor = Colors.blue,
    this.innerPadding = const EdgeInsets.all(20),
    this.size = const Size(80, 80),
    this.margin = const EdgeInsets.fromLTRB(10, 33, 10, 33),
  });

  final GazeSwitchButtonState state;
  final String route;
  final bool enabled;
  final bool showLabel;
  final TextStyle? labelTextStyle;
  final Color disabledColor;
  final Color unToggledColor;
  final Color toggledColor;
  final EdgeInsets innerPadding;
  final Size size;
  final EdgeInsets margin;
}

class GazeSwitchButton extends ConsumerStatefulWidget {
  GazeSwitchButton({Key? key, required this.properties, required this.onToggled}) : super(key: key);

  final GazeSwitchButtonProperties properties;
  final Future<bool> Function(bool)? onToggled;

  @override
  _GazeSwitchButtonState createState() => _GazeSwitchButtonState();
}

class _GazeSwitchButtonState extends ConsumerState<GazeSwitchButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  late final stateProvider = StateProvider((ref) => widget.properties.state);
  final GlobalKey globalKey = GlobalKey();

  _GazeSwitchButtonState();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(begin: math.pi, end: math.pi / 2).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));
    if (widget.properties.state.toggled) _controller.forward();
  }

  @override
  void dispose() {
    if (mounted) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _state = ref.watch(stateProvider);
    ref.listen(stateProvider, (prev, next) => _toggle(next.toggled));
    return GazeButton(
      properties: GazeButtonProperties(
        route: widget.properties.route,
        innerPadding: EdgeInsets.zero,
        gazeInteractive: widget.properties.enabled == false ? false : _state.gazeInteractive,
      ),
      onTap: widget.properties.enabled
          ? () async {
              final state = ref.read(stateProvider);
              ref.read(stateProvider.notifier).state = state.copyWith(toggled: !state.toggled);
              if (widget.onToggled != null && !await widget.onToggled!(!state.toggled)) {
                ref.read(stateProvider.notifier).state = state.copyWith(toggled: state.toggled);
              }
              ref.read(switchButtonToggleWithDelayProvider(key: globalKey).notifier).toggle();
            }
          : null,
      child: AnimatedContainer(
        width: widget.properties.size.width,
        height: widget.properties.size.height,
        duration: const Duration(milliseconds: 300),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.alphaBlend(Colors.black.withOpacity(.85), _getColor(_state.toggled)),
          border: Border.all(color: _getColor(_state.toggled), width: 3),
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
                      color: _getColor(_state.toggled),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                if (widget.properties.showLabel)
                  AnimatedOpacity(
                    opacity: ref.watch(switchButtonToggleWithDelayProvider(key: globalKey)) ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Center(
                      child: Container(
                        color: Color.alphaBlend(Colors.black.withOpacity(.85), _getColor(_state.toggled)),
                        padding: EdgeInsets.all(_state.toggled ? 0 : 2),
                        child: Text(
                          _state.toggled ? 'ON' : 'OFF',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontWeight: FontWeight.bold, color: _getColor(_state.toggled))
                              .merge(widget.properties.labelTextStyle),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggle(bool toggled) {
    final status = _controller.status;
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  Color _getColor(bool toggled) {
    if (!widget.properties.enabled) return widget.properties.disabledColor.withOpacity(0.5);
    if (toggled) return widget.properties.toggledColor;
    return widget.properties.unToggledColor;
  }
}
