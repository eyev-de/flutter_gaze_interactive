//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../element_data.dart';
import '../../element_type.dart';
import '../../state.dart';
import 'pointer_state.dart';
import 'pointer_type.dart';

class GazePointerView extends StatefulWidget {
  final GazeInteractive _gazeInteractive;
  final GazePointerState _state;
  GazePointerView({Key? key, GazePointerState? state})
      : _gazeInteractive = GazeInteractive(),
        _state = state ?? GazePointerState(),
        super(key: key);

  @override
  _GazePointerViewState createState() => _GazePointerViewState();
}

class _GazePointerViewState extends State<GazePointerView> with SingleTickerProviderStateMixin {
  final GlobalKey _wrappedkey = GlobalKey();
  Offset _pointerOffset = const Offset(0, 0);
  Offset _localPointerOffset = const Offset(0, 0);

  Offset _fixationPoint = const Offset(0, 0);
  double _fixationRadius = 100;

  Timer? _fadeOutTimer;
  double _opacity = 0.6;

  late final AnimationController _controller = AnimationController(
    duration: GazeInteractive().duration,
    vsync: this,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          _controller.reset();
        }
        widget._state.onAction?.call(_pointerOffset + Offset(_size / 2, _size / 2));
      }
    });
  late final Animation<double> _actionTween = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(_controller);

  _GazePointerViewState();

  @override
  void initState() {
    super.initState();
    widget._gazeInteractive.register(
      GazePointerData(
        key: _wrappedkey,
        onGaze: _onGazeData,
        onFixation: _onFixation,
      ),
    );
    _startFadeOutTimer();
    GazeInteractive().addListener(_listener);
    if (kDebugMode) _pointerOffset = const Offset(100, 100);
  }

  @override
  void deactivate() {
    _fadeOutTimer?.cancel();
    widget._gazeInteractive.unregister(key: _wrappedkey, type: GazeElementType.pointer);
    GazeInteractive().removeListener(_listener);
    super.deactivate();
  }

  @override
  void dispose() {
    _fadeOutTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _listener() {
    _controller.duration = GazeInteractive().duration;
    _fixationRadius = GazeInteractive().fixationRadius;
  }

  void _startFadeOutTimer() {
    _fadeOutTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _opacity = kDebugMode ? 0.6 : 0.0;
        });
      }
    });
  }

  void _restartFadeOutTimer() {
    _fadeOutTimer?.cancel();
    _startFadeOutTimer();
  }

  void _onGazeData(Offset gaze) {
    if (mounted) {
      setState(() {
        _opacity = 0.6;
        final Offset temp = _validate(context, gaze - Offset(_size / 2, _size / 2), _size);
        _pointerOffset = temp;
      });
      widget._gazeInteractive.newPosition(
        position: _pointerOffset + Offset(_size / 2, _size / 2),
        width: _size,
        height: _size,
      );
      if (widget._state.type == GazePointerType.active && _leftFixationRadius(gaze, _fixationPoint, _fixationRadius)) {
        _controller.reset();
      }
    }
    _restartFadeOutTimer();
  }

  void _onFixation() {
    if (mounted && widget._state.type == GazePointerType.active && !_controller.isAnimating) {
      _fixationPoint = _pointerOffset;
      _controller.forward();
    }
  }

  double get _size => widget._state.type == GazePointerType.active ? widget._gazeInteractive.pointerSize / 1.5 : widget._gazeInteractive.pointerSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _pointerOffset.dx,
      top: _pointerOffset.dy,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: widget._gazeInteractive),
          ChangeNotifierProvider.value(value: widget._state),
        ],
        child: Consumer2<GazeInteractive, GazePointerState>(
          builder: (context, _gazeInteractive, _state, child) {
            if (_state.ignorePointer) {
              return AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 150),
                child: pointer(_state, _size),
              );
            }
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {},
              onTapDown: (details) {},
              onTapUp: (details) {
                if (kDebugMode && widget._state.type == GazePointerType.active && !_controller.isAnimating) {
                  _controller.forward();
                }
              },
              onPanStart: (details) {
                if (mounted) {
                  final RenderBox? getBox = context.findRenderObject() as RenderBox?;
                  final Offset local = getBox?.globalToLocal(details.globalPosition) ?? const Offset(0, 0);
                  final Offset temp = _validate(context, details.globalPosition - local, _size);
                  setState(() {
                    _pointerOffset = temp;
                    _localPointerOffset = local;
                  });
                  _gazeInteractive.onGaze(
                    temp + Offset(_size / 2, _size / 2),
                  );
                  // _gazeInteractive.newPosition(
                  //   position: temp + Offset(_size / 2, _size / 2),
                  //   width: _size,
                  //   height: _size,
                  // );
                }
              },
              onPanUpdate: (details) {
                if (mounted) {
                  final Offset temp = _validate(context, details.globalPosition - _localPointerOffset, _size);
                  setState(() {
                    _pointerOffset = temp;
                  });
                  _gazeInteractive.onGaze(
                    temp + Offset(_size / 2, _size / 2),
                  );
                  // _gazeInteractive.newPosition(
                  //   position: temp + Offset(_size / 2, _size / 2),
                  //   width: _size,
                  //   height: _size,
                  // );
                  if (kDebugMode && widget._state.type == GazePointerType.active && _leftFixationRadius(temp, _fixationPoint, _fixationRadius)) {
                    _controller.reset();
                  }
                }
              },
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 150),
                child: pointer(_state, _size),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget pointer(GazePointerState state, double size) {
    switch (state.type) {
      case GazePointerType.passive:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
          ),
        );
      case GazePointerType.active:
        const _dotSize = 5.0;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Positioned(
                child: AnimatedBuilder(
                  animation: _actionTween,
                  builder: (context, child) => CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 10,
                    value: _actionTween.value,
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: size / 2 - _dotSize / 2,
                left: size / 2 - _dotSize / 2,
                child: Container(
                  alignment: Alignment.center,
                  width: _dotSize,
                  height: _dotSize,
                  decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        );
    }
  }

  bool _leftFixationRadius(Offset gaze, Offset fixationPoint, double fixationRadius) {
    return (gaze - fixationPoint).distanceSquared > pow(fixationRadius, 2);
  }

  static Offset _validate(BuildContext context, Offset temp, double size) {
    final media = MediaQuery.maybeOf(context);
    Offset ret = temp;

    if (media != null && temp.dx + size > media.size.width) {
      ret = Offset(media.size.width - size, temp.dy);
    }
    if (media != null && temp.dy + size > media.size.height) {
      ret = Offset(temp.dx, media.size.height - size);
    }
    if (temp.dx < 0) {
      ret = Offset(0, temp.dy);
    }
    if (temp.dy < 0) {
      ret = Offset(temp.dx, 0);
    }
    return ret;
  }
}
