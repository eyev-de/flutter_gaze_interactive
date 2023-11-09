import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../api.dart';
import '../../../core/extensions.dart';

part 'pointer_view.provider.g.dart';

enum SnapState {
  off,
  on,
  inSnapTimer,
  readyToSnap,
  snapping,
  snapPaused;

  @override
  String toString() {
    switch (this) {
      case SnapState.off:
        return '';
      case SnapState.on:
        return '🟢';
      case SnapState.inSnapTimer:
        return '⏱️';
      case SnapState.readyToSnap:
        return '🏁';
      case SnapState.snapping:
        return '🔥';
      case SnapState.snapPaused:
        return '⏸️';
    }
  }
}

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

/// Gaze Pointer Snapping Point
@Riverpod(keepAlive: true)
class SnapElement extends _$SnapElement {
  @override
  GazeElementData? build() => null;

  void update({required GazeElementData snapElement}) => state = snapElement;

  void refresh() => ref.invalidateSelf();
}

/// Gaze Pointer in snapp mode Point
@Riverpod(keepAlive: true)
class SnappingState extends _$SnappingState {
  @override
  SnapState build() => SnapState.on;

  // When in snap radius for the first time when SnapState.on
  void startSnapTimer(GazeElementData snapElement) {
    if (state == SnapState.on) {
      ref.read(snapElementProvider.notifier).update(snapElement: snapElement);
      state = SnapState.inSnapTimer;
      // Timer to wait
      Timer(Duration(milliseconds: ref.read(GazeInteractive().snappingTimerMilliseconds)), () {
        if (state == SnapState.inSnapTimer && ref.read(snapElementProvider)?.key == snapElement.key) {
          print('ready for ${ref.read(snapElementProvider)}');
          state = SnapState.readyToSnap;
          // if not snapped after 1 second -> rest
          Timer(const Duration(seconds: 1), () {
            if (state == SnapState.readyToSnap && state != SnapState.off) {
              ref.read(snapElementProvider.notifier).refresh();
              state = SnapState.on;
            }
          });
        }
      });
    }
  }

  // When still in snap radius when readyToSnap -> snap and then snapFinished
  void startSnap(GazeElementData snapElement) {
    if (state == SnapState.readyToSnap && ref.read(snapElementProvider)?.key == snapElement.key) {
      state = SnapState.snapping;
      print('stat snap');
      ref.read(ignorePointerStateProvider.notifier).update(ignore: true);
    }
  }

  // After snap movement is done -> snapFinished
  void cancelSnap(GazeElementData snapElement) {
    // Only running snappscan be finished
    if ((state == SnapState.inSnapTimer || state == SnapState.readyToSnap) && ref.read(snapElementProvider)?.key == snapElement.key) {
      // refresh element we were snapping to
      ref.read(snapElementProvider.notifier).refresh();

      // wait a bit until next snap is possible
      state = SnapState.snapPaused;
      // Timer to wait
      Timer(Duration(milliseconds: ref.read(GazeInteractive().afterSnapPauseMilliseconds)), () {
        if (state == SnapState.snapPaused && state != SnapState.off) {
          state = SnapState.on;
        }
      });
    }
  }

// when not in snap radius while state = SnapState.inSnapTimer
// -> stop being ready to snap
  void endSnap(GazeElementData snapElement) {
    print('end snap');
    // Only running snappscan be finished
    if (state != SnapState.off && ref.read(snapElementProvider)?.key == snapElement.key) {
      // user can move the pointer again
      ref.read(ignorePointerStateProvider.notifier).update(ignore: false);

      // refresh element we were snapping to
      ref.read(snapElementProvider.notifier).refresh();

      // wait a bit until next snap is possible
      state = SnapState.snapPaused;
      // Timer to wait
      Timer(Duration(milliseconds: ref.read(GazeInteractive().afterSnapPauseMilliseconds)), () {
        if (state == SnapState.snapPaused && state != SnapState.off) {
          state = SnapState.on;
        }
      });
    }
  }

  void turnOff() {
    ref.read(snapElementProvider.notifier).refresh();
    state = SnapState.off;
  }

  void reset() {
    ref.read(snapElementProvider.notifier).refresh();
    state = SnapState.on;
  }
}

/// Gaze Pointer Fixation Radius
@Riverpod(keepAlive: true)
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
class IgnorePointerState extends _$IgnorePointerState {
  @override
  bool build() => false;

  void update({required bool ignore}) {
    print('--> ignore $ignore');
    state = ignore;
  }

  void deactivate() => state = false;
}
