//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../extensions.dart';
import '../button/button.dart';
import '../pointer/pointer_view.dart';
import 'keyboard_key.dart';
import 'keyboard_text.dart';
import 'keyboard_utility_buttons.dart';
import 'keyboards.dart';
import 'state.dart';

class GazeKeyboard {
  static final GazeKeyboard _instance = GazeKeyboard._internal();
  factory GazeKeyboard() {
    return _instance;
  }
  GazeKeyboard._internal();

  bool _isShown = false;
  bool get isShown => _isShown;

  final FocusNode node = FocusNode();

  Future<void> show(
    BuildContext context,
    GazeKeyboardState state,
    void Function()? before,
    void Function(BuildContext)? onBack,
    void Function(BuildContext)? onDismissed,
  ) {
    if (isShown) throw Exception('Keyboard can only be shown once. Close the open one before calling this again.');
    _isShown = !_isShown;
    if (before != null) before();
    state.withProvider = false;
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: 'KEYBOARD',
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        // state.node?.requestFocus();
        return Container(
          color: Colors.black,
          child: MultiProvider(
            providers: [ChangeNotifierProvider.value(value: state)],
            child: Consumer<GazeKeyboardState>(
              builder: (context, state, child) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Spacer(),
                                Flexible(
                                  flex: 8,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: GazeKeyboardTextWidget(
                                            state: state,
                                            node: node,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: SizedBox(
                                            height: 100,
                                            child: GazeButton(
                                              properties: GazeButtonProperties(
                                                backgroundColor: Colors.grey.shade900,
                                                borderRadius: BorderRadius.zero,
                                                icon: const Icon(
                                                  Icons.keyboard_backspace_rounded,
                                                  color: Colors.white,
                                                ),
                                                horizontal: true,
                                                route: state.route,
                                              ),
                                              onTap: () {
                                                node.requestFocus();
                                                final selection = state.controller.selection;
                                                if (state.controller.text.isNotEmpty) {
                                                  var startIndex =
                                                      selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
                                                  final endIndex =
                                                      selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;
                                                  startIndex = selection.baseOffset == selection.extentOffset ? startIndex - 1 : startIndex;
                                                  if (startIndex.isNegative) startIndex = 0;
                                                  state.controller.text = state.controller.text.replaceRange(startIndex, endIndex, '');
                                                  state.controller.selection = TextSelection.fromPosition(TextPosition(offset: startIndex));
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: SizedBox(
                                            height: 100,
                                            child: GazeButton(
                                              properties: GazeButtonProperties(
                                                backgroundColor: Colors.grey.shade900,
                                                borderRadius: BorderRadius.zero,
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                horizontal: true,
                                                route: state.route,
                                              ),
                                              onTap: () {
                                                node.requestFocus();
                                                state.controller.text = '';
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: SizedBox(
                                            height: 100,
                                            child: GazeButton(
                                              properties: GazeButtonProperties(
                                                backgroundColor: Colors.grey.shade900,
                                                borderRadius: BorderRadius.zero,
                                                innerPadding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                                                icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                ),
                                                horizontal: true,
                                                route: state.route,
                                              ),
                                              onTap: () {
                                                onBack?.call(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Spacer(),
                                  Flexible(
                                    flex: 8,
                                    child: GazeKeyboardUtilityButtons(state: state, node: node),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  _langButton(context, state),
                                  Flexible(
                                    flex: 8,
                                    child: GazeKeyboardWidget(
                                      state: state,
                                    ),
                                  ),
                                  _closeButton(context, state, onBack),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GazePointerView(),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).then((value) {
      _isShown = !_isShown;
      onDismissed?.call(context);
    });
  }

  static Widget _langButton(
    BuildContext context,
    GazeKeyboardState state,
  ) {
    return Flexible(
      child: Column(
        children: [
          const Spacer(
            flex: 3,
          ),
          Flexible(
            child: Container(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: GazeButton(
                  properties: GazeButtonProperties(
                    borderRadius: BorderRadius.zero,
                    // innerPadding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    backgroundColor: state.language == Language.german ? Theme.of(context).primaryColor : Colors.transparent,
                    text: 'GER',
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    route: state.route,
                  ),
                  onTap: () {
                    state.language = Language.german;
                  },
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: GazeButton(
                  properties: GazeButtonProperties(
                    borderRadius: BorderRadius.zero,
                    // innerPadding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    backgroundColor: state.language == Language.english ? Theme.of(context).primaryColor : Colors.transparent,
                    text: 'ENG',
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    route: state.route,
                  ),
                  onTap: () {
                    state.language = Language.english;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _closeButton(
    BuildContext context,
    GazeKeyboardState state,
    void Function(BuildContext)? onBack,
  ) {
    return Flexible(
      child: Column(
        children: [
          const Spacer(
            flex: 4,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: GazeButton(
                properties: GazeButtonProperties(
                  backgroundColor: Colors.grey.shade900,
                  borderRadius: BorderRadius.zero,
                  // innerPadding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  icon: const Icon(
                    Icons.keyboard_hide_rounded,
                    color: Colors.white,
                  ),
                  horizontal: true,
                  route: state.route,
                ),
                onTap: () {
                  onBack?.call(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GazeKeyboardWidget extends StatelessWidget {
  final GazeKeyboardState state;
  GazeKeyboardWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.withProvider) {
      return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: state)],
        child: Consumer<GazeKeyboardState>(
          builder: (context, state, child) {
            return _keyboard(state);
          },
        ),
      );
    }
    return _keyboard(state);
  }

  Widget _keyboard(GazeKeyboardState state) {
    final keys = Keyboards.get(state.language, state.route, shift: state.shift, capsLock: state.capsLock, action: action);
    if (!state.withNumbers) keys.removeAt(0);
    if (!state.withAlt) {
      keys[keys.length - 1].removeWhere((key) {
        if (key is GazeKey) return key.type == GazeKeyType.alt;
        return false;
      });
    }
    if (!state.withCtrl) {
      keys[keys.length - 1].removeWhere((key) {
        if (key is GazeKey) return key.type == GazeKeyType.ctrl;
        return false;
      });
    }
    return Column(
      children: [
        for (var row in keys)
          Flexible(
            child: Row(
              children: [
                for (var element in row) element,
              ],
            ),
          ),
      ],
    );
  }

  void action(String? str, GazeKeyType type) {
    switch (type) {
      case GazeKeyType.none:
        if (str != null) {
          state.controller.insert(str);
        }
        if (state.shift) {
          state.shift = false;
        }
        if (state.alt) {
          state.alt = false;
        }
        if (state.ctrl) {
          state.ctrl = false;
        }
        break;
      case GazeKeyType.shift:
        state.shift = !state.shift;
        break;
      case GazeKeyType.caps:
        state.capsLock = !state.capsLock;
        break;
      case GazeKeyType.del:
        // _controller.sendKeyEvent(LogicalKeyboardKey.backspace);
        // widget.node?.requestFocus();
        final String value = state.controller.text;
        if (value.isNotEmpty) {
          state.controller.insert(value.substring(0, value.length - 1));
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
        state.ctrl = !state.ctrl;
        break;
      case GazeKeyType.alt:
        state.alt = !state.alt;
        break;
      case GazeKeyType.win:
        break;
    }
    state.node?.requestFocus();
  }
}
