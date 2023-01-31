//  Gaze Keyboard Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';

import 'keyboard_key.dart';

enum Language {
  german,
  english,
  speak,
}

class Keyboards {
  static List<List<Widget>> get(Language lang, String route,
      {required bool shift, required bool capsLock, required void Function(String?, GazeKeyType) action}) {
    final shiftState = shift ^ capsLock;
    switch (lang) {
      case Language.german:
        return _german(shiftState, route, shift, capsLock, action);
      case Language.english:
        return _english(shiftState, route, shift, capsLock, action);
      case Language.speak:
        return _speak(shiftState, route, shift, capsLock, action);
    }
  }

  static List<List<Widget>> _german(bool _shift, String route, bool shift, bool capsLock, void Function(String?, GazeKeyType) action) {
    return [
      [
        GazeKey(content: const ['°', '^'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['!', '1'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['"', '2'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['§', '3'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const [r'$', '4'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['%', '5'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['&', '6'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['/', '7'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['(', '8'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const [')', '9'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['=', '0'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['?', 'ß'], route: route, shift: _shift, onTap: action),
        // GazeKey(content: const ['`', '´'], route: route, shift: _shift, onTap: action),
        // GazeKey(content: Icons.keyboard_backspace_rounded, route: route, widthRatio: 2.2, type: GazeKeyType.del, onTap: action),
      ],
      [
        // GazeKey(content: Icons.keyboard_tab_rounded, route: route, type: GazeKeyType.tab, onTap: action), // widthRatio: 1.7
        GazeKey(content: 'q', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'w', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'e', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'r', route: route, shift: _shift, onTap: action),
        GazeKey(content: 't', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'z', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'u', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'i', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'o', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'p', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'ü', route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['*', '+'], route: route, shift: _shift, onTap: action),
        // GazeKey(content: 'Enter', route: route, widthRatio: 1.5, type: GazeKeyType.enter, onTap: action),
      ],
      [
        // GazeKey(content: Icons.keyboard_capslock_rounded, route: route, shift: capsLock, type: GazeKeyType.caps, onTap: action), // widthRatio: 2
        GazeKey(content: 'a', route: route, shift: _shift, onTap: action),
        GazeKey(content: 's', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'd', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'f', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'g', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'h', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'j', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'k', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'l', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'ö', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'ä', route: route, shift: _shift, onTap: action),
        GazeKey(content: const ["'", '#'], route: route, shift: _shift, onTap: action),
        // GazeKey(content: 'Enter', route: route, widthRatio: 1.2, type: GazeKeyType.enter, onTap: action),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, route: route, shift: shift, type: GazeKeyType.shift, onTap: action), // , widthRatio: 1.5
        GazeKey(content: const ['>', '<'], route: route, shift: _shift, onTap: action),
        GazeKey(content: 'y', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'x', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'c', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'v', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'b', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'n', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'm', route: route, shift: _shift, onTap: action),
        GazeKey(content: const [';', ','], route: route, shift: _shift, onTap: action),
        GazeKey(content: const [':', '.'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['_', '-'], route: route, shift: _shift, onTap: action),
        // GazeKey(content: 'shift', route: route, widthRatio: 1.5, shift: shift, type: GazeKeyType.shift, onTap: action),
      ],
      [
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', route: route, widthRatio: 1.5, type: GazeKeyType.ctrl, onTap: action),
        if (Platform.isWindows) GazeKey(content: 'win', route: route, widthRatio: 1.2, type: GazeKeyType.win, onTap: action),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt', route: route, widthRatio: 1.5, type: GazeKeyType.alt, onTap: action),
        GazeKey(content: ' ', route: route, widthRatio: 11.7, onTap: action),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt gr', route: route, widthRatio: 1.5, type: GazeKeyType.alt, onTap: action),
        if (Platform.isWindows) GazeKey(content: 'win', route: route, widthRatio: 1.2, type: GazeKeyType.win, onTap: action),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', route: route, widthRatio: 1.5, type: GazeKeyType.ctrl, onTap: action),
      ]
    ];
  }

  static List<List<Widget>> _english(bool _shift, String route, bool shift, bool capsLock, void Function(String?, GazeKeyType) action) {
    return [
      [
        GazeKey(content: const ['~', '`'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['!', '1'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['@', '2'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['#', '3'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const [r'$', '4'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['%', '5'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['^', '6'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['&', '7'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['*', '8'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['(', '9'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const [')', '0'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['_', '-'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['+', '='], route: route, shift: _shift, onTap: action),
        // GazeKey(content: Icons.keyboard_backspace_rounded, route: route, widthRatio: 2.2, type: GazeKeyType.del, onTap: action),
      ],
      [
        // GazeKey(content: Icons.keyboard_tab_rounded, route: route, type: GazeKeyType.tab, onTap: action), // widthRatio: 1.7
        GazeKey(content: 'q', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'w', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'e', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'r', route: route, shift: _shift, onTap: action),
        GazeKey(content: 't', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'y', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'u', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'i', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'o', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'p', route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['{', '['], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['}', ']'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['|', r'\'], route: route, shift: _shift, onTap: action),
        // GazeKey(content: 'Enter', route: route, widthRatio: 1.5, type: GazeKeyType.enter, onTap: action),
      ],
      [
        // GazeKey(content: Icons.keyboard_capslock_rounded, route: route, shift: capsLock, type: GazeKeyType.caps, onTap: action), // widthRatio: 2
        GazeKey(content: 'a', route: route, shift: _shift, onTap: action),
        GazeKey(content: 's', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'd', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'f', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'g', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'h', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'j', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'k', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'l', route: route, shift: _shift, onTap: action),
        GazeKey(content: const [':', ';'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['"', "'"], route: route, shift: _shift, onTap: action),
        // GazeKey(content: 'Enter', route: route, widthRatio: 1.2, type: GazeKeyType.enter, onTap: action),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, route: route, shift: shift, type: GazeKeyType.shift, onTap: action), // widthRatio: 1.5
        GazeKey(content: 'z', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'x', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'c', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'v', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'b', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'n', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'm', route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['<', ','], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['>', '.'], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['?', '/'], route: route, shift: _shift, onTap: action),
        // GazeKey(content: 'shift', route: route, widthRatio: 1.5, shift: shift, type: GazeKeyType.shift, onTap: action),
      ],
      [
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', route: route, widthRatio: 1.5, type: GazeKeyType.ctrl, onTap: action),
        if (Platform.isWindows) GazeKey(content: 'win', route: route, widthRatio: 1.2, type: GazeKeyType.win, onTap: action),
        GazeKey(content: 'alt', route: route, widthRatio: 1.5, type: GazeKeyType.alt, onTap: action),
        GazeKey(content: ' ', route: route, widthRatio: 11.7, onTap: action),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt gr', route: route, widthRatio: 1.5, type: GazeKeyType.alt, onTap: action),
        if (Platform.isWindows) GazeKey(content: 'win', route: route, widthRatio: 1.2, type: GazeKeyType.win, onTap: action),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', route: route, widthRatio: 1.5, type: GazeKeyType.ctrl, onTap: action),
      ]
    ];
  }

  static List<List<Widget>> _speak(bool _shift, String route, bool shift, bool capsLock, void Function(String?, GazeKeyType) action) {
    return [
      [
        const Spacer(),
        GazeKey(content: 'q', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'w', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'e', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'r', route: route, shift: _shift, onTap: action),
        GazeKey(content: 't', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'z', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'u', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'i', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'o', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'p', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'ü', route: route, shift: _shift, onTap: action),
      ],
      [
        GazeKey(content: Icons.keyboard_capslock_rounded, route: route, shift: capsLock, type: GazeKeyType.caps, onTap: action),
        GazeKey(content: 'a', route: route, shift: _shift, onTap: action),
        GazeKey(content: 's', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'd', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'f', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'g', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'h', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'j', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'k', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'l', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'ö', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'ä', route: route, shift: _shift, onTap: action),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, route: route, shift: shift, type: GazeKeyType.shift, onTap: action), // , widthRatio: 1.5
        GazeKey(content: 'y', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'x', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'c', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'v', route: route, shift: _shift, onTap: action),
        GazeKey(content: ' ', route: route, widthRatio: 2, onTap: action),
        GazeKey(content: 'b', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'n', route: route, shift: _shift, onTap: action),
        GazeKey(content: 'm', route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['.', ','], route: route, shift: _shift, onTap: action),
        GazeKey(content: const ['?', '!'], route: route, shift: _shift, onTap: action),
      ],
    ];
  }
}
