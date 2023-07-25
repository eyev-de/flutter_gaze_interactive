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
}

class GazeKey extends ConsumerWidget {
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

  static Widget _buildContent(BuildContext context, Object content, bool? shift) {
    const textStyle = TextStyle(
      fontSize: 20,
    );
    if (content is List) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(content[0] as String,
                  style: textStyle.copyWith(
                    color: shift != null
                        ? shift
                            ? Colors.white
                            : Colors.grey.shade500
                        : Colors.white,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(content[1] as String,
                  style: textStyle.copyWith(
                    color: shift != null
                        ? shift
                            ? Colors.grey.shade500
                            : Colors.white
                        : Colors.white,
                  )),
            ],
          ),
        ],
      );
    } else if (content is String) {
      final _switchTo = shift != null && shift && content.length == 1 && validCharacters.hasMatch(content);
      return _spaceOut(Text(
        _switchTo ? content.toUpperCase() : content,
        style: TextStyle(fontSize: textStyle.fontSize, color: Colors.white),
      ));
    } else if (content is IconData) {
      return _spaceOut(Icon(
        content,
        color: Colors.white,
        // size: Responsive.getResponsiveValue(
        //   forVeryLargeScreen: 35,
        //   forLargeScreen: 25,
        //   forMediumScreen: 25,
        //   context: context,
        // ),
        size: 25,
      ));
    } else {
      return Container();
    }
  }

  static Widget _spaceOut(Widget content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            content,
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? shiftState;
    if (listenToShift) {
      final shift = ref.watch(keyboardState.shiftStateProvider);
      final capsLock = ref.watch(keyboardState.capsLockStateProvider);
      shiftState = shift ^ capsLock;
    }
    final _switchTo = shiftState ?? false;
    final changeColor = _switchTo && (type == GazeKeyType.caps || type == GazeKeyType.shift);
    return Flexible(
      flex: widthRatio.round(),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: GazeButton(
          properties: GazeButtonProperties(
            backgroundColor: changeColor ? Theme.of(context).primaryColor : Colors.grey.shade900,
            borderRadius: BorderRadius.zero,
            innerPadding: const EdgeInsets.all(0),
            child: _buildContent(context, content, shiftState),
            route: keyboardState.route,
            animationColor: !changeColor ? Theme.of(context).primaryColor : Colors.grey.shade900,
            gazeSelectionAnimationType: GazeSelectionAnimationType.fade,
            reselectable: true,
            withSound: true,
          ),
          onTap: () {
            if (content is List) {
              onTap.call((_switchTo ? (content as List)[0] : (content as List)[1]) as String?, type, ref, context);
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

  void onTap(String? str, GazeKeyType type, WidgetRef ref, BuildContext context) {
    final shift = ref.read(keyboardState.shiftStateProvider);
    final alt = ref.read(keyboardState.altStateProvider);
    final ctrl = ref.read(keyboardState.ctrlStateProvider);
    final capsLock = ref.read(keyboardState.capsLockStateProvider);
    switch (type) {
      case GazeKeyType.none:
        if (str != null) {
          keyboardState.controller.insert(str);
        }
        if (shift) {
          ref.read(keyboardState.shiftStateProvider.notifier).state = false;
        }
        if (alt) {
          ref.read(keyboardState.altStateProvider.notifier).state = false;
        }
        if (ctrl) {
          ref.read(keyboardState.ctrlStateProvider.notifier).state = false;
        }
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
        if (value.isNotEmpty) {
          keyboardState.controller.insert(value.substring(0, value.length - 1));
        }
        break;
      case GazeKeyType.enter:
        // widget.controller.text += r'\n';
        // _controller.sendKeyEvent(LogicalKeyboardKey.enter);
        // widget.node?.requestFocus();
        break;
      case GazeKeyType.tab:
        // widget.controller.text += r'\t';
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
    }
    keyboardState.node?.requestFocus();
  }
}
