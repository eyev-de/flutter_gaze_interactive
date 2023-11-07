import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/extensions.dart';
import '../../../state.dart';
import '../pointer_type.enum.dart';

part 'pointer_view.provider.g.dart';

/// Animation Controller
@riverpod
class PointerAnimationController extends _$PointerAnimationController {
  @override
  AnimationController build({required TickerProvider vsync}) =>
      AnimationController(vsync: vsync, duration: Duration(milliseconds: ref.watch(GazeInteractive().duration)));
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
  double build() => ref.watch(GazeInteractive().pointerOpacity);

  void fadeOut() => Future.delayed(const Duration(milliseconds: 1200), () => state = kDebugMode ? 0.6 : 0.0);

  void reset() => ref.invalidateSelf();
}

@riverpod
class PointerColor extends _$PointerColor {
  @override
  Color build({required GazePointerType type}) {
    return switch (type) {
      GazePointerType.active => ref.watch(GazeInteractive().pointerColorActive).color,
      _ => ref.watch(GazeInteractive().pointerColorPassive).color,
    };
  }
}

/// Gaze Pointer Circle Size
@riverpod
class PointerSize extends _$PointerSize {
  @override
  double build({required GazePointerType type}) {
    final double _size = ref.watch(GazeInteractive().pointerSize);
    return switch (type) {
      GazePointerType.active => _size / 1.5,
      _ => _size,
    };
  }
}

/// Gaze Pointer Offset
@riverpod
class PointerOffset extends _$PointerOffset {
  @override
  Offset build() => kDebugMode ? const Offset(100, 100) : const Offset(0, 0);

  void update({required Offset offset}) => state = offset;
}

/// Gaze Pointer Fixation Point
@Riverpod(keepAlive: true)
class PointerFixationPoint extends _$PointerFixationPoint {
  @override
  Offset build() => const Offset(0, 0);

  void update({required Offset offset}) => state = offset;
}

/// Gaze Pointer Fixation Radius
@Riverpod(keepAlive: true)
class PointerFixationRadius extends _$PointerFixationRadius {
  @override
  double build() => ref.watch(GazeInteractive().fixationRadius);

  void update({required double radius}) => state = radius;
}
