//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/element_data.dart';
import '../core/element_type.dart';
import '../core/extensions.dart';
import '../core/scroll_direction.dart';
import '../state.dart';

class GazeView extends StatelessWidget {
  const GazeView({
    super.key,
    required this.child,
    required this.route,
    this.onGazeEnter,
    this.onGazeLeave,
    this.onGaze,
    this.onScroll,
    this.scrollAreaLeft = 0.3,
    this.scrollAreaRight = 0.3,
    this.scrollAreaTop = 0.3,
    this.scrollAreaBottom = 0.3,
    // GazeViews are in general not snappable
    this.snappable = false,
  });

  final Widget child;
  final String route;
  final bool snappable;
  final void Function()? onGazeEnter;
  final void Function()? onGazeLeave;
  final void Function(Offset)? onGaze;
  final void Function(GazeScrollDirection, double)? onScroll;
  final double scrollAreaLeft;
  final double scrollAreaRight;
  final double scrollAreaTop;
  final double scrollAreaBottom;

  @override
  Widget build(BuildContext context) {
    return GazeViewImpl(
      wrappedKey: GlobalKey(),
      route: route,
      onGazeEnter: onGazeEnter,
      onGazeLeave: onGazeLeave,
      onGaze: onGaze,
      onScroll: onScroll,
      snappable: snappable,
      scrollAreaLeft: scrollAreaLeft,
      scrollAreaRight: scrollAreaRight,
      scrollAreaTop: scrollAreaTop,
      scrollAreaBottom: scrollAreaBottom,
      child: child,
    );
  }
}

class GazeViewImpl extends ConsumerStatefulWidget {
  const GazeViewImpl({
    required this.wrappedKey,
    required this.child,
    required this.route,
    this.onGazeEnter,
    this.onGazeLeave,
    this.onGaze,
    this.onScroll,
    // left scroll area percentage of the screen
    this.scrollAreaLeft = 0.3,
    // right scroll area percentage of the screen
    this.scrollAreaRight = 0.3,
    // top scroll area percentage of the screen
    this.scrollAreaTop = 0.3,
    // bottom scroll area percentage of the screen
    this.scrollAreaBottom = 0.3,
    required this.snappable,
  }) : super(key: wrappedKey);

  final GlobalKey wrappedKey;
  final Widget child;
  final String route;
  final bool snappable;
  final double scrollAreaLeft;
  final double scrollAreaRight;
  final double scrollAreaTop;
  final double scrollAreaBottom;

  final void Function()? onGazeEnter;
  final void Function()? onGazeLeave;
  final void Function(Offset)? onGaze;
  final void Function(GazeScrollDirection, double)? onScroll;

  @override
  _GazeViewImplState createState() => _GazeViewImplState();
}

class _GazeViewImplState extends ConsumerState<GazeViewImpl> {
  @override
  void initState() {
    super.initState();
    _register();
  }

  @override
  void deactivate() {
    ref.read(gazeInteractiveProvider).unregister(key: widget.wrappedKey, type: GazeElementType.all);
    super.deactivate();
  }

  void _register() {
    ref.read(gazeInteractiveProvider).register(
          GazeElementData(
            key: widget.wrappedKey,
            route: widget.route,
            snappable: widget.snappable,
            onGazeEnter: () {
              if (mounted) {
                widget.onGazeEnter?.call();
              }
            },
            onGazeLeave: () {
              if (mounted) {
                widget.onGazeLeave?.call();
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
        bounds.top + bounds.height * widget.scrollAreaTop,
      );
      // calculate bottom area in which scrolling happens
      final tempBottom = Rect.fromLTRB(
        bounds.left,
        bounds.bottom - bounds.height * widget.scrollAreaBottom,
        bounds.right,
        bounds.bottom,
      );

      // calculate left area in which scrolling happens
      final tempLeft = Rect.fromLTRB(
        bounds.left,
        bounds.top,
        bounds.left + bounds.width * widget.scrollAreaLeft,
        bounds.bottom,
      );

      // calculate right area in which scrolling happens
      final tempRight = Rect.fromLTRB(
        bounds.right - bounds.width * widget.scrollAreaRight,
        bounds.top,
        bounds.right,
        bounds.bottom,
      );
      final double maxScrollSpeed = ref.read(ref.read(gazeInteractiveProvider).scrollFactor);
      // final double maxScrollSpeed = GazeInteractive().scrollFactor;
      if (tempTop.overlaps(rect)) {
        // In top area
        // calculate scrolling factor
        final double factor = (tempTop.bottom - rect.topCenter.dy) / tempTop.height * maxScrollSpeed;
        // scroll up
        widget.onScroll?.call(GazeScrollDirection.up, factor);
      } else if (tempBottom.overlaps(rect)) {
        // In bottom area;
        // calculate scrolling factor
        final double factor = (rect.bottomCenter.dy - tempBottom.top) / tempBottom.height * maxScrollSpeed;
        // scroll down
        widget.onScroll?.call(GazeScrollDirection.down, factor);
      } else if (tempLeft.overlaps(rect)) {
        // In left area
        // calculate scrolling factor
        final double factor = (tempLeft.right - rect.right) / tempLeft.width * maxScrollSpeed;
        // scroll left
        widget.onScroll?.call(GazeScrollDirection.left, factor);
      } else if (tempRight.overlaps(rect)) {
        // In right area
        // calculate scrolling factor
        final double factor = (rect.left - tempRight.left) / tempRight.width * maxScrollSpeed;
        // scroll right
        widget.onScroll?.call(GazeScrollDirection.right, factor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
