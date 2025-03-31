//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clipboardProvider = StateNotifierProvider((ref) => _ClipboardNotifier());

class _ClipboardNotifier extends StateNotifier<String> {
  _ClipboardNotifier() : super('') {
    clipboardTriggerTime = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      try {
        final content = await Clipboard.getData('text/plain');
        if (content != null && content.text != null && state != content.text) state = content.text!;
      } catch (e) {
        // ignore
      }
    });
  }
  late Timer clipboardTriggerTime;
}
