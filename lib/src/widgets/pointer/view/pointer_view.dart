//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/element_data.dart';
import '../../../core/element_type.dart';
import '../../../core/extensions.dart';
import '../../../state.dart';
import '../pointer_state.model.dart';
import '../pointer_type.enum.dart';
import 'pointer_circle.dart';
import 'pointer_view.provider.dart';

class GazePointerView extends ConsumerWidget {
  GazePointerView({Key? key, GazePointerState? state})
      : _state = state ?? GazePointerState(),
        super(key: key);

  final GazePointerState _state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if (_state.type == GazePointerType.passive) return _PointerPassiveView(state: _state);
    final ignorePointer = ref.watch(ignorePointerStateProvider);
    return _PointerView(state: _state.copyWith(ignorePointer: ignorePointer));
  }
}

class _PointerView extends ConsumerStatefulWidget {
  const _PointerView({Key? key, required this.state}) : super(key: key);

  final GazePointerState state;

  @override
  _PointerViewState createState() => _PointerViewState();
}

class _PointerViewState extends ConsumerState<_PointerView> with TickerProviderStateMixin {
  _PointerViewState();

  final _wrappedKey = GlobalKey();
  bool _isDragging = false;

  /// GazePointerData
  late final gazePointerData = GazePointerData(
    key: _wrappedKey,
    onGaze: _onGazeData,
    onFixation: _onFixation,
    onSnap: _onSnap,
  );

  // on moving -> updated gaze data
  void _onGazeData(Offset gaze) {
    // ignore moving when dragging
    if (_isDragging) return;
    // update pointer position
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.state.ignorePointer) {
        ref.read(pointerIsMovingProvider.notifier).move();
        final size = ref.read(pointerSizeProvider(type: widget.state.type));
        final pos = gaze - Offset(size / 2, size / 2);
        final clamped = widget.state.canLeaveBounds ? pos : context.validateGazePointer(offset: pos, size: size);
        ref.read(pointerOffsetProvider.notifier).update(offset: clamped);
        gazePointerData.onPointerMove?.call(clamped + Offset(size / 2, size / 2), Size(size, size));
        if (widget.state.type == GazePointerType.active && _leftFixationRadius(gaze)) {
          ref.read(pointerAnimationControllerProvider(vsync: this)).reset();
        }
        // // Calculate if leaving snap radius
        // if (ref.read(snappingStateProvider) == SnapState.inSnapTimer) {
        //   if (_leftSnappingRadius(gaze)) {
        //     // Test if not in same snap point radius
        //     ref.read(snappingStateProvider.notifier).leftWhileSnapping(snapElement);
        //     ref.read(pointerAnimationControllerProvider(vsync: this)).reset();
        //   }
        // }
      }
    });
  }

  // on fixation -> user focuses on one point
  void _onFixation() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.state.type == GazePointerType.active && !ref.watch(pointerAnimationControllerProvider(vsync: this)).isAnimating) {
        ref.read(pointerFixationPointProvider.notifier).point = ref.read(pointerOffsetProvider);
        ref.read(pointerAnimationControllerProvider(vsync: this)).forward();
      }
    });
  }

  // on snap -> whenever user was close enough to a button
  void _onSnap(GazeElementData snapElement) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // really move the pointer
      final Offset includingSizeSnapToOffset = _getOffsetWithSizeDeviation(snapElement.key.globalPaintBounds!);
      if (mounted && !ref.watch(pointerAnimationControllerProvider(vsync: this)).isAnimating) {
        if (ref.read(snappingStateProvider) == SnapState.on) {
          // wait for x milliseconds until snapping can be started
          ref.read(snappingStateProvider.notifier).startSnapTimer(snapElement);
          // really move the pointer
        }
        // It has to be in the same snap elements radius when snapping
        if (ref.read(snappingStateProvider) == SnapState.readyToSnap) {
          ref.read(snappingStateProvider.notifier).startSnap(snapElement);
          //snap and set snap point (including size deviation due to pointer size)
          _onGazeData(includingSizeSnapToOffset);
          // reset ignorePointer after manual moving (snapping) pointer in snapFinished
          // Timer(const Duration(milliseconds: timeToIgnorePointerWhenSnappingMs), () {
          //   ref.read(snappingStateProvider.notifier).endSnap(snapElement);
          // });
        }
      }
    });
  }

  Offset _getOffsetWithSizeDeviation(Rect snapElement) {
    final _size = ref.read(pointerSizeProvider(type: widget.state.type));
    return Offset(snapElement.center.dx + _size / 2, snapElement.center.dy + _size / 2);
  }

  @override
  void initState() {
    super.initState();
    // fade out gaze pointer
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (mounted) ref.read(pointerIsMovingProvider.notifier).move();
    });
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
    ref.read(gazeInteractiveProvider).register(gazePointerData);
  }

  @override
  void deactivate() {
    ref.read(gazeInteractiveProvider).unregister(key: _wrappedKey, type: GazeElementType.pointer);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final _size = ref.watch(pointerSizeProvider(type: widget.state.type));
    final _pointerOffset = ref.watch(pointerOffsetProvider);
    final _opacity = ref.watch(pointerOpacityProvider);
    final calculatedOpacity = widget.state.absoluteOpacityValue != null ? widget.state.absoluteOpacityValue! : _opacity;
    final _controller = ref.watch(pointerAnimationControllerProvider(vsync: this));
    final _animation = ref.watch(pointerAnimationProvider(vsync: this));
    return Stack(
      children: [
        // HISTORY POINTER
        if (widget.state.type == GazePointerType.history) ...[
          _PointerHistory(size: _size),
          // history pointer on top of faded out pointers - draggable
          Positioned(
            left: _pointerOffset.dx,
            top: _pointerOffset.dy,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                _isDragging = true;
                _callOnGazeNormalized(context, details.globalPosition, _size);
              },
              onPanUpdate: (details) {
                _callOnGazeNormalized(context, details.globalPosition, _size);
              },
              onPanEnd: (_) => _isDragging = false,
              onPanCancel: () => _isDragging = false,
              child: PointerCircle(
                type: GazePointerType.history,
                size: _size,
                animation: _animation,
              ),
            ),
          ),
        ],
        // ACTIVE / PASSIVE POINTER
        if (widget.state.type != GazePointerType.history)
          Positioned(
            left: _pointerOffset.dx,
            top: _pointerOffset.dy,
            child: Builder(
              builder: (context) {
                // ignore gesture on pointer
                if (widget.state.ignorePointer) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    onTapDown: (details) {
                      if (mounted) {
                        final element = ref.read(snapElementProvider);
                        if (element != null) ref.read(snappingStateProvider.notifier).endSnap(element);
                      }
                    },
                    child: AnimatedOpacity(
                      opacity: calculatedOpacity,
                      duration: const Duration(milliseconds: 150),
                      child: PointerCircle(type: widget.state.type, size: _size, animation: _animation),
                    ),
                  );
                }
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {},
                  onTapDown: (details) {
                    if (mounted && kDebugMode) {
                      ref.read(gazeInteractiveProvider).onFixation();
                    }
                  },
                  onTapUp: (details) {
                    if (kDebugMode && widget.state.type == GazePointerType.active && !_controller.isAnimating) {
                      _controller.forward();
                    }
                  },
                  onPanStart: (details) {
                    _isDragging = true;
                    _callOnGazeNormalized(context, details.globalPosition, _size);
                  },
                  onPanUpdate: (details) {
                    _callOnGazeNormalized(context, details.globalPosition, _size);
                  },
                  onPanEnd: (_) => _isDragging = false,
                  onPanCancel: () => _isDragging = false,
                  child: AnimatedOpacity(
                    opacity: calculatedOpacity,
                    duration: const Duration(milliseconds: 150),
                    child: PointerCircle(type: widget.state.type, size: _size, animation: _animation),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _callOnGazeNormalized(BuildContext context, Offset global, double size) {
    final center = global;
    final topLeft = center - Offset(size / 2, size / 2);
    final clampedTopLeft = context.validateGazePointer(offset: topLeft, size: size);
    ref.read(pointerOffsetProvider.notifier).update(offset: clampedTopLeft);
    ref.read(gazeInteractiveProvider).onDragMove(clampedTopLeft + Offset(size / 2, size / 2), origin: _wrappedKey, size);
  }

  bool _leftFixationRadius(Offset gaze) {
    final _fixationPoint = ref.read(pointerFixationPointProvider);
    final _fixationRadius = ref.read(pointerFixationRadiusProvider);
    return (gaze - _fixationPoint).distanceSquared > pow(_fixationRadius, 2);
  }
}

/// Widget to show pointer history with fade out animation
class _PointerHistory extends ConsumerWidget {
  const _PointerHistory({required this.size});

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _pointerHistory = ref.watch(pointerHistoryProvider);
    return Stack(
      children: [
        ..._pointerHistory.toList().mapIndexed((element, index) {
          return Positioned(
            left: element.$2.dx,
            top: element.$2.dy,
            child: TweenAnimationBuilder<double>(
              key: element.$1,
              tween: Tween(begin: 1, end: 0),
              duration: const Duration(seconds: 1),
              builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
              onEnd: () {
                if (_pointerHistory.isEmpty) return;
                if (index != _pointerHistory.length - 1) return;
                // Ensure that the last item is removed after fading out
                Future.delayed(const Duration(seconds: 1), _pointerHistory.removeLast);
              },
              child: PointerCircle(type: GazePointerType.history, size: size),
            ),
          );
        })
      ],
    );
  }
}
