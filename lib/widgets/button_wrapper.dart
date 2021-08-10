//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';

import '../state.dart';

class GazeButtonWrapperProperties {
  final BorderRadius borderRadius;
  final Color color;
  final String? route;
  final bool gazeInteractive;
  GazeButtonWrapperProperties({
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.color = Colors.grey,
    this.route,
    this.gazeInteractive = true,
  });
}

class GazeButtonWrapper extends StatefulWidget {
  final GazeButtonWrapperProperties properties;
  final GazeInteractive gazeInteractive = GazeInteractive();
  final GlobalKey wrappedKey;
  final Widget wrappedWidget;
  final void Function() onGazed;
  GazeButtonWrapper({
    Key? key,
    required this.properties,
    required this.wrappedKey,
    required this.wrappedWidget,
    required this.onGazed,
  }) : super(key: key);
  @override
  _GazeButtonWrapperState createState() => _GazeButtonWrapperState();
}

class _GazeButtonWrapperState extends State<GazeButtonWrapper> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Timer? _timer;
  bool gazeIn = false;

  _GazeButtonWrapperState();

  @override
  void initState() {
    super.initState();
    _register();
    _initAnimation();
    widget.gazeInteractive.addListener(_listener);
  }

  void _listener() {
    if (_controller != null) _controller!.duration = widget.gazeInteractive.gazeInteractiveDuration;
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: widget.gazeInteractive.gazeInteractiveDuration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _timer?.cancel();
          if (mounted) {
            _controller?.stop();
            _controller?.reset();
          }
          if (widget.properties.gazeInteractive) widget.onGazed();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.wrappedWidget,
        if (widget.properties.gazeInteractive)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: widget.properties.borderRadius,
                  border: Border.all(
                    color: gazeIn ? widget.properties.color : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            ),
          ),
        if (widget.properties.gazeInteractive)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: widget.properties.borderRadius,
                ),
                child: AnimatedBuilder(
                  animation: _controller!,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.diagonal3Values(_controller!.value, 1, 1),
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

  @override
  void deactivate() {
    _timer?.cancel();
    super.deactivate();
    widget.gazeInteractive.removeListener(_listener);
    widget.gazeInteractive.unregister(widget.wrappedKey, GazeInteractiveType.selectable);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _register() {
    widget.gazeInteractive.register(
      GazeInteractionData(
        key: widget.wrappedKey,
        // Route is set automatically if not supplied
        route: widget.properties.route ?? widget.gazeInteractive.currentRoute,
        onGazeEnter: () {
          _timer?.cancel();
          if (mounted) {
            setState(() {
              gazeIn = true;
            });
            _controller?.forward();
          }
        },
        onGazeLeave: () {
          if (mounted) {
            setState(() {
              gazeIn = false;
            });
          }
          if (mounted) _controller?.stop();
          _timer = Timer(widget.gazeInteractive.gazeInteractiveRecoverTime, () {
            if (mounted) {
              _controller?.reset();
            }
          });
        },
        type: GazeInteractiveType.selectable,
      ),
    );
  }
}
