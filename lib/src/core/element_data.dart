//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'element_type.dart';

final class GazeElementData {
  GazeElementData({
    required this.key,
    this.route,
    this.type = GazeElementType.all,
    this.onGazeEnter,
    this.onGazeLeave,
    this.onGaze,
    this.onScroll,
    this.onSnap,
    this.onFixation,
    this.snappable = true,
  });
  final GlobalKey key;
  final String? route;
  final GazeElementType type;
  final bool snappable;

  final void Function()? onGazeEnter;
  final void Function()? onGazeLeave;
  final void Function(Offset)? onGaze;
  final void Function()? onScroll;
  final void Function()? onFixation;
  final void Function(GazeElementData snapElement)? onSnap;

  /// Last known global paint bounds, kept fresh by `GazeBoundsReporter` whenever
  /// this element lays out or paints. The gaze hit-test loop reads this instead
  /// of recomputing paint bounds from the render tree for every registered
  /// element on every gaze sample. `null` until first measured (the hit-test
  /// falls back to recomputing in that case).
  Rect? cachedBounds;
}

final class GazeSelectableData extends GazeElementData {
  GazeSelectableData({
    required super.key,
    required super.route,
    required super.onGazeEnter,
    required super.onGazeLeave,
    required super.snappable,
  }) : super(type: GazeElementType.selectable);
}

final class GazeScrollableData extends GazeElementData {
  GazeScrollableData({
    required super.key,
    required super.route,
    required super.onGazeEnter,
    required super.onGazeLeave,
    super.snappable = false,
  }) : super(type: GazeElementType.scrollable);
}

final class GazePointerData extends GazeElementData {
  GazePointerData({
    required super.key,
    required super.onGaze,
    super.onSnap,
    super.onFixation,
  }) : super(type: GazeElementType.pointer);
  Function(Offset, Size)? onPointerMove;
  void Function()? onIdle;
}
