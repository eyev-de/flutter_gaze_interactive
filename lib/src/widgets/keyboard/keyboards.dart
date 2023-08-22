//  Gaze Keyboard Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'keyboard_key.dart';
import 'keyboard_state.dart';

enum Language { german, english }

enum KeyboardPlatformType { iOS, desktop }

enum KeyboardType { extended, speak, editor }

class Keyboards {
  static List<List<Widget>> get(Language lang, GazeKeyboardState keyboardState) {
    switch (keyboardState.type) {
      case KeyboardType.extended:
      case KeyboardType.editor:
        switch (lang) {
          case Language.german:
            return keyboardState.keyboardPlatformType == KeyboardPlatformType.iOS ? germanIOS(keyboardState) : germanDesktop(keyboardState);
          case Language.english:
            return keyboardState.keyboardPlatformType == KeyboardPlatformType.iOS ? englishIOS(keyboardState) : englishDesktop(keyboardState);
        }
      case KeyboardType.speak:
        switch (lang) {
          case Language.german:
            return germanSpeak(keyboardState);
          case Language.english:
            return englishSpeak(keyboardState);
        }
    }
  }

  @visibleForTesting
  static List<List<Widget>> germanDesktop(GazeKeyboardState keyboardState) {
    return [
      [
        GazeKey(content: const ['°', '^'], keyboardState: keyboardState),
        GazeKey(content: const ['!', '1'], keyboardState: keyboardState),
        GazeKey(content: const ['"', '2'], keyboardState: keyboardState),
        GazeKey(content: const ['@', '3'], keyboardState: keyboardState),
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
        GazeKey(content: Icons.keyboard_tab_rounded, type: GazeKeyType.tab, keyboardState: keyboardState), // widthRatio: 1.7
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
        GazeKey(content: 'Enter', widthRatio: 1.5, type: GazeKeyType.enter, keyboardState: keyboardState),
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
        if (keyboardState.type == KeyboardType.extended)
          GazeKey(content: Icons.keyboard_hide, widthRatio: 2, type: GazeKeyType.close, keyboardState: keyboardState),
      ]
    ];
  }

  @visibleForTesting
  static List<List<Widget>> germanIOS(GazeKeyboardState keyboardState) {
    return [
      [
        if (keyboardState.type == KeyboardType.editor) GazeKey(content: Icons.keyboard_tab_rounded, type: GazeKeyType.tab, keyboardState: keyboardState),
        GazeKey(content: const ['q', 'Q', '1', '['], keyboardState: keyboardState),
        GazeKey(content: const ['w', 'W', '2', ']'], keyboardState: keyboardState),
        GazeKey(content: const ['e', 'E', '3', '{'], keyboardState: keyboardState),
        GazeKey(content: const ['r', 'R', '4', '}'], keyboardState: keyboardState),
        GazeKey(content: const ['t', 'T', '5', '#'], keyboardState: keyboardState),
        GazeKey(content: const ['z', 'Z', '6', '%'], keyboardState: keyboardState),
        GazeKey(content: const ['u', 'U', '7', '^'], keyboardState: keyboardState),
        GazeKey(content: const ['i', 'I', '8', '*'], keyboardState: keyboardState),
        GazeKey(content: const ['o', 'O', '9', '+'], keyboardState: keyboardState),
        GazeKey(content: const ['p', 'P', '0', '='], keyboardState: keyboardState),
        GazeKey(content: const ['ü', 'Ü', '', ''], keyboardState: keyboardState),
      ],
      [
        GazeKey(
          content: const [CupertinoIcons.shift, CupertinoIcons.shift_fill, CupertinoIcons.plus, CupertinoIcons.textformat_123],
          type: GazeKeyType.shift,
          keyboardState: keyboardState,
        ),
        GazeKey(content: const ['a', 'A', '-', '_'], keyboardState: keyboardState),
        GazeKey(content: const ['s', 'S', '/', r'\'], keyboardState: keyboardState),
        GazeKey(content: const ['d', 'D', ':', '|'], keyboardState: keyboardState),
        GazeKey(content: const ['f', 'F', ';', '~'], keyboardState: keyboardState),
        GazeKey(content: const ['g', 'G', '(', '<'], keyboardState: keyboardState),
        GazeKey(content: const ['h', 'H', ')', '>'], keyboardState: keyboardState),
        GazeKey(content: const ['j', 'J', '€', r'$'], keyboardState: keyboardState),
        GazeKey(content: const ['k', 'K', '&', '£'], keyboardState: keyboardState),
        GazeKey(content: const ['l', 'L', '@', '¥'], keyboardState: keyboardState),
        GazeKey(content: const ['ö', 'Ö', '"', '•'], keyboardState: keyboardState),
        GazeKey(content: const ['ä', 'Ä', '', ''], keyboardState: keyboardState),
        if (keyboardState.type == KeyboardType.editor) GazeKey(content: 'Enter', widthRatio: 1.5, type: GazeKeyType.enter, keyboardState: keyboardState),
      ],
      [
        GazeKey(
          content: const [CupertinoIcons.textformat_123, CupertinoIcons.textformat_123, CupertinoIcons.textformat_abc, CupertinoIcons.textformat_abc],
          type: GazeKeyType.signs,
          keyboardState: keyboardState,
        ),
        GazeKey(content: const ['y', 'Y', '', ''], keyboardState: keyboardState),
        GazeKey(content: const ['x', 'X', '.', '.'], keyboardState: keyboardState),
        GazeKey(content: const ['c', 'C', ',', ','], keyboardState: keyboardState),
        GazeKey(content: ' ', widthRatio: 2, keyboardState: keyboardState),
        GazeKey(content: const ['v', 'V', '?', '?'], keyboardState: keyboardState),
        GazeKey(content: const ['b', 'B', '!', '!'], keyboardState: keyboardState),
        GazeKey(content: const ['n', 'N', '´', '`'], keyboardState: keyboardState),
        GazeKey(content: const ['m', 'M', '', ''], keyboardState: keyboardState),
        if (keyboardState.type == KeyboardType.extended) GazeKey(content: Icons.keyboard_hide, type: GazeKeyType.close, keyboardState: keyboardState),
      ],
    ];
  }

  @visibleForTesting
  static List<List<Widget>> englishDesktop(GazeKeyboardState keyboardState) {
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
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: keyboardState),
        GazeKey(content: ' ', widthRatio: 11.7, keyboardState: keyboardState),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt gr', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: keyboardState),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: keyboardState),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: keyboardState),
        if (keyboardState.type == KeyboardType.extended)
          GazeKey(content: Icons.keyboard_hide, widthRatio: 2, type: GazeKeyType.close, keyboardState: keyboardState),
      ]
    ];
  }

  @visibleForTesting
  static List<List<Widget>> englishIOS(GazeKeyboardState keyboardState) {
    return [
      [
        GazeKey(content: Icons.keyboard_tab_rounded, type: GazeKeyType.tab, keyboardState: keyboardState), // widthRatio: 1.7
        GazeKey(content: const ['q', 'Q', '1', '['], keyboardState: keyboardState),
        GazeKey(content: const ['w', 'W', '2', ']'], keyboardState: keyboardState),
        GazeKey(content: const ['e', 'E', '3', '{'], keyboardState: keyboardState),
        GazeKey(content: const ['r', 'R', '4', '}'], keyboardState: keyboardState),
        GazeKey(content: const ['t', 'T', '5', '#'], keyboardState: keyboardState),
        GazeKey(content: const ['y', 'Y', '6', '%'], keyboardState: keyboardState),
        GazeKey(content: const ['u', 'U', '7', '^'], keyboardState: keyboardState),
        GazeKey(content: const ['i', 'I', '8', '*'], keyboardState: keyboardState),
        GazeKey(content: const ['o', 'O', '9', '+'], keyboardState: keyboardState),
        GazeKey(content: const ['p', 'P', '0', '='], keyboardState: keyboardState),
      ],
      [
        GazeKey(content: const [
          CupertinoIcons.shift,
          CupertinoIcons.shift_fill,
          CupertinoIcons.plus,
          CupertinoIcons.textformat_123,
        ], type: GazeKeyType.shift, keyboardState: keyboardState), // , widthRatio: 1.5
        GazeKey(content: const ['a', 'A', '-', '_'], keyboardState: keyboardState),
        GazeKey(content: const ['s', 'S', '/', r'\'], keyboardState: keyboardState),
        GazeKey(content: const ['d', 'D', ':', '|'], keyboardState: keyboardState),
        GazeKey(content: const ['f', 'F', ';', '~'], keyboardState: keyboardState),
        GazeKey(content: const ['g', 'G', '(', '<'], keyboardState: keyboardState),
        GazeKey(content: const ['h', 'H', ')', '>'], keyboardState: keyboardState),
        GazeKey(content: const ['j', 'J', '€', r'$'], keyboardState: keyboardState),
        GazeKey(content: const ['k', 'K', '&', '£'], keyboardState: keyboardState),
        GazeKey(content: const ['l', 'L', '@', '¥'], keyboardState: keyboardState),
        GazeKey(content: const ['', '', '"', '•'], keyboardState: keyboardState),
        GazeKey(content: 'Enter', widthRatio: 1.5, type: GazeKeyType.enter, keyboardState: keyboardState),
      ],
      [
        GazeKey(content: const [
          CupertinoIcons.textformat_123,
          CupertinoIcons.textformat_123,
          CupertinoIcons.textformat_abc,
          CupertinoIcons.textformat_abc,
        ], type: GazeKeyType.signs, keyboardState: keyboardState), // , widthRatio: 1.5
        GazeKey(content: const ['z', 'Z', '', ''], keyboardState: keyboardState),
        GazeKey(content: const ['x', 'X', '.', '.'], keyboardState: keyboardState),
        GazeKey(content: const ['c', 'C', ',', ','], keyboardState: keyboardState),
        GazeKey(content: ' ', widthRatio: 2, keyboardState: keyboardState),
        GazeKey(content: const ['v', 'V', '?', '?'], keyboardState: keyboardState),
        GazeKey(content: const ['b', 'B', '!', '!'], keyboardState: keyboardState),
        GazeKey(content: const ['n', 'N', '´', '`'], keyboardState: keyboardState),
        GazeKey(content: const ['m', 'M', '', ''], keyboardState: keyboardState),
        if (keyboardState.type == KeyboardType.extended)
          GazeKey(
            content: Icons.keyboard_hide,
            type: GazeKeyType.close,
            keyboardState: keyboardState,
          ),
      ],
    ];
  }

  @visibleForTesting
  static List<List<Widget>> germanSpeak(GazeKeyboardState keyboardState) {
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
        GazeKey(content: Icons.keyboard_arrow_up_rounded, type: GazeKeyType.shift, keyboardState: keyboardState),
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

  @visibleForTesting
  static List<List<Widget>> englishSpeak(GazeKeyboardState keyboardState) {
    return [
      [
        const Spacer(),
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
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, type: GazeKeyType.shift, keyboardState: keyboardState),
        GazeKey(content: 'z', keyboardState: keyboardState),
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
