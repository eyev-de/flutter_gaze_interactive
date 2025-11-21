import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../api.dart';
import '../../../core/extensions.dart';
import '../../../core/limited_queue.dart';

part 'pointer_view.provider.g.dart';

enum SnapState {
  off,
  on,
  inSnapTimer,
  readyToSnap,
  snapping,
  snapPaused;

  String get icon {
    return switch (this) {
      SnapState.off => '',
      SnapState.on => '🟢',
      SnapState.inSnapTimer => '⏱️',
      SnapState.readyToSnap => '🏁',
      SnapState.snapping => '🔥',
      SnapState.snapPaused => '⏸️',
    };
  }
}

/// Animation Controller
@riverpod
class PointerAnimationController extends _$PointerAnimationController {
  @override
  AnimationController build({required TickerProvider vsync}) {
    return AnimationController(vsync: vsync, duration: Duration(milliseconds: ref.watch(ref.read(gazeInteractiveProvider).duration)));
  }
}

// Animation
@riverpod
class PointerAnimation extends _$PointerAnimation {
  @override
  Animation<double> build({required TickerProvider vsync}) {
    return Tween<double>(begin: 0, end: 1).animate(ref.watch(pointerAnimationControllerProvider(vsync: vsync)));
  }
}

@riverpod
class PointerIsMoving extends _$PointerIsMoving {
  Timer? timer;

  @override
  bool build() {
    ref.onDispose(() => timer?.cancel());
    return true;
  }

  void move() {
    if (timer != null) {
      timer?.cancel();
      state = true;
    }
    // time delay when no more movement is detected
    timer = Timer(
      const Duration(milliseconds: 1200),
      () {
        state = false;
      },
    );
  }
}

/// Gaze Pointer appears shortly and is then faded out -> current opacity
@riverpod
class PointerOpacity extends _$PointerOpacity {
  @override
  double build() {
    final defaultOpacity = ref.watch(ref.read(gazeInteractiveProvider).pointerOpacity);
    final isMoving = ref.watch(pointerIsMovingProvider);
    final pointerAlwaysVisible = ref.watch(gazePointerAlwaysVisibleProvider);

    // Hide gaze pointer if no movements have been registered
    // -> debug: still visible to move
    // -> release: no longer visible
    if (isMoving == false) return pointerAlwaysVisible ? 0.2 : 0.0;
    return defaultOpacity;
  }

  void reset() => ref.invalidateSelf();
}

@riverpod
class PointerColor extends _$PointerColor {
  @override
  Color build({required GazePointerType type}) {
    return switch (type) {
      GazePointerType.active => ref.watch(ref.read(gazeInteractiveProvider).pointerColorActive).color,
      _ => ref.watch(ref.read(gazeInteractiveProvider).pointerColorPassive).color,
    };
  }
}

/// Gaze Pointer Circle Size
@riverpod
class PointerSize extends _$PointerSize {
  @override
  double build({required GazePointerType type}) {
    final double _size = ref.watch(ref.read(gazeInteractiveProvider).pointerSize);
    return switch (type) {
      GazePointerType.active => _size / 1.5,
      GazePointerType.history => _size / 2,
      _ => _size,
    };
  }
}

/// Gaze Pointer Offset
@riverpod
class PointerOffset extends _$PointerOffset {
  @override
  Offset build() => const Offset(200, 200);

  void update({required Offset offset}) {
    state = offset;
    ref.read(pointerHistoryProvider.notifier).addLimited(offset: offset);
  }
}

@riverpod
class PointerHistory extends _$PointerHistory {
  @override
  Queue<(GlobalKey key, Offset offset)> build() => Queue();

  void addLimited({required Offset offset}) {
    final limit = ref.watch(gazePointerHistoryNumberProvider);
    state.addWithLimit((GlobalKey(), offset), limit);
  }

  void removeLast() => state.removeLast();
}

/// Gaze Pointer Fixation Point
@Riverpod(keepAlive: true)
class PointerFixationPoint extends _$PointerFixationPoint {
  @override
  Offset build() => const Offset(0, 0);

  Offset get point => state;
  set point(Offset offset) => state = offset;
}

/// Gaze Pointer Snapping Point
@Riverpod(keepAlive: true)
class SnapElement extends _$SnapElement {
  @override
  GazeElementData? build() => null;

  GazeElementData? get element => state;
  set element(GazeElementData? element) => state = element;

  void refresh() => ref.invalidateSelf();
}

/// Gaze Pointer in snapp mode Point
@Riverpod(keepAlive: true)
class SnappingState extends _$SnappingState {
  @override
  SnapState build() => SnapState.off;

  // When in snap radius for the first time when SnapState.on
  void startSnapTimer(GazeElementData snapElement) {
    if (state == SnapState.on) {
      ref.read(snapElementProvider.notifier).element = snapElement;
      state = SnapState.inSnapTimer;
      // Timer to wait
      Timer(Duration(milliseconds: ref.read(ref.read(gazeInteractiveProvider).snappingTimerMilliseconds)), () {
        if (state == SnapState.inSnapTimer && ref.read(snapElementProvider)?.key == snapElement.key) {
          debugPrint('ready for ${ref.read(snapElementProvider)}');
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
      debugPrint('start snap');
      ref.read(ignorePointerStateProvider.notifier).isIgnored = true;
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
      Timer(Duration(milliseconds: ref.read(ref.read(gazeInteractiveProvider).afterSnapPauseMilliseconds)), () {
        if (state == SnapState.snapPaused && state != SnapState.off) {
          state = SnapState.on;
        }
      });
    }
  }

// when not in snap radius while state = SnapState.inSnapTimer
// -> stop being ready to snap
  void endSnap(GazeElementData snapElement) {
    debugPrint('end snap');
    // Only running snappscan be finished
    if (state != SnapState.off && ref.read(snapElementProvider)?.key == snapElement.key) {
      // user can move the pointer again
      ref.read(ignorePointerStateProvider.notifier).isIgnored = false;

      // refresh element we were snapping to
      ref.read(snapElementProvider.notifier).refresh();

      // wait a bit until next snap is possible
      state = SnapState.snapPaused;
      // Timer to wait
      Timer(Duration(milliseconds: ref.read(ref.read(gazeInteractiveProvider).afterSnapPauseMilliseconds)), () {
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
  double build() => ref.watch(ref.read(gazeInteractiveProvider).fixationRadius);

  double get radius => state;
  set radius(double radius) => state = radius;
}

/// Gaze Pointer Snapping Radius
@riverpod
class PointerSnappingRadius extends _$PointerSnappingRadius {
  @override
  double build() => ref.watch(ref.read(gazeInteractiveProvider).snappingRadius);

  double get radius => state;
  set radius(double radius) => state = radius;
}

/// Indicates if recently snapped and pointer is ignored by mouse
@riverpod
class IgnorePointerState extends _$IgnorePointerState {
  @override
  bool build() => false;

  bool get isIgnored => state;
  set isIgnored(bool ignore) => state = ignore;

  void deactivate() => state = false;
}
