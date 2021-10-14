//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../state.dart';

class GazePointerView extends StatefulWidget {
  final GazeInteractive gazeInteractive;
  GazePointerView({Key? key})
      : gazeInteractive = GazeInteractive(),
        super(key: key);

  @override
  _GazePointerViewState createState() => _GazePointerViewState();
}

class _GazePointerViewState extends State<GazePointerView> {
  final GlobalKey wrappedkey = GlobalKey();
  Offset _pointerOffset = const Offset(0, 0);
  Offset _localPointerOffset = const Offset(0, 0);

  Size size = const Size(50, 50);

  Timer? _timer;
  double _opacity = 0.6;

  _GazePointerViewState() {
    GazeInteractive().registerGazeView(
      GazePointerData(
        key: wrappedkey,
        onGaze: _onGazeData,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    GazeInteractive().unregisterGazeView(wrappedkey);

    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _opacity = kDebugMode ? 0.6 : 0.0;
        });
      }
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _onGazeData(Offset event) {
    if (mounted) {
      setState(() {
        _opacity = 0.6;
        final Offset temp = _validate(context, event - Offset(size.width / 2, size.height / 2));
        _pointerOffset = temp;
      });
    }
    _restartTimer();
    GazeInteractive().newPosition(
      position: _pointerOffset + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _pointerOffset.dx,
      top: _pointerOffset.dy,
      width: size.width,
      height: size.height,
      child: GestureDetector(
        onPanStart: (details) {
          final RenderBox? getBox = context.findRenderObject() as RenderBox?;
          final Offset local = getBox?.globalToLocal(details.globalPosition) ?? const Offset(0, 0);
          final Offset temp = _validate(context, details.globalPosition - local);
          setState(() {
            _pointerOffset = temp;
            _localPointerOffset = local;
          });
          GazeInteractive().newPosition(
            position: temp + Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height,
          );
        },
        onPanUpdate: (details) {
          final Offset temp = _validate(context, details.globalPosition - _localPointerOffset);
          setState(() {
            _pointerOffset = temp;
          });
          GazeInteractive().newPosition(
            position: temp + Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height,
          );
        },
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Offset _validate(BuildContext context, Offset temp) {
    final media = MediaQuery.maybeOf(context);
    Offset ret = temp;
    if (media != null && temp.dx + size.width > media.size.width) {
      ret = Offset(media.size.width - size.width, temp.dy);
    }
    if (media != null && temp.dy + size.height > media.size.height) {
      ret = Offset(temp.dx, media.size.height - size.height);
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
