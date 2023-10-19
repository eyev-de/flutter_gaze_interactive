//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/element_data.dart';
import '../../../core/element_type.dart';
import '../../../core/extensions.dart';
import '../../../state.dart';
import '../pointer_state.model.dart';
import '../pointer_type.enum.dart';
import 'pointer_circle.dart';
import 'pointer_view.provider.dart';

class GazePointerView extends StatelessWidget {
  GazePointerView({Key? key, GazePointerState? state})
      : _state = state ?? GazePointerState(),
        super(key: key);

  final GazePointerState _state;

  @override
  Widget build(BuildContext context) {
    // if (_state.type == GazePointerType.passive) return _PointerPassiveView(state: _state);
    return _PointerView(state: _state);
  }
}

class _PointerView extends ConsumerStatefulWidget {
  const _PointerView({Key? key, required this.state}) : super(key: key);

  final GazePointerState state;

  @override
  _PointerViewState createState() => _PointerViewState();
}

class _PointerViewState extends ConsumerState<_PointerView> with SingleTickerProviderStateMixin {
  _PointerViewState();

  final GlobalKey _wrappedkey = GlobalKey();

  /// GazePointerData
  late final gazePointerData = GazePointerData(
    key: _wrappedkey,
    onGaze: _onGazeData,
    onFixation: _onFixation,
  );

  // on moving -> updated gaze data
  void _onGazeData(Offset gaze) {
    if (mounted) {
      ref.read(pointerOpacityProvider.notifier).reset();
      final _size = ref.read(pointerSizeProvider(type: widget.state.type));
      final Offset temp = context.validateGazePointer(offset: gaze - Offset(_size / 2, _size / 2), size: _size);
      ref.read(pointerOffsetProvider.notifier).update(offset: temp);
      gazePointerData.onPointerMove?.call(temp + Offset(_size / 2, _size / 2), Size(_size, _size));
      final _fixationPoint = ref.read(pointerFixationPointProvider);
      if (widget.state.type == GazePointerType.active && _leftFixationRadius(gaze, _fixationPoint, ref.watch(pointerFixationRadiusProvider))) {
        ref.read(pointerAnimationControllerProvider(vsync: this)).reset();
      }
    }
    ref.read(pointerOpacityProvider.notifier).fadeOut();
  }

  // on fixation -> user focuses on one point
  void _onFixation() {
    if (mounted && widget.state.type == GazePointerType.active && !ref.watch(pointerAnimationControllerProvider(vsync: this)).isAnimating) {
      ref.read(pointerFixationPointProvider.notifier).update(offset: ref.read(pointerOffsetProvider));
      ref.read(pointerAnimationControllerProvider(vsync: this)).forward();
    }
  }

  @override
  void initState() {
    super.initState();
    // fade out gaze pointer
    ref.read(pointerOpacityProvider.notifier).fadeOut();
    // gaze pointer type is active -> animate fixation
    ref.read(pointerAnimationProvider(vsync: this));
    ref.read(pointerAnimationControllerProvider(vsync: this)).addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          if (mounted) ref.read(pointerAnimationControllerProvider(vsync: this)).reset();
          final _pointerOffset = ref.read(pointerOffsetProvider);
          final _size = ref.read(pointerSizeProvider(type: widget.state.type));
          widget.state.onAction?.call(_pointerOffset + Offset(_size / 2, _size / 2));
        }
      },
    );
    GazeInteractive().register(gazePointerData);
  }

  @override
  void deactivate() {
    GazeInteractive().unregister(key: _wrappedkey, type: GazeElementType.pointer);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final _size = ref.watch(pointerSizeProvider(type: widget.state.type));
    final _pointerOffset = ref.watch(pointerOffsetProvider);
    final _fixationRadius = ref.watch(pointerFixationRadiusProvider);
    final _opacity = ref.watch(pointerOpacityProvider);
    final _controller = ref.watch(pointerAnimationControllerProvider(vsync: this));
    final _animation = ref.watch(pointerAnimationProvider(vsync: this));
    return Positioned(
      left: _pointerOffset.dx - (_size / 2),
      top: _pointerOffset.dy - (_size / 2),
      child: Builder(
        builder: (context) {
          // ignore gesture on pointer
          if (widget.state.ignorePointer) {
            return AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 150),
              child: PointerCircle(type: widget.state.type, size: _size, animation: _animation),
            );
          }
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {},
            onTapDown: (details) {},
            onTapUp: (details) {
              if (kDebugMode && widget.state.type == GazePointerType.active && !_controller.isAnimating) {
                _controller.forward();
              }
            },
            onPanStart: (details) {
              if (mounted) {
                final RenderBox? getBox = context.findRenderObject() as RenderBox?;
                final Offset local = getBox?.globalToLocal(details.globalPosition) ?? const Offset(0, 0);
                final Offset temp = context.validateGazePointer(offset: details.globalPosition - local, size: _size);
                ref.read(pointerOffsetProvider.notifier).update(offset: temp);
                ref.read(pointerLocalOffsetProvider.notifier).update(offset: local);
                GazeInteractive().onGaze(temp + Offset(_size / 2, _size / 2));
              }
            },
            onPanUpdate: (details) {
              if (mounted) {
                final _localPointerOffset = ref.read(pointerLocalOffsetProvider);
                final Offset temp = context.validateGazePointer(offset: details.globalPosition - _localPointerOffset, size: _size);
                ref.read(pointerOffsetProvider.notifier).update(offset: temp);
                GazeInteractive().onGaze(temp + Offset(_size / 2, _size / 2));
                final _fixationPoint = ref.read(pointerFixationPointProvider);
                if (kDebugMode && widget.state.type == GazePointerType.active && _leftFixationRadius(temp, _fixationPoint, _fixationRadius)) {
                  _controller.reset();
                }
              }
            },
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 150),
              child: PointerCircle(type: widget.state.type, size: _size, animation: _animation),
            ),
          );
        },
      ),
    );
  }

  bool _leftFixationRadius(Offset gaze, Offset fixationPoint, double fixationRadius) {
    return (gaze - fixationPoint).distanceSquared > pow(fixationRadius, 2);
  }
}
