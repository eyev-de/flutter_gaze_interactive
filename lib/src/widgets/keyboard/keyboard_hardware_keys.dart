//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright (c) eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions.dart';
import 'keyboard_key_type.enum.dart';
import 'keyboard_state.dart';
import 'keyboards.dart';

/// What a hardware key press does to the gaze keyboard text.
enum GazeHardwareKeyCommand {
  insertText,
  backspace,
  deleteForward,
  moveLeft,
  moveRight,
  moveLineStart,
  moveLineEnd,
  enter,
  tab,
  copy,
  cut,
  paste,
  selectAll,
  undo,
  redo,
}

/// A hardware key press mapped to an edit of the gaze keyboard text (see [gazeHardwareKeyActionFor]).
@immutable
class GazeHardwareKeyAction {
  const GazeHardwareKeyAction(this.command, {this.text, this.extendSelection = false});

  final GazeHardwareKeyCommand command;

  /// The characters to insert, only for [GazeHardwareKeyCommand.insertText].
  final String? text;

  /// Shift held on a cursor move: move the selection extent instead of the caret.
  final bool extendSelection;

  @override
  bool operator ==(Object other) =>
      other is GazeHardwareKeyAction && other.command == command && other.text == text && other.extendSelection == extendSelection;

  @override
  int get hashCode => Object.hash(command, text, extendSelection);

  @override
  String toString() => 'GazeHardwareKeyAction($command, text: $text, extendSelection: $extendSelection)';
}

/// Hardware keys are handled on desktop only. Mobile keeps its behaviour (an iPad with a hardware keyboard is a separate
/// decision). Linux is included: it is a desktop target with the same read-only field and the same key event data.
bool gazeHardwareKeysSupported(TargetPlatform platform) => switch (platform) {
  TargetPlatform.macOS || TargetPlatform.windows || TargetPlatform.linux => true,
  TargetPlatform.android || TargetPlatform.iOS || TargetPlatform.fuchsia => false,
};

/// Whether [character] is text a key press may insert: no control characters (C0, DEL, C1) and none of the private-use
/// function key codes macOS reports for arrows, F-keys etc. (U+F700 - U+F8FF).
bool isInsertableKeyCharacter(String? character) {
  if (character == null || character.isEmpty) return false;
  for (final rune in character.runes) {
    if (rune < 0x20 || (rune >= 0x7F && rune <= 0x9F) || (rune >= 0xF700 && rune <= 0xF8FF)) return false;
  }
  return true;
}

/// Maps a hardware key event to an edit of the gaze keyboard text, or null when the key is not ours (the event then goes
/// on to the default text editing shortcuts and the rest of the app). Pure: the modifier state is passed in.
///
/// - Shortcuts use Cmd on macOS and Ctrl elsewhere: C / X / V / A / Z, Shift+Z (redo), Ctrl+Y (redo, not on macOS).
/// - Ctrl+Alt on Windows / Linux is AltGr and types its character (`@`, `{`, ...), it is never a shortcut.
/// - Option on macOS types its character too (`@` is Option+L on a German Mac layout).
/// - Cursor keys with other modifiers than Shift (word / document jumps) are left to the defaults.
GazeHardwareKeyAction? gazeHardwareKeyActionFor(
  KeyEvent event, {
  required TargetPlatform platform,
  bool shift = false,
  bool control = false,
  bool alt = false,
  bool meta = false,
}) {
  if (event is KeyUpEvent || !gazeHardwareKeysSupported(platform)) return null;
  final key = event.logicalKey;
  final mac = platform == TargetPlatform.macOS;
  final shortcut = mac ? meta && !control && !alt : control && !alt && !meta;
  if (shortcut) {
    if (key == LogicalKeyboardKey.keyC) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.copy);
    if (key == LogicalKeyboardKey.keyX) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.cut);
    if (key == LogicalKeyboardKey.keyV) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.paste);
    if (key == LogicalKeyboardKey.keyA) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.selectAll);
    if (key == LogicalKeyboardKey.keyZ) return GazeHardwareKeyAction(shift ? GazeHardwareKeyCommand.redo : GazeHardwareKeyCommand.undo);
    if (!mac && !shift && key == LogicalKeyboardKey.keyY) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.redo);
    return null;
  }
  // Any other Cmd / Ctrl combination (Cmd+Left, Ctrl+Left, Ctrl+Backspace, ...) is not ours. Ctrl+Alt stays: AltGr.
  if (meta || (control && (mac || !alt))) return null;

  if (key == LogicalKeyboardKey.backspace) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.backspace);
  if (key == LogicalKeyboardKey.delete) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.deleteForward);
  if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.enter);
  if (key == LogicalKeyboardKey.tab) return const GazeHardwareKeyAction(GazeHardwareKeyCommand.tab);
  final cursorCommand = switch (key) {
    LogicalKeyboardKey.arrowLeft => GazeHardwareKeyCommand.moveLeft,
    LogicalKeyboardKey.arrowRight => GazeHardwareKeyCommand.moveRight,
    LogicalKeyboardKey.home => GazeHardwareKeyCommand.moveLineStart,
    LogicalKeyboardKey.end => GazeHardwareKeyCommand.moveLineEnd,
    _ => null,
  };
  if (cursorCommand != null) return alt ? null : GazeHardwareKeyAction(cursorCommand, extendSelection: shift);

  final character = event.character;
  if (isInsertableKeyCharacter(character)) return GazeHardwareKeyAction(GazeHardwareKeyCommand.insertText, text: character);
  return null;
}

/// The selection after a cursor [command] on [value]. Steps by grapheme cluster (never into an emoji's surrogate pair);
/// Home / End go to the start / end of the current text line. Without [extend] a selection collapses to its start
/// (Left) or end (Right) first, like every text field does.
TextSelection gazeHardwareMoveSelection(TextEditingValue value, GazeHardwareKeyCommand command, {bool extend = false}) {
  // The grapheme helpers live on TextEditingController; a throwaway one over the value, disposed below.
  final controller = TextEditingController.fromValue(value);
  try {
    return _moveSelection(controller, command, extend: extend);
  } finally {
    controller.dispose();
  }
}

TextSelection _moveSelection(TextEditingController controller, GazeHardwareKeyCommand command, {required bool extend}) {
  final value = controller.value;
  final text = value.text;
  final sel = value.selection.isValid ? value.selection : TextSelection.collapsed(offset: text.length);
  final extent = sel.extentOffset.clamp(0, text.length);
  int lineStart(int offset) => offset <= 0 ? 0 : text.lastIndexOf('\n', offset - 1) + 1;
  int lineEnd(int offset) {
    final next = text.indexOf('\n', offset);
    return next < 0 ? text.length : next;
  }

  final int target;
  switch (command) {
    case GazeHardwareKeyCommand.moveLeft:
      if (!extend && !sel.isCollapsed) return TextSelection.collapsed(offset: sel.start);
      target = controller.graphemeBefore(extent);
    case GazeHardwareKeyCommand.moveRight:
      if (!extend && !sel.isCollapsed) return TextSelection.collapsed(offset: sel.end);
      target = controller.graphemeAfter(extent);
    case GazeHardwareKeyCommand.moveLineStart:
      target = lineStart(extent);
    case GazeHardwareKeyCommand.moveLineEnd:
      target = lineEnd(extent);
    case GazeHardwareKeyCommand.insertText:
    case GazeHardwareKeyCommand.backspace:
    case GazeHardwareKeyCommand.deleteForward:
    case GazeHardwareKeyCommand.enter:
    case GazeHardwareKeyCommand.tab:
    case GazeHardwareKeyCommand.copy:
    case GazeHardwareKeyCommand.cut:
    case GazeHardwareKeyCommand.paste:
    case GazeHardwareKeyCommand.selectAll:
    case GazeHardwareKeyCommand.undo:
    case GazeHardwareKeyCommand.redo:
      return sel;
  }
  return extend ? TextSelection(baseOffset: sel.baseOffset.clamp(0, text.length), extentOffset: target) : TextSelection.collapsed(offset: target);
}

/// Applies [action] to the gaze keyboard [state] through the same edit path the gaze keys use (the
/// [TextEditingControllerExtension] edits, `onKey`, the undo history controller). Returns whether the key was consumed.
///
/// Enter inserts a newline in the editor keyboard only - exactly like the gaze enter key, which does nothing else on
/// the other keyboard types; there the event is not consumed, so an app shortcut can still react to it. Tab inserts a
/// tab in the editor like the gaze tab key and is swallowed elsewhere: a focus traversal would move the focus out of the
/// field and end the hardware typing.
@visibleForTesting
bool applyGazeHardwareKeyAction(GazeKeyboardState state, GazeHardwareKeyAction action) {
  final controller = state.controller;
  final formatters = state.inputFormatters;
  switch (action.command) {
    case GazeHardwareKeyCommand.insertText:
      final text = action.text ?? '';
      state.onKey?.call(data: text, type: GazeKeyType.none);
      controller.insert(text, state.type, formatters, smartPunctuation: false);
      return true;
    case GazeHardwareKeyCommand.backspace:
      state.onKey?.call(data: null, type: GazeKeyType.del);
      controller.backspace(formatters);
      return true;
    case GazeHardwareKeyCommand.deleteForward:
      controller.deleteForward(formatters);
      return true;
    case GazeHardwareKeyCommand.moveLeft:
    case GazeHardwareKeyCommand.moveRight:
    case GazeHardwareKeyCommand.moveLineStart:
    case GazeHardwareKeyCommand.moveLineEnd:
      controller.selection = gazeHardwareMoveSelection(controller.value, action.command, extend: action.extendSelection);
      return true;
    case GazeHardwareKeyCommand.enter:
      if (state.type != KeyboardType.editor) return false;
      state.onKey?.call(data: '\n', type: GazeKeyType.enter);
      controller.insert('\n', state.type, formatters, smartPunctuation: false);
      return true;
    case GazeHardwareKeyCommand.tab:
      if (state.type == KeyboardType.editor) {
        state.onKey?.call(data: '\t', type: GazeKeyType.tab);
        controller.insert('\t', state.type, formatters, smartPunctuation: false);
      }
      return true;
    case GazeHardwareKeyCommand.copy:
      // The gaze copy / cut buttons take the whole text without a selection; a hardware shortcut without one does
      // nothing, like in every other text field (a Ctrl+X must never wipe the text).
      if (controller.selection.isValid && !controller.selection.isCollapsed) controller.copy();
      return true;
    case GazeHardwareKeyCommand.cut:
      if (controller.selection.isValid && !controller.selection.isCollapsed) controller.cut();
      return true;
    case GazeHardwareKeyCommand.paste:
      unawaited(_paste(state));
      return true;
    case GazeHardwareKeyCommand.selectAll:
      controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      return true;
    case GazeHardwareKeyCommand.undo:
      final undo = state.undoHistoryController;
      if (undo == null) return false;
      undo.undo();
      return true;
    case GazeHardwareKeyCommand.redo:
      final undo = state.undoHistoryController;
      if (undo == null) return false;
      undo.redo();
      return true;
  }
}

Future<void> _paste(GazeKeyboardState state) async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  final text = data?.text ?? '';
  if (text.isEmpty) return;
  // insert() replaces the selection, keeps the caret valid and runs the input formatters on the result.
  state.controller.insert(text, state.type, state.inputFormatters, smartPunctuation: false);
}

/// Routes hardware key presses to the gaze keyboard text on desktop (macOS, Windows, Linux) while the focus is inside
/// [child] - the read-only text field of the gaze keyboard, which never receives platform text input on purpose (it
/// would clobber [GazeKeyboardState.controller]). Key presses bubble from the field's focus node up to this widget before
/// the app-wide default text editing shortcuts see them. A no-op wrapper on mobile.
class GazeKeyboardHardwareKeys extends ConsumerWidget {
  const GazeKeyboardHardwareKeys({super.key, required this.state, required this.child});

  final GazeKeyboardState state;
  final Widget child;

  KeyEventResult _onKeyEvent(WidgetRef ref, KeyEvent event) {
    // A disabled keyboard (e.g. while speech to text runs) takes no gaze keys, so no hardware keys either.
    if (ref.read(state.disableStateProvider)) return KeyEventResult.ignored;
    final keyboard = HardwareKeyboard.instance;
    final action = gazeHardwareKeyActionFor(
      event,
      platform: defaultTargetPlatform,
      shift: keyboard.isShiftPressed,
      control: keyboard.isControlPressed,
      alt: keyboard.isAltPressed,
      meta: keyboard.isMetaPressed,
    );
    if (action == null || !applyGazeHardwareKeyAction(state, action)) return KeyEventResult.ignored;
    // Keep the select mode of the gaze utility buttons in sync, like the gaze cursor buttons do.
    if (ref.read(state.selectingStateProvider)) {
      ref.read(state.selectingWordStateProvider.notifier).set(state.controller.selection.textInside(state.controller.text).isNotEmpty);
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!gazeHardwareKeysSupported(defaultTargetPlatform)) return child;
    return Focus(canRequestFocus: false, skipTraversal: true, includeSemantics: false, onKeyEvent: (node, event) => _onKeyEvent(ref, event), child: child);
  }
}
