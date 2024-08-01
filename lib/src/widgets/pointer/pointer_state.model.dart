//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'pointer_action.enum.dart';
import 'pointer_type.enum.dart';

part 'pointer_state.model.freezed.dart';

@freezed
class GazePointerState with _$GazePointerState {
  factory GazePointerState({
    // type: passive (static circle), active (circle with animation on fixation)
    @Default(GazePointerType.passive) GazePointerType type,
    // ignore gesture on pointer
    @Default(false) bool ignorePointer,
    // ignore gesture on pointer
    @Default(false) bool invisible,
    // action on pointer
    @Default(GazePointerAction.click) GazePointerAction action,
    Function(Offset)? onAction,
  }) = _GazePointerState;

  GazePointerState._();
}
