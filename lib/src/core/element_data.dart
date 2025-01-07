//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'element_type.dart';

final class GazeElementData {
  const GazeElementData({
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
}

final class GazeSelectableData extends GazeElementData {
  const GazeSelectableData({
    required super.key,
    required super.route,
    required super.onGazeEnter,
    required super.onGazeLeave,
    required super.snappable,
  }) : super(type: GazeElementType.selectable);
}

final class GazeScrollableData extends GazeElementData {
  const GazeScrollableData({
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
}
