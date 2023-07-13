//  Gaze Widgets Lib
//
//  Created by the eyeV App Dev Team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'keyboard_controller.dart';
import 'keyboards.dart';

class GazeKeyboardState {
  final TextEditingController controller;
  final String placeholder;
  final FocusNode? node;
  final GazeKeyboardController keyboardController = GazeKeyboardController(WidgetsBinding.instance);
  final String route;
  final KeyboardType type;

  final languageStateProvider = StateProvider((ref) => Language.german);
  final shiftStateProvider = StateProvider((ref) => false);
  final capsLockStateProvider = StateProvider((ref) => false);
  final altStateProvider = StateProvider((ref) => false);
  final ctrlStateProvider = StateProvider((ref) => false);
  final selectingStateProvider = StateProvider((ref) => false);

  bool withProvider;

  final bool withCtrl;
  final bool withAlt;
  final bool withNumbers;

  GazeKeyboardState({
    required this.controller,
    this.placeholder = '',
    this.withProvider = true,
    this.node,
    this.route = '/',
    this.withCtrl = true,
    this.withAlt = true,
    this.withNumbers = true,
    this.type = KeyboardType.extended,
  });
}
