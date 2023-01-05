//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import '../element_data.dart';
import '../element_type.dart';
import '../extensions.dart';
import '../scroll_direction.dart';
import '../state.dart';

class GazeView extends StatelessWidget {
  final Widget child;
  final String route;
  final void Function()? onGazeEnter;
  final void Function()? onGazeLeave;
  final void Function(Offset)? onGaze;
  final void Function(GazeScrollDirection, double)? onScroll;

  const GazeView({
    super.key,
    required this.child,
    required this.route,
    this.onGazeEnter,
    this.onGazeLeave,
    this.onGaze,
    this.onScroll,
  });

  @override
  Widget build(BuildContext context) {
    return GazeViewImpl(
      wrappedKey: GlobalKey(),
      route: route,
      onGazeEnter: onGazeEnter,
      onGazeLeave: onGazeLeave,
      onGaze: onGaze,
      onScroll: onScroll,
      child: child,
    );
  }
}

class GazeViewImpl extends StatefulWidget {
  final GlobalKey wrappedKey;
  final Widget child;
  final String route;

  final void Function()? onGazeEnter;
  final void Function()? onGazeLeave;
  final void Function(Offset)? onGaze;
  final void Function(GazeScrollDirection, double)? onScroll;
  const GazeViewImpl({
    required this.wrappedKey,
    required this.child,
    required this.route,
    this.onGazeEnter,
    this.onGazeLeave,
    this.onGaze,
    this.onScroll,
  }) : super(key: wrappedKey);

  @override
  State<StatefulWidget> createState() => _GazeViewImplState();
}

class _GazeViewImplState extends State<GazeViewImpl> {
  bool _active = false;
  static const double scrollArea = 0.3;

  @override
  void initState() {
    super.initState();
    _register();
    GazeInteractive().addListener(_listener);
  }

  void _listener() {}

  @override
  void deactivate() {
    super.deactivate();
    GazeInteractive().removeListener(_listener);
    GazeInteractive().unregister(key: widget.wrappedKey, type: GazeElementType.all);
  }

  void _register() {
    GazeInteractive().register(
      GazeElementData(
        key: widget.wrappedKey,
        route: widget.route,
        onGazeEnter: () {
          if (mounted) {
            widget.onGazeEnter?.call();
            setState(() {
              _active = true;
            });
          }
        },
        onGazeLeave: () {
          if (mounted) {
            widget.onGazeLeave?.call();
            setState(() {
              _active = false;
            });
          }
        },
        onGaze: (gaze) {
          if (mounted) {
            widget.onGaze?.call(gaze);
            _calculate(Rect.fromCenter(center: gaze, width: 3, height: 3));
          }
        },
      ),
    );
  }

  Future<void> _calculate(Rect rect) async {
    final bounds = widget.wrappedKey.globalPaintBounds;
    if (bounds != null) {
      // calculate top area in which scrolling happens
      final tempTop = Rect.fromLTRB(
        bounds.left,
        bounds.top,
        bounds.right,
        bounds.top + bounds.height * scrollArea,
      );
      // calculate bottom area in which scrolling happens
      final tempBottom = Rect.fromLTRB(
        bounds.left,
        bounds.bottom - bounds.height * scrollArea,
        bounds.right,
        bounds.bottom,
      );

      final double maxScrollSpeed = GazeInteractive().scrollFactor;
      if (tempTop.overlaps(rect)) {
        // In top area
        // calculate scrolling factor
        final double factor = (tempTop.bottom - rect.topCenter.dy) / tempTop.height * maxScrollSpeed;
        // scroll up
        widget.onScroll?.call(GazeScrollDirection.up, factor);
      } else if (tempBottom.overlaps(rect)) {
        // In bottom area;
        // calculate scrolling factor
        final double factor = (rect.bottomCenter.dy - tempBottom.top) / tempTop.height * maxScrollSpeed;
        // scroll down
        widget.onScroll?.call(GazeScrollDirection.down, factor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
