//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'pointer_action.dart';
import 'pointer_type.dart';

class GazePointerState extends ChangeNotifier {
  GazePointerState({
    GazePointerType type = GazePointerType.passive,
    GazePointerAction action = GazePointerAction.click,
  })  : _type = type,
        _action = action;

  GazePointerType _type = GazePointerType.passive;
  GazePointerType get type => _type;
  set type(GazePointerType value) {
    _type = value;
    notifyListeners();
  }

  GazePointerAction _action = GazePointerAction.click;
  GazePointerAction get action => _action;
  set action(GazePointerAction value) {
    _action = value;
    notifyListeners();
  }

  void Function(Offset)? _onAction;
  void Function(Offset)? get onAction => _onAction;
  set onAction(void Function(Offset)? value) {
    _onAction = value;
    notifyListeners();
  }

  bool _ignorePointer = false;
  bool get ignorePointer => _ignorePointer;
  set ignorePointer(bool value) {
    _ignorePointer = value;
    notifyListeners();
  }
}
