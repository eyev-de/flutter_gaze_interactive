import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/extensions.dart';
import '../../../state.dart';
import '../pointer_type.enum.dart';

part 'pointer_view.provider.g.dart';

enum SnapState { off, on, inSnapTimer, readyToSnap, snapping, snapPaused }

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

/// Gaze Pointer Local Offset
@riverpod
class PointerLocalOffset extends _$PointerLocalOffset {
  @override
  Offset build() => const Offset(0, 0);

  void update({required Offset offset}) => state = offset;
}

/// Gaze Pointer Fixation Point
@riverpod
class PointerFixationPoint extends _$PointerFixationPoint {
  @override
  Offset build() => const Offset(0, 0);

  void update({required Offset offset}) => state = offset;
}

/// Gaze Pointer Snapping Point
@Riverpod(keepAlive: true)
class SnapElement extends _$SnapElement {
  @override
  Rect build() => Rect.fromCenter(center: const Offset(0, 0), width: 0, height: 0);

  void update({required Rect snapElement}) => state = snapElement;

  void refresh() => ref.invalidateSelf();
}

/// Gaze Pointer in snapp mode Point
@Riverpod(keepAlive: true)
class SnappingState extends _$SnappingState {
  @override
  SnapState build() => SnapState.on;

// When in snap radius for the first time
  void startSnapTimer() {
    state = SnapState.inSnapTimer;
    // Timer to wait
    Timer(Duration(milliseconds: ref.watch(GazeInteractive().snappingTimerMilliseconds)), () {
      state = SnapState.readyToSnap;
    });
  }

  // When still in snap radius when readyToSnap -> snap and then snapFinished
  void startSnap() {
    state = SnapState.snapping;
    ref.read(ignorePointerProvider.notifier).update(ignore: true);
  }

  // After snap movement is done -> snapFinished
  void snapFinished() {
    // user can move the pointer again
    ref.read(ignorePointerProvider.notifier).update(ignore: false);

    // wait a bit until next snap is possible
    state = SnapState.snapPaused;

    // Timer to wait
    Timer(Duration(milliseconds: ref.watch(GazeInteractive().afterSnapPauseMilliseconds)), () {
      state = SnapState.on;
    });
  }

// when not in snap radius while state = SnapState.inSnapTimer
// -> stop being ready to snap
  void leftWhileSnapping() {
    // wait a bit until next snap is possible
    state = SnapState.snapPaused;
    // Timer to wait
    Timer(Duration(milliseconds: ref.watch(GazeInteractive().afterSnapPauseMilliseconds)), () {
      state = SnapState.on;
    });
  }

  void turnOff() {
    state = SnapState.off;
  }
}

/// Gaze Pointer Fixation Radius
@riverpod
class PointerFixationRadius extends _$PointerFixationRadius {
  @override
  double build() => ref.watch(GazeInteractive().fixationRadius);

  void update({required double radius}) => state = radius;
}

/// Gaze Pointer Snapping Radius
@riverpod
class PointerSnappingRadius extends _$PointerSnappingRadius {
  @override
  double build() => ref.watch(GazeInteractive().snappingRadius);

  void update({required double radius}) => state = radius;
}

/// Indicates if recently snapped and pointer is ignored by mouse
@riverpod
class IgnorePointer extends _$IgnorePointer {
  @override
  bool build() => false;

  void update({required bool ignore}) {
    state = ignore;
  }

  void deactivate() => state = false;
}
