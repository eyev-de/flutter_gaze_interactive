//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaze_interactive/src/core/constants.dart';

import 'pointer_action.enum.dart';
import 'pointer_type.enum.dart';

part 'pointer_state.model.freezed.dart';

@freezed
class GazePointerState with _$GazePointerState {
  factory GazePointerState({
    // type: passive (static circle), active (circle with animation on fixation)
    @Default(GazePointerType.passive) GazePointerType type,
    // color of gaze pointer circle
    @Default(Colors.yellow) Color color,
    // applied opacity of the circle in specified color
    @Default(0.6) double opacity,
    // size of gaze pointer circle (default: 50)
    @Default(gazeInteractiveDefaultPointerSize) double size,
    // ignore gesture on pointer
    @Default(false) bool ignorePointer,
    // action on pointer
    @Default(GazePointerAction.click) GazePointerAction action,
    Function(Offset)? onAction,
  }) = _GazePointerState;

  GazePointerState._();
}
