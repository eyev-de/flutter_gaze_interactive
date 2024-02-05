//  Gaze Keyboard Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'keyboard_key.dart';
import 'keyboard_key_type.enum.dart';
import 'keyboard_state.dart';

enum Language { german, english }

enum KeyboardPlatformType { mobile, desktop }

enum KeyboardType { extended, editor, speak, email }

class Keyboards {
  static List<List<Widget>> get(Language lang, GazeKeyboardState keyboardState) {
    switch (keyboardState.type) {
      case KeyboardType.extended:
      case KeyboardType.editor:
      case KeyboardType.email:
        return switch (lang) {
          Language.german => keyboardState.keyboardPlatformType == KeyboardPlatformType.mobile ? germanMobile(keyboardState) : germanDesktop(keyboardState),
          Language.english => keyboardState.keyboardPlatformType == KeyboardPlatformType.mobile ? englishMobile(keyboardState) : englishDesktop(keyboardState),
        };
      case KeyboardType.speak:
        return switch (lang) {
          Language.german => germanSpeak(keyboardState),
          Language.english => englishSpeak(keyboardState),
        };
    }
  }

  @visibleForTesting
  static List<List<Widget>> germanDesktop(GazeKeyboardState state) {
    return [
      [
        GazeKey(content: const ['^', '°'], keyboardState: state),
        GazeKey(content: const ['1', '!'], keyboardState: state),
        GazeKey(content: const ['2', '"'], keyboardState: state),
        GazeKey(content: const ['3', '@'], keyboardState: state),
        GazeKey(content: const ['4', r'$'], keyboardState: state),
        GazeKey(content: const ['5', '%'], keyboardState: state),
        GazeKey(content: const ['6', '&'], keyboardState: state),
        GazeKey(content: const ['7', '/'], keyboardState: state),
        GazeKey(content: const ['8', '('], keyboardState: state),
        GazeKey(content: const ['9', ')'], keyboardState: state),
        GazeKey(content: const ['0', '='], keyboardState: state),
        GazeKey(content: const ['ß', '?'], keyboardState: state),
      ],
      [
        GazeKey(content: Icons.keyboard_tab_rounded, type: GazeKeyType.tab, keyboardState: state),
        GazeKey(content: 'q', keyboardState: state),
        GazeKey(content: 'w', keyboardState: state),
        GazeKey(content: 'e', keyboardState: state),
        GazeKey(content: 'r', keyboardState: state),
        GazeKey(content: 't', keyboardState: state),
        GazeKey(content: 'z', keyboardState: state),
        GazeKey(content: 'u', keyboardState: state),
        GazeKey(content: 'i', keyboardState: state),
        GazeKey(content: 'o', keyboardState: state),
        GazeKey(content: 'p', keyboardState: state),
        GazeKey(content: 'ü', keyboardState: state),
        GazeKey(content: const ['+', '*'], keyboardState: state),
        GazeKey(content: 'Enter', widthRatio: 1.5, type: GazeKeyType.enter, keyboardState: state),
      ],
      [
        GazeKey(content: 'a', keyboardState: state),
        GazeKey(content: 's', keyboardState: state),
        GazeKey(content: 'd', keyboardState: state),
        GazeKey(content: 'f', keyboardState: state),
        GazeKey(content: 'g', keyboardState: state),
        GazeKey(content: 'h', keyboardState: state),
        GazeKey(content: 'j', keyboardState: state),
        GazeKey(content: 'k', keyboardState: state),
        GazeKey(content: 'l', keyboardState: state),
        GazeKey(content: 'ö', keyboardState: state),
        GazeKey(content: 'ä', keyboardState: state),
        GazeKey(content: const ['#', "'"], keyboardState: state),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, type: GazeKeyType.shift, keyboardState: state),
        GazeKey(content: const ['>', '<'], keyboardState: state),
        GazeKey(content: 'y', keyboardState: state),
        GazeKey(content: 'x', keyboardState: state),
        GazeKey(content: 'c', keyboardState: state),
        GazeKey(content: 'v', keyboardState: state),
        GazeKey(content: 'b', keyboardState: state),
        GazeKey(content: 'n', keyboardState: state),
        GazeKey(content: 'm', keyboardState: state),
        GazeKey(content: const [',', ';'], keyboardState: state),
        GazeKey(content: const ['.', ':'], keyboardState: state),
        GazeKey(content: const ['-', '_'], keyboardState: state),
      ],
      [
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: state),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: state),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: state),
        GazeKey(content: ' ', widthRatio: 11.7, keyboardState: state),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt gr', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: state),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: state),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: state),
        if (state.type == KeyboardType.extended) GazeKey(content: Icons.keyboard_hide, widthRatio: 2, type: GazeKeyType.close, keyboardState: state),
      ]
    ];
  }

  @visibleForTesting
  static List<List<Widget>> germanMobile(GazeKeyboardState state) {
    return [
      [
        if ([KeyboardType.extended, KeyboardType.email].contains(state.type)) const Spacer(),
        if (state.type == KeyboardType.editor) GazeKey(content: Icons.keyboard_tab_rounded, widthRatio: 2, type: GazeKeyType.tab, keyboardState: state),
        GazeKey(content: const ['q', 'Q', '1', '['], keyboardState: state),
        GazeKey(content: const ['w', 'W', '2', ']'], keyboardState: state),
        GazeKey(content: const ['e', 'E', '3', '{'], keyboardState: state),
        GazeKey(content: const ['r', 'R', '4', '}'], keyboardState: state),
        GazeKey(content: const ['t', 'T', '5', '#'], keyboardState: state),
        GazeKey(content: const ['z', 'Z', '6', '%'], keyboardState: state),
        GazeKey(content: const ['u', 'U', '7', '^'], keyboardState: state),
        GazeKey(content: const ['i', 'I', '8', '*'], keyboardState: state),
        GazeKey(content: const ['o', 'O', '9', '+'], keyboardState: state),
        GazeKey(content: const ['p', 'P', '0', '='], keyboardState: state),
        GazeKey(content: const ['ü', 'Ü', '', ''], keyboardState: state),
      ],
      [
        GazeKey(
          content: const [CupertinoIcons.shift, CupertinoIcons.shift_fill, '#+=', CupertinoIcons.textformat_123],
          widthRatio: [KeyboardType.extended, KeyboardType.email].contains(state.type) ? 1 : 2,
          type: GazeKeyType.shift,
          keyboardState: state,
        ),
        GazeKey(content: const ['a', 'A', '-', '_'], keyboardState: state),
        GazeKey(content: const ['s', 'S', '/', r'\'], keyboardState: state),
        GazeKey(content: const ['d', 'D', ':', '|'], keyboardState: state),
        GazeKey(content: const ['f', 'F', ';', '~'], keyboardState: state),
        GazeKey(content: const ['g', 'G', '(', '<'], keyboardState: state),
        GazeKey(content: const ['h', 'H', ')', '>'], keyboardState: state),
        GazeKey(content: const ['j', 'J', '€', r'$'], keyboardState: state),
        GazeKey(content: const ['k', 'K', '&', '£'], keyboardState: state),
        GazeKey(content: const ['l', 'L', '@', '¥'], keyboardState: state),
        GazeKey(content: const ['ö', 'Ö', '"', '•'], keyboardState: state),
        GazeKey(content: const ['ä', 'Ä', '', ''], keyboardState: state),
      ],
      [
        GazeKey(
          content: const [CupertinoIcons.textformat_123, CupertinoIcons.textformat_123, CupertinoIcons.textformat_abc, CupertinoIcons.textformat_abc],
          widthRatio: [KeyboardType.extended, KeyboardType.email].contains(state.type) ? 1 : 2,
          type: GazeKeyType.signs,
          keyboardState: state,
        ),
        if (state.type == KeyboardType.extended) const Spacer(),
        GazeKey(content: const ['y', 'Y', '', ''], keyboardState: state),
        GazeKey(content: const ['x', 'X', '.', '.'], keyboardState: state),
        GazeKey(content: const ['c', 'C', ',', ','], keyboardState: state),
        if (state.type == KeyboardType.email) ...[
          GazeKey(content: const ['v', 'V', '?', '?'], keyboardState: state),
          GazeKey(content: ' ', widthRatio: 2, keyboardState: state),
        ] else ...[
          GazeKey(content: ' ', widthRatio: 2, keyboardState: state),
          GazeKey(content: const ['v', 'V', '?', '?'], keyboardState: state),
        ],
        GazeKey(content: const ['b', 'B', '!', '!'], keyboardState: state),
        GazeKey(content: const ['n', 'N', '´', '`'], keyboardState: state),
        GazeKey(content: const ['m', 'M', '', ''], keyboardState: state),
        if (state.type == KeyboardType.email) GazeKey(content: const ['@', '.', '', ''], color: Colors.grey.shade800, keyboardState: state, stacked: true),
        if ([KeyboardType.extended, KeyboardType.email].contains(state.type))
          GazeKey(content: Icons.keyboard_hide, type: GazeKeyType.close, keyboardState: state),
        if (state.type == KeyboardType.editor) GazeKey(content: 'Enter', widthRatio: 2, type: GazeKeyType.enter, keyboardState: state),
      ],
    ];
  }

  @visibleForTesting
  static List<List<Widget>> englishDesktop(GazeKeyboardState state) {
    return [
      [
        GazeKey(content: const ['`', '~'], keyboardState: state),
        GazeKey(content: const ['1', '!'], keyboardState: state),
        GazeKey(content: const ['2', '@'], keyboardState: state),
        GazeKey(content: const ['3', '#'], keyboardState: state),
        GazeKey(content: const ['4', r'$'], keyboardState: state),
        GazeKey(content: const ['5', '%'], keyboardState: state),
        GazeKey(content: const ['6', '^'], keyboardState: state),
        GazeKey(content: const ['7', '&'], keyboardState: state),
        GazeKey(content: const ['8', '*'], keyboardState: state),
        GazeKey(content: const ['9', '('], keyboardState: state),
        GazeKey(content: const ['0', ')'], keyboardState: state),
        GazeKey(content: const ['-', '_'], keyboardState: state),
        GazeKey(content: const ['=', '+'], keyboardState: state),
      ],
      [
        GazeKey(content: 'q', keyboardState: state),
        GazeKey(content: 'w', keyboardState: state),
        GazeKey(content: 'e', keyboardState: state),
        GazeKey(content: 'r', keyboardState: state),
        GazeKey(content: 't', keyboardState: state),
        GazeKey(content: 'y', keyboardState: state),
        GazeKey(content: 'u', keyboardState: state),
        GazeKey(content: 'i', keyboardState: state),
        GazeKey(content: 'o', keyboardState: state),
        GazeKey(content: 'p', keyboardState: state),
        GazeKey(content: const ['[', '{'], keyboardState: state),
        GazeKey(content: const [']', '}'], keyboardState: state),
        GazeKey(content: const [r'\', '|'], keyboardState: state),
      ],
      [
        GazeKey(content: 'a', keyboardState: state),
        GazeKey(content: 's', keyboardState: state),
        GazeKey(content: 'd', keyboardState: state),
        GazeKey(content: 'f', keyboardState: state),
        GazeKey(content: 'g', keyboardState: state),
        GazeKey(content: 'h', keyboardState: state),
        GazeKey(content: 'j', keyboardState: state),
        GazeKey(content: 'k', keyboardState: state),
        GazeKey(content: 'l', keyboardState: state),
        GazeKey(content: const [';', ':'], keyboardState: state),
        GazeKey(content: const ["'", '"'], keyboardState: state),
      ],
      [
        GazeKey(content: Icons.keyboard_arrow_up_rounded, type: GazeKeyType.shift, keyboardState: state),
        GazeKey(content: 'z', keyboardState: state),
        GazeKey(content: 'x', keyboardState: state),
        GazeKey(content: 'c', keyboardState: state),
        GazeKey(content: 'v', keyboardState: state),
        GazeKey(content: 'b', keyboardState: state),
        GazeKey(content: 'n', keyboardState: state),
        GazeKey(content: 'm', keyboardState: state),
        GazeKey(content: const [',', '<'], keyboardState: state),
        GazeKey(content: const ['.', '>'], keyboardState: state),
        GazeKey(content: const ['/', '?'], keyboardState: state),
      ],
      [
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: state),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: state),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: state),
        GazeKey(content: ' ', widthRatio: 11.7, keyboardState: state),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'alt gr', widthRatio: 1.5, type: GazeKeyType.alt, keyboardState: state),
        if (Platform.isWindows) GazeKey(content: 'win', widthRatio: 1.2, type: GazeKeyType.win, keyboardState: state),
        if (!Platform.isIOS && !Platform.isAndroid) GazeKey(content: 'ctrl', widthRatio: 1.5, type: GazeKeyType.ctrl, keyboardState: state),
        if (state.type == KeyboardType.extended) GazeKey(content: Icons.keyboard_hide, widthRatio: 2, type: GazeKeyType.close, keyboardState: state),
      ]
    ];
  }

  @visibleForTesting
  static List<List<Widget>> englishMobile(GazeKeyboardState state) {
    return [
      [
        if ([KeyboardType.extended, KeyboardType.email].contains(state.type)) const Spacer(),
        if (state.type == KeyboardType.editor) GazeKey(content: Icons.keyboard_tab_rounded, widthRatio: 2, type: GazeKeyType.tab, keyboardState: state),
        GazeKey(content: const ['q', 'Q', '1', '['], keyboardState: state),
        GazeKey(content: const ['w', 'W', '2', ']'], keyboardState: state),
        GazeKey(content: const ['e', 'E', '3', '{'], keyboardState: state),
        GazeKey(content: const ['r', 'R', '4', '}'], keyboardState: state),
        GazeKey(content: const ['t', 'T', '5', '#'], keyboardState: state),
        GazeKey(content: const ['y', 'Y', '6', '%'], keyboardState: state),
        GazeKey(content: const ['u', 'U', '7', '^'], keyboardState: state),
        GazeKey(content: const ['i', 'I', '8', '*'], keyboardState: state),
        GazeKey(content: const ['o', 'O', '9', '+'], keyboardState: state),
        GazeKey(content: const ['p', 'P', '0', '='], keyboardState: state),
      ],
      [
        GazeKey(
          content: const [CupertinoIcons.shift, CupertinoIcons.shift_fill, '#+=', CupertinoIcons.textformat_123],
          widthRatio: [KeyboardType.extended, KeyboardType.email].contains(state.type) ? 1 : 2,
          type: GazeKeyType.shift,
          keyboardState: state,
        ),
        GazeKey(content: const ['a', 'A', '-', '_'], keyboardState: state),
        GazeKey(content: const ['s', 'S', '/', r'\'], keyboardState: state),
        GazeKey(content: const ['d', 'D', ':', '|'], keyboardState: state),
        GazeKey(content: const ['f', 'F', ';', '~'], keyboardState: state),
        GazeKey(content: const ['g', 'G', '(', '<'], keyboardState: state),
        GazeKey(content: const ['h', 'H', ')', '>'], keyboardState: state),
        GazeKey(content: const ['j', 'J', '€', r'$'], keyboardState: state),
        GazeKey(content: const ['k', 'K', '&', '£'], keyboardState: state),
        GazeKey(content: const ['l', 'L', '@', '¥'], keyboardState: state),
        if (state.type == KeyboardType.email)
          GazeKey(content: const ['@', '.', '"', '•'], colors: [Colors.grey.shade800, Colors.grey.shade800, null, null], keyboardState: state, stacked: true)
        else
          GazeKey(content: const ['', '', '"', '•'], keyboardState: state),
      ],
      [
        GazeKey(
          content: const [CupertinoIcons.textformat_123, CupertinoIcons.textformat_123, CupertinoIcons.textformat_abc, CupertinoIcons.textformat_abc],
          type: GazeKeyType.signs,
          keyboardState: state,
        ),
        GazeKey(content: const ['z', 'Z', '', ''], keyboardState: state),
        GazeKey(content: const ['x', 'X', '.', '.'], keyboardState: state),
        GazeKey(content: const ['c', 'C', ',', ','], keyboardState: state),
        GazeKey(content: ' ', widthRatio: 2, keyboardState: state),
        GazeKey(content: const ['v', 'V', '?', '?'], keyboardState: state),
        GazeKey(content: const ['b', 'B', '!', '!'], keyboardState: state),
        GazeKey(content: const ['n', 'N', '´', '`'], keyboardState: state),
        GazeKey(content: const ['m', 'M', '', ''], keyboardState: state),
        if ([KeyboardType.extended, KeyboardType.email].contains(state.type))
          GazeKey(content: Icons.keyboard_hide, type: GazeKeyType.close, keyboardState: state),
        if (state.type == KeyboardType.editor) GazeKey(content: 'Enter', widthRatio: 2, type: GazeKeyType.enter, keyboardState: state),
      ],
    ];
  }

  @visibleForTesting
  static List<List<Widget>> germanSpeak(GazeKeyboardState state) {
    return [
      [
        const Spacer(),
        GazeKey(content: 'q', keyboardState: state),
        GazeKey(content: 'w', keyboardState: state),
        GazeKey(content: 'e', keyboardState: state),
        GazeKey(content: 'r', keyboardState: state),
        GazeKey(content: 't', keyboardState: state),
        GazeKey(content: 'z', keyboardState: state),
        GazeKey(content: 'u', keyboardState: state),
        GazeKey(content: 'i', keyboardState: state),
        GazeKey(content: 'o', keyboardState: state),
        GazeKey(content: 'p', keyboardState: state),
        GazeKey(content: 'ü', keyboardState: state),
      ],
      [
        GazeKey(content: const [CupertinoIcons.shift, CupertinoIcons.shift_fill], type: GazeKeyType.shift, keyboardState: state),
        GazeKey(content: 'a', keyboardState: state),
        GazeKey(content: 's', keyboardState: state),
        GazeKey(content: 'd', keyboardState: state),
        GazeKey(content: 'f', keyboardState: state),
        GazeKey(content: 'g', keyboardState: state),
        GazeKey(content: 'h', keyboardState: state),
        GazeKey(content: 'j', keyboardState: state),
        GazeKey(content: 'k', keyboardState: state),
        GazeKey(content: 'l', keyboardState: state),
        GazeKey(content: 'ö', keyboardState: state),
        GazeKey(content: 'ä', keyboardState: state),
      ],
      [
        const Spacer(),
        GazeKey(content: 'y', keyboardState: state),
        GazeKey(content: 'x', keyboardState: state),
        GazeKey(content: 'c', keyboardState: state),
        GazeKey(content: 'v', keyboardState: state),
        GazeKey(content: ' ', widthRatio: 2, keyboardState: state),
        GazeKey(content: 'b', keyboardState: state),
        GazeKey(content: 'n', keyboardState: state),
        GazeKey(content: 'm', keyboardState: state),
        GazeKey(content: const ['.', ','], keyboardState: state, color: Colors.grey.shade800, stacked: true),
        GazeKey(content: const ['?', '!'], keyboardState: state, color: Colors.grey.shade800, stacked: true),
      ],
    ];
  }

  @visibleForTesting
  static List<List<Widget>> englishSpeak(GazeKeyboardState state) {
    return [
      [
        const Spacer(),
        GazeKey(content: 'q', keyboardState: state),
        GazeKey(content: 'w', keyboardState: state),
        GazeKey(content: 'e', keyboardState: state),
        GazeKey(content: 'r', keyboardState: state),
        GazeKey(content: 't', keyboardState: state),
        GazeKey(content: 'y', keyboardState: state),
        GazeKey(content: 'u', keyboardState: state),
        GazeKey(content: 'i', keyboardState: state),
        GazeKey(content: 'o', keyboardState: state),
        GazeKey(content: 'p', keyboardState: state),
      ],
      [
        GazeKey(content: const [CupertinoIcons.shift, CupertinoIcons.shift_fill], type: GazeKeyType.shift, keyboardState: state),
        GazeKey(content: 'a', keyboardState: state),
        GazeKey(content: 's', keyboardState: state),
        GazeKey(content: 'd', keyboardState: state),
        GazeKey(content: 'f', keyboardState: state),
        GazeKey(content: 'g', keyboardState: state),
        GazeKey(content: 'h', keyboardState: state),
        GazeKey(content: 'j', keyboardState: state),
        GazeKey(content: 'k', keyboardState: state),
        GazeKey(content: 'l', keyboardState: state),
        GazeKey(content: const ["'", '-'], keyboardState: state, color: Colors.grey.shade800, stacked: true),
      ],
      [
        GazeKey(content: 'z', keyboardState: state),
        GazeKey(content: 'x', keyboardState: state),
        GazeKey(content: 'c', keyboardState: state),
        GazeKey(content: 'v', keyboardState: state),
        GazeKey(content: ' ', widthRatio: 2, keyboardState: state),
        GazeKey(content: 'b', keyboardState: state),
        GazeKey(content: 'n', keyboardState: state),
        GazeKey(content: 'm', keyboardState: state),
        GazeKey(content: const ['.', ','], keyboardState: state, color: Colors.grey.shade800, stacked: true),
        GazeKey(content: const ['?', '!'], keyboardState: state, color: Colors.grey.shade800, stacked: true),
      ],
    ];
  }
}
