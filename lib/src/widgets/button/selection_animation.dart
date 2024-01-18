//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/element_data.dart';
import '../../core/element_type.dart';
import '../../state.dart';

enum GazeSelectionAnimationType {
  progress,
  fade,
}

// class GazeSelectionAnimatable extends StatefulWidget {
//   const GazeSelectionAnimatable({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _GazeSelectionAnimatableState();
// }

// class _GazeSelectionAnimatableState extends State<GazeSelectionAnimatable> {
//   @override
//   Widget build(BuildContext context) {
//   }
// }

class GazeSelectionAnimationProperties {
  final String route;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color? backgroundColor;
  final Color? animationColor;
  final Color color;
  final bool gazeInteractive;
  final GazeSelectionAnimationType type;
  final bool reselectable;
  final int? reselectableCount;
  final bool snappable;

  GazeSelectionAnimationProperties({
    required this.route,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.borderWidth = 3,
    this.backgroundColor,
    this.animationColor,
    this.color = Colors.grey,
    this.gazeInteractive = true,
    this.type = GazeSelectionAnimationType.progress,
    this.reselectable = false,
    this.reselectableCount,
    this.snappable = true,
  });
}

class GazeSelectionAnimation extends ConsumerStatefulWidget {
  final GazeSelectionAnimationProperties properties;
  final GlobalKey wrappedKey;
  final Widget wrappedWidget;
  final void Function()? onGazed;
  GazeSelectionAnimation({
    required this.wrappedKey,
    required this.properties,
    required this.wrappedWidget,
    this.onGazed,
  }) : super(key: wrappedKey);

  @override
  _GazeSelectionAnimationState createState() => _GazeSelectionAnimationState();
}

class _GazeSelectionAnimationState extends ConsumerState<GazeSelectionAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;
  Timer? _timer;
  late int _recoverTime;
  late int _duration;
  bool gazeIn = false;
  int _reselectionCount = 0;

  _GazeSelectionAnimationState();

  @override
  void initState() {
    super.initState();
    _register();
    _initAnimation();
  }

  void _initAnimation() {
    _reselectionCount = 0;
    _recoverTime = ref.read(GazeInteractive().recoverTime);
    _duration = ref.read(GazeInteractive().duration);
    _controller = AnimationController(
      duration: Duration(milliseconds: _duration),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timer?.cancel();
          if (mounted) {
            _controller.reset();
            if (widget.properties.reselectable) {
              // reselectable count = null means infinite re-selections
              if (widget.properties.reselectableCount != null && _reselectionCount >= widget.properties.reselectableCount! - 1) {
                _reselectionCount = 0;
              } else {
                final double reselectionAcceleration = ref.read(GazeInteractive().reselectionAcceleration);
                final _newDuration = (_duration * reselectionAcceleration).round();
                _reselectionCount += 1;
                _duration = max(_newDuration, gazeInteractiveMinDuration);
                _controller
                  ..duration = Duration(milliseconds: _duration)
                  ..forward();
              }
            }
          }
          if (widget.properties.gazeInteractive) widget.onGazed?.call();
        }
      });
    _colorTween = ColorTween(
      begin: widget.properties.backgroundColor,
      end: widget.properties.animationColor,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(GazeInteractive().duration, (previous, next) {
        _duration = next;
        _controller.duration = Duration(milliseconds: _duration);
      })
      ..listen(GazeInteractive().recoverTime, (previous, next) {
        _recoverTime = next;
      });
    return Stack(
      children: [
        _wrappedWidget(),
        if (widget.properties.gazeInteractive)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: widget.properties.borderRadius,
                  border: Border.all(
                    color: gazeIn ? widget.properties.color : Colors.transparent,
                    width: widget.properties.borderWidth,
                  ),
                ),
              ),
            ),
          ),
        if (widget.properties.gazeInteractive && widget.properties.type == GazeSelectionAnimationType.progress)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: widget.properties.borderRadius,
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.diagonal3Values(_controller.value, 1, 1),
                      alignment: Alignment.centerLeft,
                      origin: const Offset(0, 1),
                      child: child,
                    );
                  },
                  child: Container(
                    color: widget.properties.color.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _wrappedWidget() {
    if (widget.properties.backgroundColor == null) return widget.wrappedWidget;
    switch (widget.properties.type) {
      case GazeSelectionAnimationType.progress:
        return Material(
          color: widget.properties.backgroundColor,
          borderRadius: widget.properties.borderRadius,
          child: widget.wrappedWidget,
        );
      case GazeSelectionAnimationType.fade:
        return AnimatedBuilder(
          animation: _colorTween,
          builder: (context, child) {
            return Material(
              color: !widget.properties.gazeInteractive ? widget.properties.backgroundColor : _colorTween.value,
              borderRadius: widget.properties.borderRadius,
              child: widget.wrappedWidget,
            );
          },
        );
    }
  }

  @override
  void deactivate() {
    _timer?.cancel();
    GazeInteractive().unregister(key: widget.wrappedKey, type: GazeElementType.selectable);
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (mounted) _controller.dispose();
    super.dispose();
  }

  void _register() {
    GazeInteractive().register(
      GazeSelectableData(
        key: widget.wrappedKey,
        route: widget.properties.route,
        snappable: widget.properties.snappable,
        onGazeEnter: () {
          _timer?.cancel();
          if (mounted) {
            setState(() {
              gazeIn = true;
            });
            _controller.forward();
          }
        },
        onGazeLeave: () {
          if (mounted) {
            setState(() {
              gazeIn = false;
            });
            _controller.stop();
            _duration = ref.read(GazeInteractive().duration);
            _controller.duration = Duration(milliseconds: _duration);
          }
          _timer = Timer(Duration(milliseconds: _recoverTime), () {
            if (mounted) _controller.reset();
          });
        },
      ),
    );
  }
}
