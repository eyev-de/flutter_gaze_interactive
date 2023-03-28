//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';

import '../../element_data.dart';
import '../../element_type.dart';
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
  });
}

class GazeSelectionAnimation extends StatefulWidget {
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
  State<StatefulWidget> createState() => _GazeSelectionAnimationState();
}

class _GazeSelectionAnimationState extends State<GazeSelectionAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;
  Timer? _timer;
  bool gazeIn = false;

  _GazeSelectionAnimationState();

  @override
  void initState() {
    super.initState();
    _register();
    _initAnimation();
    GazeInteractive().addListener(_listener);
  }

  void _listener() {
    _controller.duration = GazeInteractive().duration;
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: GazeInteractive().duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timer?.cancel();
          if (mounted) {
            _controller.reset();
            if (widget.properties.reselectable) _controller.forward();
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
              color: _colorTween.value,
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
    GazeInteractive().removeListener(_listener);
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
          }
          if (mounted) _controller.stop();
          _timer = Timer(GazeInteractive().recoverTime, () {
            if (mounted) _controller.reset();
          });
        },
      ),
    );
  }
}
