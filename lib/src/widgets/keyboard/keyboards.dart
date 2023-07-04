//  Gaze Keyboard Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';

import 'keyboard_key.dart';
import 'keyboard_state.dart';

enum Language {
  german,
  english,
  speak,
}

class Keyboards {
  static List<List<Widget>> get(
    Language lang,
    GazeKeyboardState keyboardState,
  ) {
    switch (lang) {
      case Language.german:
        return _german(keyboardState);
      case Language.english:
        return _english(keyboardState);
      case Language.speak:
        return _speak(keyboardState);
    }
  }

  static List<List<Widget>> _german(GazeKeyboardState keyboardState) {
    return [
      [
        GazeKey(content: const ['°', '^'], keyboardState: keyboardState),
        GazeKey(content: const ['!', '1'], keyboardState: keyboardState),
        GazeKey(content: const ['"', '2'], keyboardState: keyboardState),
        GazeKey(content: const ['§', '3'], keyboardState: keyboardState),
        GazeKey(content: const [r'$', '4'], keyboardState: keyboardState),
        GazeKey(content: const ['%', '5'], keyboardState: keyboardState),
        GazeKey(content: const ['&', '6'], keyboardState: keyboardState),
        GazeKey(content: const ['/', '7'], keyboardState: keyboardState),
        GazeKey(content: const ['(', '8'], keyboardState: keyboardState),
        GazeKey(content: const [')', '9'], keyboardState: keyboardState),
        GazeKey(content: const ['=', '0'], keyboardState: keyboardState),
        GazeKey(content: const ['?', 'ß'], keyboardState: keyboardState),
        // GazeKey(content: const ['`', '´'], keyboardState: keyboardState),
        // GazeKey(content: Icons.keyboard_backspace_rounded, widthRatio: 2.2, type: GazeKeyType.del),
      ],
      [
        // GazeKey(content: Icons.keyboard_tab_rounded, type: GazeKeyType.tab), // widthRatio: 1.7
        GazeKey(content: 'q', keyboardState: keyboardState),
        GazeKey(content: 'w', keyboardState: keyboardState),
        GazeKey(content: 'e', keyboardState: keyboardState),
        GazeKey(content: 'r', keyboardState: keyboardState),
        GazeKey(content: 't', keyboardState: keyboardState),
        GazeKey(content: 'z', keyboardState: keyboardState),
        GazeKey(content: 'u', keyboardState: keyboardState),
        GazeKey(content: 'i', keyboardState: keyboardState),
        GazeKey(content: 'o', keyboardState: keyboardState),
        GazeKey(content: 'p', keyboardState: keyboardState),
        GazeKey(content: 'ü', keyboardState: keyboardState),
        GazeKey(content: const ['*', '+'], keyboardState: keyboardState),
        // GazeKey(content: 'Enter', widthRatio: 1.5, type: GazeKeyType.enter),
      ],
      [
        // GazeKey(content: Icons.keyboard_capslock_rounded, shift: capsLock, type: GazeKeyType.caps), // widthRatio: 2
        GazeKey(content: 'a', keyboardState: keyboardState),
        GazeKey(content: 's', keyboardState: keyboardState),
        GazeKey(content: 'd', keyboardState: keyboardState),
        GazeKey(content: 'f', keyboardState: keyboardState),
        GazeKey(content: 'g', keyboardState: keyboardState),
        GazeKey(content: 'h', keyboardState: keyboardState),
        GazeKey(content: 'j', keyboardState: keyboardState),
        GazeKey(content: 'k', keyboardState: keyboardState),
        GazeKey(content: 'l', keyboardState: keyboardState),
        GazeKey(content: 'ö', keyboardState: keyboardState),
        GazeKey(content: 'ä', keyboardState: keyboardState),
        GazeKey(content: const ["'", '#'], keyboardState: keyboardState),
        // GazeKey(content: 'Enter', widthRatio: 1.2, type: GazeKeyType.enter),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, type: GazeKeyType.shift, keyboardState: keyboardState), // , widthRatio: 1.5
        GazeKey(content: const ['>', '<'], keyboardState: keyboardState),
        GazeKey(content: 'y', keyboardState: keyboardState),
        GazeKey(content: 'x', keyboardState: keyboardState),
        GazeKey(content: 'c', keyboardState: keyboardState),
        GazeKey(content: 'v', keyboardState: keyboardState),
        GazeKey(content: 'b', keyboardState: keyboardState),
        GazeKey(content: 'n', keyboardState: keyboardState),
        GazeKey(content: 'm', keyboardState: keyboardState),
        GazeKey(content: const [';', ','], keyboardState: keyboardState),
        GazeKey(content: const [':', '.'], keyboardState: keyboardState),
        GazeKey(content: const ['_', '-'], keyboardState: keyboardState),
        // GazeKey(content: 'shift', widthRatio: 1.5, shift: shift, type: GazeKeyType.shift),
      ],
      [
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: keyboardState),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: keyboardState),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: keyboardState),
        GazeKey(content: ' ', widthRatio: 11.7, keyboardState: keyboardState),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt gr', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: keyboardState),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: keyboardState),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: keyboardState),
      ]
    ];
  }

  static List<List<Widget>> _english(GazeKeyboardState keyboardState) {
    return [
      [
        GazeKey(content: const ['~', '`'], keyboardState: keyboardState),
        GazeKey(content: const ['!', '1'], keyboardState: keyboardState),
        GazeKey(content: const ['@', '2'], keyboardState: keyboardState),
        GazeKey(content: const ['#', '3'], keyboardState: keyboardState),
        GazeKey(content: const [r'$', '4'], keyboardState: keyboardState),
        GazeKey(content: const ['%', '5'], keyboardState: keyboardState),
        GazeKey(content: const ['^', '6'], keyboardState: keyboardState),
        GazeKey(content: const ['&', '7'], keyboardState: keyboardState),
        GazeKey(content: const ['*', '8'], keyboardState: keyboardState),
        GazeKey(content: const ['(', '9'], keyboardState: keyboardState),
        GazeKey(content: const [')', '0'], keyboardState: keyboardState),
        GazeKey(content: const ['_', '-'], keyboardState: keyboardState),
        GazeKey(content: const ['+', '='], keyboardState: keyboardState),
        // GazeKey(content: Icons.keyboard_backspace_rounded, widthRatio: 2.2, type: GazeKeyType.del),
      ],
      [
        // GazeKey(content: Icons.keyboard_tab_rounded, type: GazeKeyType.tab), // widthRatio: 1.7
        GazeKey(content: 'q', keyboardState: keyboardState),
        GazeKey(content: 'w', keyboardState: keyboardState),
        GazeKey(content: 'e', keyboardState: keyboardState),
        GazeKey(content: 'r', keyboardState: keyboardState),
        GazeKey(content: 't', keyboardState: keyboardState),
        GazeKey(content: 'y', keyboardState: keyboardState),
        GazeKey(content: 'u', keyboardState: keyboardState),
        GazeKey(content: 'i', keyboardState: keyboardState),
        GazeKey(content: 'o', keyboardState: keyboardState),
        GazeKey(content: 'p', keyboardState: keyboardState),
        GazeKey(content: const ['{', '['], keyboardState: keyboardState),
        GazeKey(content: const ['}', ']'], keyboardState: keyboardState),
        GazeKey(content: const ['|', r'\'], keyboardState: keyboardState),
        // GazeKey(content: 'Enter', widthRatio: 1.5, type: GazeKeyType.enter),
      ],
      [
        // GazeKey(content: Icons.keyboard_capslock_rounded, shift: capsLock, type: GazeKeyType.caps), // widthRatio: 2
        GazeKey(content: 'a', keyboardState: keyboardState),
        GazeKey(content: 's', keyboardState: keyboardState),
        GazeKey(content: 'd', keyboardState: keyboardState),
        GazeKey(content: 'f', keyboardState: keyboardState),
        GazeKey(content: 'g', keyboardState: keyboardState),
        GazeKey(content: 'h', keyboardState: keyboardState),
        GazeKey(content: 'j', keyboardState: keyboardState),
        GazeKey(content: 'k', keyboardState: keyboardState),
        GazeKey(content: 'l', keyboardState: keyboardState),
        GazeKey(content: const [':', ';'], keyboardState: keyboardState),
        GazeKey(content: const ['"', "'"], keyboardState: keyboardState),
        // GazeKey(content: 'Enter', widthRatio: 1.2, type: GazeKeyType.enter),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, type: GazeKeyType.shift, keyboardState: keyboardState), // widthRatio: 1.5
        GazeKey(content: 'z', keyboardState: keyboardState),
        GazeKey(content: 'x', keyboardState: keyboardState),
        GazeKey(content: 'c', keyboardState: keyboardState),
        GazeKey(content: 'v', keyboardState: keyboardState),
        GazeKey(content: 'b', keyboardState: keyboardState),
        GazeKey(content: 'n', keyboardState: keyboardState),
        GazeKey(content: 'm', keyboardState: keyboardState),
        GazeKey(content: const ['<', ','], keyboardState: keyboardState),
        GazeKey(content: const ['>', '.'], keyboardState: keyboardState),
        GazeKey(content: const ['?', '/'], keyboardState: keyboardState),
        // GazeKey(content: 'shift', widthRatio: 1.5, shift: shift, type: GazeKeyType.shift),
      ],
      [
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: keyboardState),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: keyboardState),
        GazeKey(content: 'alt', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: keyboardState),
        GazeKey(content: ' ', widthRatio: 11.7, keyboardState: keyboardState),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt gr', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: keyboardState),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: keyboardState),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: keyboardState),
      ]
    ];
  }

  static List<List<Widget>> _speak(GazeKeyboardState keyboardState) {
    return [
      [
        const Spacer(),
        GazeKey(content: 'q', keyboardState: keyboardState),
        GazeKey(content: 'w', keyboardState: keyboardState),
        GazeKey(content: 'e', keyboardState: keyboardState),
        GazeKey(content: 'r', keyboardState: keyboardState),
        GazeKey(content: 't', keyboardState: keyboardState),
        GazeKey(content: 'z', keyboardState: keyboardState),
        GazeKey(content: 'u', keyboardState: keyboardState),
        GazeKey(content: 'i', keyboardState: keyboardState),
        GazeKey(content: 'o', keyboardState: keyboardState),
        GazeKey(content: 'p', keyboardState: keyboardState),
        GazeKey(content: 'ü', keyboardState: keyboardState),
      ],
      [
        GazeKey(content: Icons.keyboard_capslock_rounded, type: GazeKeyType.caps, keyboardState: keyboardState),
        GazeKey(content: 'a', keyboardState: keyboardState),
        GazeKey(content: 's', keyboardState: keyboardState),
        GazeKey(content: 'd', keyboardState: keyboardState),
        GazeKey(content: 'f', keyboardState: keyboardState),
        GazeKey(content: 'g', keyboardState: keyboardState),
        GazeKey(content: 'h', keyboardState: keyboardState),
        GazeKey(content: 'j', keyboardState: keyboardState),
        GazeKey(content: 'k', keyboardState: keyboardState),
        GazeKey(content: 'l', keyboardState: keyboardState),
        GazeKey(content: 'ö', keyboardState: keyboardState),
        GazeKey(content: 'ä', keyboardState: keyboardState),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, type: GazeKeyType.shift, keyboardState: keyboardState), // , widthRatio: 1.5
        GazeKey(content: 'y', keyboardState: keyboardState),
        GazeKey(content: 'x', keyboardState: keyboardState),
        GazeKey(content: 'c', keyboardState: keyboardState),
        GazeKey(content: 'v', keyboardState: keyboardState),
        GazeKey(content: ' ', widthRatio: 2, keyboardState: keyboardState),
        GazeKey(content: 'b', keyboardState: keyboardState),
        GazeKey(content: 'n', keyboardState: keyboardState),
        GazeKey(content: 'm', keyboardState: keyboardState),
        GazeKey(content: const ['.', ','], keyboardState: keyboardState),
        GazeKey(content: const ['?', '!'], keyboardState: keyboardState),
      ],
    ];
  }
}
