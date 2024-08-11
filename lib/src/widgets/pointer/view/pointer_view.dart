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
    return _PointerView(state: _state.copyWith(ignorePointer: ref.watch(ignorePointerStateProvider)));
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

  final GlobalKey _wrappedkey = GlobalKey();

  /// GazePointerData
  late final gazePointerData = GazePointerData(
    key: _wrappedkey,
    onGaze: _onGazeData,
    onFixation: _onFixation,
    onSnap: _onSnap,
  );

  // on moving -> updated gaze data
  void _onGazeData(Offset gaze) {
    if (mounted && !widget.state.ignorePointer) {
      ref.read(pointerIsMovingProvider.notifier).move();
      final _size = ref.read(pointerSizeProvider(type: widget.state.type));
      final Offset temp = context.validateGazePointer(offset: gaze - Offset(_size / 2, _size / 2), size: _size);
      ref.read(pointerOffsetProvider.notifier).update(offset: temp);
      gazePointerData.onPointerMove?.call(temp + Offset(_size / 2, _size / 2), Size(_size, _size));
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
  }

  // on fixation -> user focuses on one point
  void _onFixation() {
    if (mounted && widget.state.type == GazePointerType.active && !ref.watch(pointerAnimationControllerProvider(vsync: this)).isAnimating) {
      ref.read(pointerFixationPointProvider.notifier).update(offset: ref.read(pointerOffsetProvider));
      ref.read(pointerAnimationControllerProvider(vsync: this)).forward();
    }
  }

  // on snap -> whenever user was close enough to a button
  void _onSnap(GazeElementData snapElement) {
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
    final _pointerHistory = ref.watch(pointerHistoryProvider);

    final _opacity = ref.watch(pointerOpacityProvider);
    final calculatedOpacity = widget.state.absoluteOpacityValue != null ? widget.state.absoluteOpacityValue! : _opacity;
    final _controller = ref.watch(pointerAnimationControllerProvider(vsync: this));
    final _animation = ref.watch(pointerAnimationProvider(vsync: this));
    return Stack(
      children: [
        if (widget.state.type == GazePointerType.history)
          ...List.from(
            _pointerHistory.toList().mapIndexed(
              (element, index) {
                return Positioned(
                  left: _size / 2 + element.$2.dx - _size / 5 / 2,
                  top: _size / 2 + element.$2.dy - _size / 5 / 2,
                  child: TweenAnimationBuilder(
                    key: element.$1,
                    tween: Tween<double>(begin: 1, end: 0),
                    duration: const Duration(seconds: 1),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: child,
                      );
                    },
                    child: PointerCircle(
                      type: GazePointerType.history,
                      size: _size / 5,
                      animation: _animation,
                    ),
                    // Use a unique delay based on index
                    onEnd: () {
                      if (index == _pointerHistory.length - 1) {
                        // Ensure that the last item is removed after fading out
                        Future.delayed(const Duration(seconds: 1), () {
                          if (_pointerHistory.isNotEmpty) {
                            _pointerHistory.removeLast();
                          }
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
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
                      GazeInteractive().onFixation();
                    }
                  },
                  onTapUp: (details) {
                    if (kDebugMode && widget.state.type == GazePointerType.active && !_controller.isAnimating) {
                      _controller.forward();
                    }
                  },
                  onPanStart: (details) {
                    if (mounted) {
                      callOnGazeNormalized(context, details.globalPosition, _size);
                    }
                  },
                  onPanUpdate: (details) {
                    if (mounted) {
                      callOnGazeNormalized(context, details.globalPosition, _size);
                    }
                  },
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

  void callOnGazeNormalized(BuildContext context, Offset globalPosition, double _size) {
    final Offset temp = context.validateGazePointer(offset: globalPosition, size: _size);
    ref.read(pointerOffsetProvider.notifier).update(offset: temp);
    GazeInteractive().onGaze(temp);
  }

  bool _leftFixationRadius(Offset gaze) {
    final _fixationPoint = ref.read(pointerFixationPointProvider);
    final _fixationRadius = ref.read(pointerFixationRadiusProvider);
    return (gaze - _fixationPoint).distanceSquared > pow(_fixationRadius, 2);
  }
}
