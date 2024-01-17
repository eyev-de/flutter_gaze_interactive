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
  GazeKeyboardState({
    required this.controller,
    this.undoHistoryController,
    this.node,
    this.route = '/',
    this.placeholder = '',
    this.withProvider = true,
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

  final TextEditingController controller;
  final UndoHistoryController? undoHistoryController;
  FocusNode? node;
  final String route;
  final String placeholder;
  bool withProvider;
  final bool withCtrl;
  final bool withAlt;
  final bool withNumbers;
  final KeyboardType type;
  Language language;
  void Function({bool selecting})? onMoveCursorDown;
  void Function({bool selecting})? onMoveCursorUp;
  void Function(BuildContext)? onTabClose;
  KeyboardPlatformType keyboardPlatformType;

  final GazeKeyboardController keyboardController = GazeKeyboardController(WidgetsBinding.instance);

  static KeyboardPlatformType getPlatformFromSystem() => Platform.isIOS ? KeyboardPlatformType.mobile : KeyboardPlatformType.desktop;

  final shiftStateProvider = StateProvider((ref) => false);
  final capsLockStateProvider = StateProvider((ref) => false);
  final altStateProvider = StateProvider((ref) => false);

  // IOS specific button, letters or signs (numbers and special characters)
  final signsStateProvider = StateProvider((ref) => false);
  final ctrlStateProvider = StateProvider((ref) => false);
  final selectingStateProvider = StateProvider((ref) => false);
  final disableStateProvider = StateProvider((ref) => false);
}
