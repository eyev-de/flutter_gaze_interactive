//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'element_type.dart';

final class GazeElementData {
  final GlobalKey key;
  final String? route;
  final GazeElementType type;

  final void Function()? onGazeEnter;
  final void Function(int recoverTime)? onGazeLeave;
  final void Function(Offset)? onGaze;
  final void Function()? onScroll;
  final void Function()? onFixation;

  const GazeElementData({
    required this.key,
    this.route,
    this.type = GazeElementType.all,
    this.onGazeEnter,
    this.onGazeLeave,
    this.onGaze,
    this.onScroll,
    this.onFixation,
  });
}

final class GazeSelectableData extends GazeElementData {
  const GazeSelectableData({
    required super.key,
    required super.route,
    required super.onGazeEnter,
    required super.onGazeLeave,
  }) : super(type: GazeElementType.selectable);
}

final class GazeScrollableData extends GazeElementData {
  const GazeScrollableData({
    required super.key,
    required super.route,
    required super.onGazeEnter,
    required super.onGazeLeave,
  }) : super(type: GazeElementType.scrollable);
}

final class GazePointerData extends GazeElementData {
  Function(Offset, Size)? onPointerMove;
  GazePointerData({
    required super.key,
    required super.onGaze,
    super.onFixation,
  }) : super(type: GazeElementType.pointer);
}
