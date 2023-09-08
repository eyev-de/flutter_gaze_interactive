//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

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
    // this.listenToShift = true,
    // this.listenToCapsLock = false,
    // this.listenToAlt = false,
    // this.listenToCtrl = false,
    this.onBack,
  }) : super(key: key);

  static final validCharacters = RegExp(r'^[a-zA-Zäöü]+$');

  final Object content;
  final GazeKeyType type;

  final GazeKeyboardState keyboardState;

  // final bool listenToShift;
  // final bool listenToAlt;
  // final bool listenToCtrl;
  // final bool listenToCapsLock;

  // final bool? shift;

  // final bool? alt;
  final String? altStr;

  // final bool? ctrl;
  final String? ctrlStr;

  final double widthRatio;
  final double heightRatio;

  final void Function(BuildContext)? onBack;

  static Widget _buildContent(BuildContext context, Object content, bool shift, GazeKeyboardState keyboardState, bool signs, GazeKeyType type) {
    const textStyle = TextStyle(fontSize: 20);
    switch (content) {
      case final List<dynamic> list:
        final cntnt = (keyboardState.keyboardPlatformType == KeyboardPlatformType.mobile && keyboardState.type != KeyboardType.speak)
            ? getIOSKey(list: list, signs: signs, shift: shift)
            : list[shift ? 1 : 0];
        if (cntnt is String) {
          if (cntnt == '') return Container();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    cntnt,
                    style: textStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          );
        }
        return _SpaceOut(child: Icon(cntnt as IconData, color: Colors.white, size: 25));
      case final String str:
        final _switchTo = shift && str.length == 1 && validCharacters.hasMatch(content);
        return _SpaceOut(
          child: Text(_switchTo ? str.toUpperCase() : str, style: TextStyle(fontSize: textStyle.fontSize, color: Colors.white)),
        );
      case final IconData icon:
        return _SpaceOut(child: Icon(icon, color: Colors.white, size: 25));
      default:
        // This is just blank space
        return Container();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if this key should change in appearance according to shift / caps lock state
    final shift = ref.watch(keyboardState.shiftStateProvider);
    final capsLock = ref.watch(keyboardState.capsLockStateProvider);
    // Current shift / caps lock state
    final shiftState = shift ^ capsLock;

    final signsState = ref.watch(keyboardState.signsStateProvider);
    // Either shiftState was set or it is false
    // It can be null
    final changeColor = type == GazeKeyType.caps && capsLock || type == GazeKeyType.shift && shift;
    final defaultColor = switch (type) {
      GazeKeyType.caps => Colors.grey.shade800,
      GazeKeyType.shift => Colors.grey.shade800,
      GazeKeyType.enter => Colors.grey.shade800,
      GazeKeyType.tab => Colors.grey.shade800,
      GazeKeyType.signs => Colors.grey.shade800,
      _ => Colors.grey.shade900,
    };

    final widget = _buildContent(context, content, shiftState, keyboardState, signsState, type);
    // This is just blank space
    if (widget is Container) return Flexible(flex: widthRatio.round(), child: widget);

    return Flexible(
      flex: widthRatio.round(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: GazeButton(
          properties: GazeButtonProperties(
            backgroundColor: changeColor ? Theme.of(context).primaryColor : defaultColor,
            innerPadding: EdgeInsets.zero,
            child: widget,
            route: keyboardState.route,
            animationColor: !changeColor ? Theme.of(context).primaryColor : defaultColor,
            gazeSelectionAnimationType: GazeSelectionAnimationType.fade,
            reselectable: true,
            withSound: true,
          ),
          onTap: () {
            if (content is List) {
              // What will be done & inserted in text field on pressed IconData on shift/signs tap
              switch (type) {
                case GazeKeyType.shift:
                case GazeKeyType.caps:
                case GazeKeyType.signs:
                case GazeKeyType.close:
                  _onTap.call(null, type, ref, context);
                  break;
                case GazeKeyType.alt:
                case GazeKeyType.ctrl:
                case GazeKeyType.del:
                case GazeKeyType.enter:
                case GazeKeyType.tab:
                case GazeKeyType.win:
                case GazeKeyType.none:
                  // What will be inserted on pressed normal key (not shift/signs)
                  if (keyboardState.keyboardPlatformType == KeyboardPlatformType.mobile && keyboardState.type != KeyboardType.speak) {
                    _onTap.call(getIOSKey(list: content as List, signs: signsState, shift: shiftState), type, ref, context);
                  } else {
                    _onTap.call((shiftState ? (content as List)[0] : (content as List)[1]) as String?, type, ref, context);
                  }
                  break;
              }
            } else if (content is String) {
              if (shiftState) {
                if ((content as String).length == 1 && validCharacters.hasMatch(content as String)) {
                  _onTap.call((content as String).toUpperCase(), type, ref, context);
                } else {
                  _onTap.call(content as String, type, ref, context);
                }
              } else {
                _onTap.call(content as String, type, ref, context);
              }
            } else if (content == Icons.space_bar) {
              _onTap.call(' ', type, ref, context);
            } else {
              _onTap.call(null, type, ref, context);
            }
          },
        ),
      ),
    );
  }

  void _onTap(str, GazeKeyType type, WidgetRef ref, BuildContext context) {
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
        // shift / capsLock becomes unselected when signs is pressed
        if (shift) ref.read(keyboardState.shiftStateProvider.notifier).state = false;
        if (capsLock) ref.read(keyboardState.capsLockStateProvider.notifier).state = false;
        ref.read(keyboardState.signsStateProvider.notifier).state = !signs;
        break;
    }
    keyboardState.node?.requestFocus();
  }

  /// Based on the shift and signs key the correct ios key will be chosen.
  @visibleForTesting
  static dynamic getIOSKey({required List<dynamic> list, required bool signs, required bool shift}) {
    if (list.length == 4) return shift ? (signs ? list[3] : list[1]) : (signs ? list[2] : list[0]);
    throw Exception('iOSKey not found, signs or shift key value might be null or key list length != 4');
  }
}

class _SpaceOut extends StatelessWidget {
  const _SpaceOut({required this.child});

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
