//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class GazeKeyboardController extends WidgetController {
  GazeKeyboardController(WidgetsBinding binding) : super(binding);

  @override
  Future<List<Duration>> handlePointerEventRecord(List<PointerEventRecord> records) {
    return Future.value(List.filled(records.length, Duration.zero));
  }

  @override
  Future<void> pump([Duration duration = Duration.zero]) {
    return Future.delayed(duration);
  }

  @override
  Future<int> pumpAndSettle([Duration duration = const Duration(milliseconds: 100)]) {
    return Future.value(0);
  }
}
