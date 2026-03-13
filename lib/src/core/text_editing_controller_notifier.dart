//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextEditingControllerTextNotifier extends Notifier<String> {
  TextEditingControllerTextNotifier({required this.controller});
  final TextEditingController controller;

  void _listener() => state = controller.text;

  @override
  String build() {
    controller.addListener(_listener);
    ref.onDispose(() => controller.removeListener(_listener));
    return controller.text;
  }
}

class UndoHistoryControllerNotifier extends Notifier<bool> {
  UndoHistoryControllerNotifier({required this.controller});
  final UndoHistoryController controller;

  void _listener() => state = controller.value.canUndo;

  @override
  bool build() {
    controller.addListener(_listener);
    ref.onDispose(() => controller.removeListener(_listener));
    return controller.value.canUndo;
  }
}

class RedoHistoryControllerNotifier extends Notifier<bool> {
  RedoHistoryControllerNotifier({required this.controller});
  final UndoHistoryController controller;

  void _listener() => state = controller.value.canRedo;

  @override
  bool build() {
    controller.addListener(_listener);
    ref.onDispose(() => controller.removeListener(_listener));
    return controller.value.canRedo;
  }
}
