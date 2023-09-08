//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'keyboard_controller.dart';
import 'keyboards.dart';

class GazeKeyboardState {
  final TextEditingController controller;
  final String placeholder;
  FocusNode? node;
  final GazeKeyboardController keyboardController = GazeKeyboardController(WidgetsBinding.instance);
  final String route;
  final KeyboardType type;
  Language language;
  KeyboardPlatformType keyboardPlatformType;
  void Function(BuildContext)? onTabClose;

  void Function({bool selecting})? onMoveCursorUp;
  void Function({bool selecting})? onMoveCursorDown;

  final shiftStateProvider = StateProvider((ref) => false);
  final capsLockStateProvider = StateProvider((ref) => false);
  final altStateProvider = StateProvider((ref) => false);
  // IOS specific button, letters or signs (numbers and special characters)
  final signsStateProvider = StateProvider((ref) => false);

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
    this.language = Language.german,
    this.onMoveCursorDown,
    this.onMoveCursorUp,
    this.onTabClose,
    KeyboardPlatformType? selectedKeyboardPlatformType,
  }) : keyboardPlatformType = selectedKeyboardPlatformType ?? getPlatformFromSystem();

  static KeyboardPlatformType getPlatformFromSystem() => Platform.isIOS ? KeyboardPlatformType.mobile : KeyboardPlatformType.desktop;
}
