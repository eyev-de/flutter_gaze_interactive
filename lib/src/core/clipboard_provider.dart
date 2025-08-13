//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipboard_provider.g.dart';

@Riverpod(keepAlive: true)
class ClipboardText extends _$ClipboardText with ClipboardListener {
  @override
  String build() {
    ref.onDispose(clipboardWatcher.stop);
    clipboardWatcher
      ..addListener(this)
      // start watch
      ..start();
    return '';
  }

  @override
  Future<void> onClipboardChanged() async {
    final content = await Clipboard.getData(Clipboard.kTextPlain);
    if (content != null && content.text != null && state != content.text) state = content.text!;
  }
}
