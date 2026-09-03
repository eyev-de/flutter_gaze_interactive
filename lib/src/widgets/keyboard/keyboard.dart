//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../api.dart';
import 'keyboard_mail_completions.dart';

class GazeKeyboard {
  factory GazeKeyboard() => _instance;

  GazeKeyboard._internal();
  static final GazeKeyboard _instance = GazeKeyboard._internal();
  final _scrollController = ScrollController();

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
      // Deliberately NOT barrierDismissible (the default): the keyboard fills the whole screen, so the barrier is only
      // reachable by accident - the four rounded corners of the background (a BoxDecoration with a borderRadius does not
      // hit-test its corners), the slide-in animation window, and a hardware keyboard's Escape key. Every one of those
      // closed the keyboard mid-typing without the user asking for it.
      barrierLabel: 'KEYBOARD',
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      pageBuilder: (context, animation, secondaryAnimation) => LayoutBuilder(
        builder: (context, constraints) {
          // Scale everything with the display: the text field and utility rows are exactly one key row high.
          // The screen is divided into key-row units: the keys grid takes keyRows of them, the text field and
          // utility rows one each (plus the mail completions row for email), and the top spacer keeps two.
          final keyRows = Keyboards.rowCount(state);
          final contentRows = 2 + (state.type == KeyboardType.email ? 1 : 0);
          final double height = (constraints.maxHeight - 20) / (keyRows + contentRows + 2);
          // One key of the keys grid below: every utility button is exactly one key wide and the rows span the
          // full screen width, aligning with the keys grid.
          final keyColumns = Keyboards.keyColumns(state);
          final double keyWidth = constraints.maxWidth / keyColumns;
          // Paint the background across the whole screen (including the bottom
          // safe-area inset, e.g. the home indicator) so no transparent gap shows
          // the screen behind. The SafeArea only keeps the interactive content
          // (keys) clear of the bottom inset.
          return DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: surfaceColor),
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // The area above the text row is otherwise empty; the app can put a header there (state.headerView,
                      // e.g. the message being answered). Bottom-aligned so it sits directly over the text field, inside
                      // the room the spacer had - the keyboard's own rows never move because of it.
                      Expanded(
                        child: state.headerView == null ? const SizedBox.shrink() : Align(alignment: Alignment.bottomCenter, child: state.headerView),
                      ),
                      // Text Widget row: submit (two keys) | text field | delete char | delete word -
                      // full screen width, aligning with the keys grid below.
                      SizedBox(
                        height: height,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Submit Button - two keys wide on the left, like the speak button on the talk page
                            SizedBox(
                              width: 2 * keyWidth,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                                child: _GazeKeyboardCheckButton(state: state, height: height, onBack: onBack),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                                // Subtract vertical padding from text field size
                                child: GazeKeyboardTextWidget(state: state, node: node, minHeight: height - 6, scrollController: _scrollController),
                              ),
                            ),
                            // Delete char and delete word - right of the text field (one two-key wide delete button while selecting)
                            _GazeKeyboardDeleteButtons(state: state, node: node, keyWidth: keyWidth, height: height),
                          ],
                        ),
                      ),
                      // Utility Buttons - below the text field, every button one key in size, undo/redo below the submit
                      // button and delete all below the delete word button
                      SizedBox(
                        height: height,
                        child: GazeKeyboardUtilityButtons(state: state, node: node, type: state.type, keyWidth: keyWidth),
                      ),
                      // Validation widget for the entered text – centered directly below the text field
                      if (state.validationView != null) Center(child: state.validationView),
                      // Mail proposals
                      if (state.type == KeyboardType.email)
                        SizedBox(
                          height: height,
                          child: KeyboardMailCompletions(state: state, node: node),
                        ),
                      // Keys grid - exactly keyRows key rows high, so every row above matches one key row. The app can
                      // swap the grid for a view of its own (state.keysOverride, e.g. an emoji keyboard) in the same box.
                      SizedBox(
                        height: keyRows * height + 20,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ValueListenableBuilder<Widget?>(
                            valueListenable: state.keysOverride,
                            builder: (context, override, keys) => override ?? keys!,
                            child: GazeKeyboardWidget(state: state),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GazePointerView(),
                ],
              ),
            ),
          );
        },
      ),
    ).then((value) {
      _isShown = !_isShown;
      onDismissed?.call(context);
    });
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
                color: Colors.grey.shade900,
                onTap: () => onBack?.call(context),
                properties: GazeButtonProperties(
                  direction: Axis.horizontal,
                  route: state.route,
                  borderRadius: BorderRadius.zero,
                  icon: const Icon(Icons.keyboard_hide_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Delete char and delete word to the right of the text field - collapses into one two-key wide
/// delete button while text is selected.
class _GazeKeyboardDeleteButtons extends ConsumerWidget {
  const _GazeKeyboardDeleteButtons({required this.state, required this.node, required this.keyWidth, required this.height});

  final GazeKeyboardState state;
  final FocusNode node;
  final double keyWidth;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    if (selecting) {
      return SizedBox(
        width: 2 * keyWidth,
        height: height + 2, // Compensating the top and bottom padding
        child: DeleteButton(state: state, node: node, label: 'Select'),
      );
    }
    return SizedBox(
      width: 2 * keyWidth,
      height: height + 2, // Compensating the top and bottom padding
      child: DeleteButton(state: state, node: node),
    );
  }
}

class _GazeKeyboardCheckButton extends ConsumerWidget {
  const _GazeKeyboardCheckButton({required this.height, required this.state, this.onBack});

  final double height;
  final GazeKeyboardState state;
  final void Function(BuildContext)? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: GazeButton(
        onTap: () {
          ref.read(state.disableStateProvider.notifier).set(false);
          ref.read(keyboardSpeechToTextProvider.notifier).stop();
          onBack?.call(context);
        },
        color: tealColor,
        properties: GazeButtonProperties(
          innerPadding: const EdgeInsets.all(0),
          icon: const Icon(Icons.check, color: surfaceColor),
          direction: Axis.horizontal,
          route: state.route,
        ),
      ),
    );
  }
}

class GazeKeyboardWidget extends ConsumerWidget {
  GazeKeyboardWidget({Key? key, required this.state}) : super(key: key);

  final GazeKeyboardState state;

  late final stateProvider = NotifierProvider<SimpleNotifier<GazeKeyboardState>, GazeKeyboardState>(() => SimpleNotifier(state));

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
        for (final row in keys) Flexible(child: Row(children: [for (final element in row) element])),
      ],
    );
  }
}
