//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/simple_notifiers.dart';
import 'keyboard_controller.dart';
import 'keyboard_key_type.enum.dart';
import 'keyboards.dart';

class GazeKeyboardState {
  GazeKeyboardState({
    required this.controller,
    this.undoHistoryController,
    this.node,
    required this.route,
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
    this.onKey,
    KeyboardPlatformType? selectedKeyboardPlatformType,
    this.inputFormatters = const [],
    this.validationView,
    this.headerView,
    this.submitIcon = Icons.check,
    this.submitLabel,
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
  void Function({Object? data, required GazeKeyType type})? onKey;
  void Function({bool selecting})? onMoveCursorDown;
  void Function({bool selecting})? onMoveCursorUp;
  void Function(BuildContext)? onTabClose;
  KeyboardPlatformType keyboardPlatformType;

  final GazeKeyboardController keyboardController = GazeKeyboardController(WidgetsBinding.instance);

  static KeyboardPlatformType getPlatformFromSystem() => Platform.isIOS || Platform.isAndroid ? KeyboardPlatformType.mobile : KeyboardPlatformType.desktop;

  final shiftStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));
  final capsLockStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));
  final altStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));

  // IOS specific button, letters or signs (numbers and special characters)
  final signsStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));
  final ctrlStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));
  final selectingStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));
  final selectingWordStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));
  final disableStateProvider = NotifierProvider<BoolNotifier, bool>(() => BoolNotifier(false));

  final List<TextInputFormatter> inputFormatters;

  // Validation widget for the entered text – centered directly below the text field
  final Widget? validationView;

  // App-provided widget shown in the otherwise empty area ABOVE the text field (e.g. the message being answered on a
  // messaging compose page). Bottom-aligned onto the text row; it gets the space the top spacer had, so the keyboard's own
  // rows never move because of it.
  final Widget? headerView;

  // The icon of the submit button (top left, two keys wide). The check mark by default - it means "done with this field"
  // everywhere in the app. A messaging compose page passes a send icon, because there that button hands the text to the
  // chat rather than closing a field.
  final IconData submitIcon;

  // Label shown next to the submit icon; null (the default) renders the icon alone. A check mark already means "done"
  // to everyone, so only the scenarios where the button does something more specific than closing the field spell it
  // out - "Send", "Comment" (user decision 2026-09-14). Passed in already translated: this package has no localization.
  final String? submitLabel;

  // Replaces the keys grid with an app-provided view while non-null (e.g. an emoji keyboard) - same box, same height:
  // everything above (text field, utility row, validation view) stays exactly where it is. Swappable at runtime.
  final ValueNotifier<Widget?> keysOverride = ValueNotifier<Widget?>(null);
}
