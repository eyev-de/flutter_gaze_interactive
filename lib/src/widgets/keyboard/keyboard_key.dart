//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions.dart';
import '../button/button.dart';
import '../button/selection_animation.dart';
import 'keyboard_state.dart';
import 'keyboards.dart';

enum GazeKeyType {
  none,
  ctrl,
  alt,
  win,
  shift,
  caps,
  enter,
  del,
  tab,
  close,
  signs,
}

class GazeKey extends ConsumerWidget {
  GazeKey({
    Key? key,
    required this.content,
    required this.keyboardState,
    this.type = GazeKeyType.none,
    this.widthRatio = 1,
    this.heightRatio = 1,
    // this.shift,
    // this.alt,
    this.altStr,
    // this.ctrl,
    this.ctrlStr,
    this.listenToShift = true,
    this.listenToCapsLock = false,
    this.listenToAlt = false,
    this.listenToCtrl = false,
    this.onBack,
  }) : super(key: key);

  static final validCharacters = RegExp(r'^[a-zA-Zäöü]+$');

  final Object content;
  final GazeKeyType type;

  final GazeKeyboardState keyboardState;

  final bool listenToShift;
  final bool listenToAlt;
  final bool listenToCtrl;
  final bool listenToCapsLock;

  // final bool? shift;

  // final bool? alt;
  final String? altStr;

  // final bool? ctrl;
  final String? ctrlStr;

  final double widthRatio;
  final double heightRatio;

  final void Function(BuildContext)? onBack;

  static Widget _buildContent(BuildContext context, Object content, bool? shift, GazeKeyboardState keyboardState, bool? signs, GazeKeyType type) {
    const textStyle = TextStyle(fontSize: 20);
    if (content is List) {
      if (content[0] is IconData) {
        // Drawing Shift and Sign Button based on current state
        final IconData icon = getIOSKey(list: content, signs: signs, shift: shift) as IconData;
        return _SpaceOut(child: Icon(icon, color: Colors.white, size: 25));
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                (keyboardState.keyboardPlatformType == KeyboardPlatformType.iOS && keyboardState.type != KeyboardType.speak)
                    ? getIOSKey(list: content, signs: signs, shift: shift) as String
                    : content[shift ?? false ? 0 : 1] as String,
                style: textStyle.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      );
    }
    if (content is String) {
      final _switchTo = shift != null && shift && content.length == 1 && validCharacters.hasMatch(content);
      return _SpaceOut(
        child: Text(_switchTo ? content.toUpperCase() : content, style: TextStyle(fontSize: textStyle.fontSize, color: Colors.white)),
      );
    }
    if (content is IconData) {
      return _SpaceOut(child: Icon(content, color: Colors.white, size: 25));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? shiftState;
    if (listenToShift) {
      final shift = ref.watch(keyboardState.shiftStateProvider);
      final capsLock = ref.watch(keyboardState.capsLockStateProvider);
      shiftState = shift ^ capsLock;
    }
    final signsState = ref.watch(keyboardState.signsStateProvider);
    final _switchTo = shiftState ?? false;
    final changeColor = _switchTo && (type == GazeKeyType.caps || type == GazeKeyType.shift);
    return Flexible(
      flex: widthRatio.round(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        child: GazeButton(
          properties: GazeButtonProperties(
            backgroundColor: changeColor ? Theme.of(context).primaryColor : Colors.grey.shade900,
            innerPadding: EdgeInsets.zero,
            child: _buildContent(context, content, shiftState, keyboardState, signsState, type),
            route: keyboardState.route,
            animationColor: !changeColor ? Theme.of(context).primaryColor : Colors.grey.shade900,
            gazeSelectionAnimationType: GazeSelectionAnimationType.fade,
            reselectable: true,
            withSound: true,
          ),
          onTap: () {
            if (content is List) {
              // What will be done & inserted in text field on pressed IconData on shift/signs tap
              if (type == GazeKeyType.shift || type == GazeKeyType.signs || type == GazeKeyType.close) {
                onTap.call(null, type, ref, context);
                // What will be inserted on pressed normal key (not shift/signs)
              } else {
                if (keyboardState.keyboardPlatformType == KeyboardPlatformType.iOS && keyboardState.type != KeyboardType.speak) {
                  onTap.call(getIOSKey(list: content as List, signs: signsState, shift: shiftState), type, ref, context);
                } else {
                  onTap.call((_switchTo ? (content as List)[0] : (content as List)[1]) as String?, type, ref, context);
                }
              }
            } else if (content is String) {
              if (_switchTo) {
                if ((content as String).length == 1 && validCharacters.hasMatch(content as String)) {
                  onTap.call((content as String).toUpperCase(), type, ref, context);
                } else {
                  onTap.call(content as String, type, ref, context);
                }
              } else {
                onTap.call(content as String, type, ref, context);
              }
            } else if (content == Icons.space_bar) {
              onTap.call(' ', type, ref, context);
            } else {
              onTap.call(null, type, ref, context);
            }
          },
        ),
      ),
    );
  }

  void onTap(dynamic? str, GazeKeyType type, WidgetRef ref, BuildContext context) {
    keyboardState.node?.requestFocus();
    final shift = ref.read(keyboardState.shiftStateProvider);
    final alt = ref.read(keyboardState.altStateProvider);
    final signs = ref.read(keyboardState.signsStateProvider);
    final ctrl = ref.read(keyboardState.ctrlStateProvider);
    final capsLock = ref.read(keyboardState.capsLockStateProvider);
    switch (type) {
      case GazeKeyType.none:
        if (str != null) keyboardState.controller.insert(str as String);
        if (shift) ref.read(keyboardState.shiftStateProvider.notifier).state = false;
        if (alt) ref.read(keyboardState.altStateProvider.notifier).state = false;
        if (ctrl) ref.read(keyboardState.ctrlStateProvider.notifier).state = false;
        break;
      case GazeKeyType.shift:
        ref.read(keyboardState.shiftStateProvider.notifier).state = !shift;
        break;
      case GazeKeyType.caps:
        ref.read(keyboardState.capsLockStateProvider.notifier).state = !capsLock;
        break;
      case GazeKeyType.del:
        // _controller.sendKeyEvent(LogicalKeyboardKey.backspace);
        // widget.node?.requestFocus();
        final String value = keyboardState.controller.text;
        if (value.isNotEmpty) keyboardState.controller.insert(value.substring(0, value.length - 1));
        break;
      case GazeKeyType.enter:
        if (keyboardState.type == KeyboardType.editor) keyboardState.controller.insert('\n');
        break;
      case GazeKeyType.tab:
        if (keyboardState.type == KeyboardType.editor) keyboardState.controller.insert('\t');
        // _controller.sendKeyEvent(LogicalKeyboardKey.tab);
        // widget.node?.requestFocus();
        break;
      case GazeKeyType.ctrl:
        ref.read(keyboardState.ctrlStateProvider.notifier).state = !ctrl;
        break;
      case GazeKeyType.alt:
        ref.read(keyboardState.altStateProvider.notifier).state = !alt;
        break;
      case GazeKeyType.close:
        keyboardState.onTabClose?.call(context);
        break;
      case GazeKeyType.win:
        break;
      case GazeKeyType.signs:
        // shift becomes unselected when signs is pressed
        if (shift) ref.read(keyboardState.shiftStateProvider.notifier).state = false;
        ref.read(keyboardState.signsStateProvider.notifier).state = !signs;
        break;
    }
    keyboardState.node?.requestFocus();
  }

  /// Based on the shift and signs key the correct ios key will be chosen.
  @visibleForTesting
  static dynamic getIOSKey({required List<dynamic> list, bool? signs, bool? shift}) {
    if (signs != null && list.length == 4 && shift != null) return shift ? (signs ? list[3] : list[1]) : (signs ? list[2] : list[0]);
    throw Exception('iOSKey not found, signs or shift key value might be null or key list length != 4');
  }
}

class _SpaceOut extends StatelessWidget {
  const _SpaceOut({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [child],
        ),
      ],
    );
  }
}
