//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/element_data.dart';
import '../../core/element_type.dart';
import '../../state.dart';
import 'pointer_circle.dart';
import 'pointer_state.model.dart';
import 'pointer_type.dart';

part 'pointer_view.g.dart';

/// Animation Controller
@riverpod
class PointerAnimationController extends _$PointerAnimationController {
  @override
  AnimationController build({required TickerProvider vsync}) =>
      AnimationController(vsync: vsync, duration: Duration(milliseconds: ref.read(GazeInteractive().duration)));
}

// Animation
@riverpod
class PointerAnimation extends _$PointerAnimation {
  @override
  Animation<double> build({required TickerProvider vsync}) =>
      Tween<double>(begin: 0, end: 1).animate(ref.watch(pointerAnimationControllerProvider(vsync: vsync)));
}

/// Gaze Pointer appears shortly and is then faded out -> current opacity
@riverpod
class PointerOpacity extends _$PointerOpacity {
  @override
  double build() => 0.6;

  void fadeOut() => Future.delayed(const Duration(milliseconds: 1200), () => state = kDebugMode ? 0.6 : 0.0);

  void reset() => ref.invalidateSelf();
}

class GazePointerView extends ConsumerStatefulWidget {
  GazePointerView({Key? key, GazePointerState? state})
      : _state = state ?? GazePointerState(),
        super(key: key);

  final GazePointerState _state;

  @override
  _GazePointerViewState createState() => _GazePointerViewState();
}

class _GazePointerViewState extends ConsumerState<GazePointerView> with SingleTickerProviderStateMixin {
  _GazePointerViewState();

  double _fixationRadius = 100;

  final GlobalKey _wrappedkey = GlobalKey();

  final _pointerOffsetProvider = StateProvider((ref) => const Offset(0, 0));
  final _localPointerOffsetProvider = StateProvider((ref) => const Offset(0, 0));
  final _fixationPointProvider = StateProvider((ref) => const Offset(0, 0));

  late final gazePointerData = GazePointerData(key: _wrappedkey, onGaze: _onGazeData, onFixation: _onFixation);

  @override
  void initState() {
    super.initState();
    ref.read(pointerAnimationControllerProvider(vsync: this)).addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          if (mounted) ref.read(pointerAnimationControllerProvider(vsync: this)).reset();
          final _pointerOffset = ref.read(_pointerOffsetProvider);
          final _size = ref.read(_sizeProvider);
          widget._state.onAction?.call(_pointerOffset + Offset(_size / 2, _size / 2));
        }
      },
    );
    // animate
    ref.read(pointerAnimationProvider(vsync: this));
    GazeInteractive().register(gazePointerData);
    ref.read(pointerOpacityProvider.notifier).fadeOut();
    if (kDebugMode) {
      Future.delayed(const Duration(), () => ref.read(_pointerOffsetProvider.notifier).state = const Offset(100, 100));
    }
  }

  @override
  void deactivate() {
    GazeInteractive().unregister(key: _wrappedkey, type: GazeElementType.pointer);
    super.deactivate();
  }

  void _onGazeData(Offset gaze) {
    if (mounted) {
      ref.read(pointerOpacityProvider.notifier).reset();
      final _size = ref.read(_sizeProvider);
      final Offset temp = _validate(context, gaze - Offset(_size / 2, _size / 2), _size);
      ref.read(_pointerOffsetProvider.notifier).state = temp;
      gazePointerData.onPointerMove?.call(temp + Offset(_size / 2, _size / 2), Size(_size, _size));
      final _fixationPoint = ref.read(_fixationPointProvider);
      if (widget._state.type == GazePointerType.active && _leftFixationRadius(gaze, _fixationPoint, _fixationRadius)) {
        ref.read(pointerAnimationControllerProvider(vsync: this)).reset();
      }
    }
    ref.read(pointerOpacityProvider.notifier).fadeOut();
  }

  void _onFixation() {
    if (mounted && widget._state.type == GazePointerType.active && !ref.watch(pointerAnimationControllerProvider(vsync: this)).isAnimating) {
      ref.read(_fixationPointProvider.notifier).state = ref.read(_pointerOffsetProvider);
      ref.read(pointerAnimationControllerProvider(vsync: this)).forward();
    }
  }

  late final _sizeProvider = StateProvider.autoDispose(
    (ref) {
      final _size = ref.watch(GazeInteractive().pointerSize);
      return widget._state.type == GazePointerType.active ? _size / 1.5 : _size;
    },
  );

  @override
  Widget build(BuildContext context) {
    final _size = ref.watch(_sizeProvider);
    final _fixationRadius = ref.watch(GazeInteractive().fixationRadius);
    final _pointerOffset = ref.watch(_pointerOffsetProvider);
    final _opacity = ref.watch(pointerOpacityProvider);
    final _controller = ref.watch(pointerAnimationControllerProvider(vsync: this));
    final _animation = ref.watch(pointerAnimationProvider(vsync: this));
    ref
      ..listen(
        GazeInteractive().duration,
        (previous, next) => _controller.duration = Duration(milliseconds: next),
      )
      ..listen(
        GazeInteractive().fixationRadius,
        (previous, next) => this._fixationRadius = next,
      );
    return Positioned(
      left: _pointerOffset.dx,
      top: _pointerOffset.dy,
      child: Builder(
        builder: (context) {
          // ignore gesture on pointer
          if (widget._state.ignorePointer) {
            return AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 150),
              child: PointerCircle(type: widget._state.type, size: _size, animation: _animation),
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
                ref.read(_pointerOffsetProvider.notifier).state = temp;
                ref.read(_localPointerOffsetProvider.notifier).state = local;
                GazeInteractive().onGaze(temp + Offset(_size / 2, _size / 2));
              }
            },
            onPanUpdate: (details) {
              if (mounted) {
                final _localPointerOffset = ref.read(_localPointerOffsetProvider);
                final Offset temp = _validate(context, details.globalPosition - _localPointerOffset, _size);
                ref.read(_pointerOffsetProvider.notifier).state = temp;
                GazeInteractive().onGaze(temp + Offset(_size / 2, _size / 2));
                final _fixationPoint = ref.read(_fixationPointProvider);
                if (kDebugMode && widget._state.type == GazePointerType.active && _leftFixationRadius(temp, _fixationPoint, _fixationRadius)) {
                  _controller.reset();
                }
              }
            },
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 150),
              child: PointerCircle(type: widget._state.type, size: _size, animation: _animation),
            ),
          );
        },
      ),
    );
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
