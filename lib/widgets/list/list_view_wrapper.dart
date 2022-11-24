//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../extensions.dart';
import '../../state.dart';
import '../button/button.dart';

enum GazeListViewIndicatorState {
  hidden,
  visible,
  active;

  double get opacity {
    switch (this) {
      case GazeListViewIndicatorState.hidden:
        return 0;
      case GazeListViewIndicatorState.visible:
        return 0.15;
      case GazeListViewIndicatorState.active:
        return 1;
    }
  }

  bool get isVisible {
    return opacity > GazeListViewIndicatorState.hidden.opacity;
  }
}

class GazeListViewWrapper extends StatefulWidget {
  final GazeInteractive gazeInteractive = GazeInteractive();
  final GlobalKey wrappedKey;
  final Widget wrappedWidget;
  final ScrollController controller;
  final String route;
  final double indicatorWidth;
  final double indicatorHeight;
  final EdgeInsets indicatorInnerPadding;
  GazeListViewWrapper({
    required this.wrappedKey,
    required this.wrappedWidget,
    required this.controller,
    required this.route,
    required this.indicatorWidth,
    required this.indicatorHeight,
    required this.indicatorInnerPadding,
  }) : super(key: wrappedKey);
  @override
  _GazeListViewWrapperState createState() => _GazeListViewWrapperState();
}

class _GazeListViewWrapperState extends State<GazeListViewWrapper> {
  bool _active = false;
  bool _animating = false;
  GazeListViewIndicatorState _upIndicatorState = GazeListViewIndicatorState.hidden;
  GazeListViewIndicatorState _downIndicatorState = GazeListViewIndicatorState.hidden;

  _GazeListViewWrapperState();

  static const double scrollArea = 0.2;

  @override
  void initState() {
    super.initState();
    // addlistener to the GazeInteractive instance
    widget.gazeInteractive.addListener(_listener);
    widget.gazeInteractive.register(
      GazeInteractionData(
        key: widget.wrappedKey,
        route: widget.route,
        onGazeEnter: () {
          _active = true;
        },
        onGazeLeave: () {
          _active = false;
        },
        type: GazeInteractiveType.scrollable,
      ),
    );
    widget.controller.addListener(_scrollListener);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && widget.controller.hasClients && widget.controller.position.extentAfter > 0 && !_downIndicatorState.isVisible) {
        setState(() {
          _downIndicatorState = GazeListViewIndicatorState.visible;
        });
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.gazeInteractive.removeListener(_listener);
    widget.gazeInteractive.unregister(widget.wrappedKey, GazeInteractiveType.scrollable);
    widget.controller.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (!widget.controller.hasClients || !mounted) return;
    if (widget.controller.position.atEdge) {
      if (widget.controller.position.pixels == 0) {
        if (_upIndicatorState.isVisible) {
          setState(() {
            _upIndicatorState = GazeListViewIndicatorState.hidden;
          });
        }
      } else {
        if (_downIndicatorState.isVisible) {
          setState(() {
            _downIndicatorState = GazeListViewIndicatorState.hidden;
          });
        }
      }
    } else {
      if (!_upIndicatorState.isVisible) {
        setState(() {
          _upIndicatorState = GazeListViewIndicatorState.visible;
        });
      }
      if (!_downIndicatorState.isVisible) {
        setState(() {
          _downIndicatorState = GazeListViewIndicatorState.visible;
        });
      }
    }
  }

  // If rect and active are not null the call was made by MouseRegion
  // If there is no area to scroll this will return and hide the indicators
  Future<void> _listener({Rect? rect, bool? active}) async {
    final _localActive = active ?? _active;
    if (!mounted || !_localActive || _animating || !widget.controller.hasClients) return;
    if (widget.controller.position.maxScrollExtent == 0) {
      if (_downIndicatorState != GazeListViewIndicatorState.hidden || _upIndicatorState != GazeListViewIndicatorState.hidden) {
        setState(() {
          _downIndicatorState = GazeListViewIndicatorState.hidden;
          _upIndicatorState = GazeListViewIndicatorState.hidden;
        });
      }
      return;
    }
    final _rect = rect ?? widget.gazeInteractive.rect;
    await _calculate(_rect);
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

      final double maxScrollSpeed = widget.gazeInteractive.gazeInteractiveScrollFactor;
      if (tempTop.overlaps(rect)) {
        // In top area
        if (widget.controller.offset == 0) return;
        if (_downIndicatorState != GazeListViewIndicatorState.visible || _upIndicatorState != GazeListViewIndicatorState.active) {
          setState(() {
            _upIndicatorState = GazeListViewIndicatorState.active;
            _downIndicatorState = GazeListViewIndicatorState.visible;
          });
        }
        // calculate scrolling factor
        final double factor = (tempTop.bottom - rect.topCenter.dy) / tempTop.height * maxScrollSpeed;
        // calculate new scrolling offset
        final double offset = widget.controller.offset - factor < 0 ? 0 : widget.controller.offset - factor;
        _animating = true;
        await widget.controller.position.animateTo(
          offset,
          duration: const Duration(milliseconds: 60),
          curve: Curves.ease,
        );
        _animating = false;
      } else if (tempBottom.overlaps(rect)) {
        // In bottom area;
        if (widget.controller.position.atEdge && widget.controller.position.pixels > 0) return;
        if (_downIndicatorState != GazeListViewIndicatorState.active || _upIndicatorState != GazeListViewIndicatorState.visible) {
          setState(() {
            _downIndicatorState = GazeListViewIndicatorState.active;
            _upIndicatorState = GazeListViewIndicatorState.visible;
          });
        }
        // calculate scrolling factor
        final double factor = (rect.bottomCenter.dy - tempBottom.top) / tempTop.height * maxScrollSpeed;
        // calculate new scrolling offset
        final double offset = widget.controller.offset + factor > widget.controller.position.maxScrollExtent
            ? widget.controller.position.maxScrollExtent
            : widget.controller.offset + factor;
        _animating = true;
        await widget.controller.position.animateTo(
          offset,
          duration: const Duration(milliseconds: 60),
          curve: Curves.ease,
        );
        _animating = false;
      }
      // Hides the indicators if they are at the edge at the end of scrolling
      _scrollListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        if (!_active) {
          final rect = Rect.fromCenter(
            center: event.position,
            width: 10,
            height: 10,
          );
          _listener(rect: rect, active: true);
        }
      },
      child: Stack(
        children: [
          widget.wrappedWidget,
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _downIndicatorState.isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: widget.indicatorWidth,
                        height: widget.indicatorHeight,
                        child: GazeButton(
                          properties: GazeButtonProperties(
                            route: widget.route,
                            gazeInteractive: false,
                            innerPadding: widget.indicatorInnerPadding,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100),
                            ),
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Theme.of(context).primaryColor,
                            ),
                            backgroundColor: Colors.white.withOpacity(_downIndicatorState.opacity),
                            horizontal: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _upIndicatorState.isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widget.indicatorWidth,
                    height: widget.indicatorHeight,
                    child: GazeButton(
                      properties: GazeButtonProperties(
                        route: widget.route,
                        gazeInteractive: false,
                        innerPadding: widget.indicatorInnerPadding,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                        icon: Icon(
                          Icons.arrow_upward,
                          color: Theme.of(context).primaryColor,
                        ),
                        backgroundColor: Colors.white.withOpacity(_upIndicatorState.opacity),
                        horizontal: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
