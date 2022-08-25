//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../extensions.dart';
import '../../state.dart';
import '../button/button.dart';

enum GazeListViewIndicatorState {
  hidden,
  visible,
  active,
}

extension GazeListViewIndicatorStateValue on GazeListViewIndicatorState {
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
  GazeListViewWrapper({
    required this.wrappedKey,
    required this.wrappedWidget,
    required this.controller,
    required this.route,
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
      if (widget.controller.hasClients && widget.controller.position.extentAfter > 0 && !_downIndicatorState.isVisible) {
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
    if (!widget.controller.hasClients) return;
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

  Future<void> _listener() async {
    if (!_active || _animating || !widget.controller.hasClients || !_downIndicatorState.isVisible && !_upIndicatorState.isVisible) return;
    final rect = widget.gazeInteractive.rect;
    await _calculate(rect);
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
      } else {
        if (_downIndicatorState != GazeListViewIndicatorState.visible || _upIndicatorState != GazeListViewIndicatorState.visible) {
          setState(() {
            _upIndicatorState = GazeListViewIndicatorState.visible;
            _downIndicatorState = GazeListViewIndicatorState.visible;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        if (!_active) {
          _calculate(Rect.fromCenter(
            center: event.position,
            width: 10,
            height: 10,
          ));
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
                        width: 300,
                        height: 60,
                        child: GazeButton(
                          properties: GazeButtonProperties(
                            key: GlobalKey(),
                            route: widget.route,
                            gazeInteractive: false,
                            innerPadding: const EdgeInsets.all(10),
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
                    width: 300,
                    height: 60,
                    child: GazeButton(
                      properties: GazeButtonProperties(
                        key: GlobalKey(),
                        route: widget.route,
                        gazeInteractive: false,
                        innerPadding: const EdgeInsets.all(10),
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
