//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'controller.dart';
import 'keyboards.dart';

class GazeKeyboardState extends ChangeNotifier {
  final TextEditingController controller;
  final String placeholder;
  final FocusNode? node;
  final GazeKeyboardController keyboardController = GazeKeyboardController(WidgetsBinding.instance);
  final String route;

  Language _language;
  Language get language => _language;
  set language(Language value) {
    if (value != _language) {
      _language = value;
      notifyListeners();
    }
  }

  bool _shift = false;
  bool get shift => _shift;
  set shift(bool value) {
    if (value != _shift) {
      _shift = value;
      notifyListeners();
    }
  }

  bool _capsLock = false;
  bool get capsLock => _capsLock;
  set capsLock(bool value) {
    if (value != _capsLock) {
      _capsLock = value;
      notifyListeners();
    }
  }

  bool _alt = false;
  bool get alt => _alt;
  set alt(bool value) {
    if (value != _alt) {
      _alt = value;
      notifyListeners();
    }
  }

  bool _ctrl = false;
  bool get ctrl => _ctrl;
  set ctrl(bool value) {
    if (value != _ctrl) {
      _ctrl = value;
      notifyListeners();
    }
  }

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
    Language language = Language.german,
  }) : _language = language;
}
