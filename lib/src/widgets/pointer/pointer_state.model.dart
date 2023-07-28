//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'pointer_action.dart';
import 'pointer_type.dart';

part 'pointer_state.model.freezed.dart';

@freezed
class GazePointerState with _$GazePointerState {
  factory GazePointerState({
    @Default(GazePointerType.passive) GazePointerType type,
    @Default(GazePointerAction.click) GazePointerAction action,
    @Default(false) bool ignorePointer,
    Function(Offset)? onAction,
  }) = _GazePointerState;

  GazePointerState._();
}
