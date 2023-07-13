//  Gaze Interactive
//
//  Created by the eyeV App Dev Team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clipboardProvider = StateNotifierProvider((ref) => _ClipboardNotifier());

class _ClipboardNotifier extends StateNotifier<String> {
  late Timer clipboardTriggerTime;
  _ClipboardNotifier() : super('') {
    clipboardTriggerTime = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final content = await Clipboard.getData('text/plain');
      if (content != null && content.text != null && state != content.text) state = content.text!;
    });
  }
}
