//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../button/button.dart';
import '../pointer/pointer_view.dart';
import 'keyboard_key.dart';
import 'keyboard_state.dart';
import 'keyboard_text.dart';
import 'keyboard_utility_buttons.dart';
import 'keyboards.dart';

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
    state
      ..withProvider = false
      ..onTabClose = onBack;

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
        // This causes a lot of jank
        // final height = Responsive.getResponsiveValue<double>(
        //   forLargeScreen: 80,
        //   forMediumScreen: 60,
        //   context: context,
        // );
        const double height = 80;

        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  // Utility Buttons
                  SizedBox(
                    height: height,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Spacer(),
                        Flexible(
                          flex: 8,
                          child: GazeKeyboardUtilityButtons(state: state, node: node, type: state.type),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  // Text Widget & Utility Buttons
                  SizedBox(
                    height: height,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                                  child: GazeKeyboardTextWidget(state: state, node: node, minHeight: height),
                                ),
                              ),
                              // Delete Button
                              Flexible(
                                child: SizedBox(
                                  height: height + 2, // Compensating the top and bottom padding
                                  child: GazeKeyboardUtilityDeleteAllButton(controller: state.controller, node: node, route: state.route),
                                ),
                              ),
                              // Submit Button
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                                  child: SizedBox(
                                    height: height,
                                    child: GazeButton(
                                      onTap: () => onBack?.call(context),
                                      properties: GazeButtonProperties(
                                        innerPadding: const EdgeInsets.all(0),
                                        backgroundColor: Colors.grey.shade800,
                                        icon: const Icon(Icons.check, color: Colors.teal),
                                        horizontal: true,
                                        route: state.route,
                                      ),
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 8,
                            child: GazeKeyboardWidget(state: state),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              GazePointerView(),
            ],
          ),
        );
      },
    ).then((value) => {_isShown = !_isShown, onDismissed?.call(context)});
  }

  static Widget _closeButton(BuildContext context, GazeKeyboardState state, void Function(BuildContext)? onBack) {
    return Flexible(
      child: Column(
        children: [
          const Spacer(flex: 4),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: GazeButton(
                properties: GazeButtonProperties(
                  horizontal: true,
                  route: state.route,
                  borderRadius: BorderRadius.zero,
                  backgroundColor: Colors.grey.shade900,
                  // innerPadding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  icon: const Icon(Icons.keyboard_hide_rounded, color: Colors.white),
                ),
                onTap: () => onBack?.call(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GazeKeyboardWidget extends ConsumerWidget {
  GazeKeyboardWidget({Key? key, required this.state}) : super(key: key);

  final GazeKeyboardState state;

  late final stateProvider = StateProvider((ref) => state);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.withProvider ? _keyboard(ref.watch(stateProvider)) : _keyboard(state);
  }

  Widget _keyboard(GazeKeyboardState state) {
    final lang = state.language;
    final keys = Keyboards.get(lang, state);
    if (!state.withNumbers) keys.removeAt(0);
    if (!state.withAlt) keys[keys.length - 1].removeWhere((key) => key is GazeKey && key.type == GazeKeyType.alt);
    if (!state.withCtrl) keys[keys.length - 1].removeWhere((key) => key is GazeKey && key.type == GazeKeyType.ctrl);
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
}
