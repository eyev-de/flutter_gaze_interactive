//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextEditingControllerNotifier extends StateNotifier<String> {
  final TextEditingController controller;

  TextEditingControllerNotifier({required this.controller}) : super(controller.text) {
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_listener);
  }

  void _listener() {
    state = controller.text;
  }
}

class UndoHistoryControllerNotifier extends StateNotifier<bool> {
  final UndoHistoryController controller;

  UndoHistoryControllerNotifier({required this.controller}) : super(controller.value.canUndo) {
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_listener);
  }

  void _listener() {
    state = controller.value.canUndo;
  }
}

class RedoHistoryControllerNotifier extends StateNotifier<bool> {
  final UndoHistoryController controller;

  RedoHistoryControllerNotifier({required this.controller}) : super(controller.value.canRedo) {
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_listener);
  }

  void _listener() {
    state = controller.value.canRedo;
  }
}
