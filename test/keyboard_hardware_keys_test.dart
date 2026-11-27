import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaze_interactive/api.dart';
import 'package:gaze_interactive/src/widgets/keyboard/keyboard_hardware_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CountingUndoController extends UndoHistoryController {
  int undos = 0;
  int redos = 0;

  @override
  void undo() => undos++;

  @override
  void redo() => redos++;
}

KeyDownEvent _down(LogicalKeyboardKey key, {String? character}) =>
    KeyDownEvent(physicalKey: PhysicalKeyboardKey.keyA, logicalKey: key, character: character, timeStamp: Duration.zero);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('gazeHardwareKeyActionFor', () {
    const mac = TargetPlatform.macOS;
    const win = TargetPlatform.windows;

    test('characters are inserted on desktop, including umlauts and AltGr / Option results', () {
      expect(
        gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyA, character: 'a'), platform: mac),
        const GazeHardwareKeyAction(GazeHardwareKeyCommand.insertText, text: 'a'),
      );
      expect(
        gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.semicolon, character: '\u00f6'), platform: win),
        const GazeHardwareKeyAction(GazeHardwareKeyCommand.insertText, text: '\u00f6'),
      );
      // AltGr on Windows reports Ctrl + Alt: it types, it is no shortcut.
      expect(
        gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyQ, character: '@'), platform: win, control: true, alt: true),
        const GazeHardwareKeyAction(GazeHardwareKeyCommand.insertText, text: '@'),
      );
      expect(
        gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyL, character: '@'), platform: mac, alt: true),
        const GazeHardwareKeyAction(GazeHardwareKeyCommand.insertText, text: '@'),
      );
    });

    test('control and private-use characters are never inserted', () {
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.escape, character: '\u001b'), platform: mac), isNull);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.f1, character: '\uF704'), platform: mac), isNull);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.shiftLeft), platform: win), isNull);
    });

    test('nothing on mobile and nothing for key up events', () {
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyA, character: 'a'), platform: TargetPlatform.iOS), isNull);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyA, character: 'a'), platform: TargetPlatform.android), isNull);
      expect(
        gazeHardwareKeyActionFor(
          const KeyUpEvent(physicalKey: PhysicalKeyboardKey.keyA, logicalKey: LogicalKeyboardKey.keyA, timeStamp: Duration.zero),
          platform: mac,
        ),
        isNull,
      );
    });

    test('shortcuts use Cmd on macOS and Ctrl on Windows', () {
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyV, character: 'v'), platform: mac, meta: true)?.command, GazeHardwareKeyCommand.paste);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyV), platform: win, control: true)?.command, GazeHardwareKeyCommand.paste);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyC), platform: win, control: true)?.command, GazeHardwareKeyCommand.copy);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyX), platform: mac, meta: true)?.command, GazeHardwareKeyCommand.cut);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyA), platform: mac, meta: true)?.command, GazeHardwareKeyCommand.selectAll);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyZ), platform: mac, meta: true)?.command, GazeHardwareKeyCommand.undo);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyZ), platform: mac, meta: true, shift: true)?.command, GazeHardwareKeyCommand.redo);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyY), platform: win, control: true)?.command, GazeHardwareKeyCommand.redo);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyY), platform: mac, meta: true), isNull);
      // Ctrl on macOS and unknown shortcuts are left to the defaults.
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyV), platform: mac, control: true), isNull);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.keyS), platform: win, control: true), isNull);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.arrowLeft), platform: win, control: true), isNull);
    });

    test('editing and cursor keys', () {
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.backspace), platform: mac)?.command, GazeHardwareKeyCommand.backspace);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.delete), platform: win)?.command, GazeHardwareKeyCommand.deleteForward);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.enter, character: '\r'), platform: win)?.command, GazeHardwareKeyCommand.enter);
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.tab, character: '\t'), platform: win)?.command, GazeHardwareKeyCommand.tab);
      expect(
        gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.arrowLeft), platform: mac, shift: true),
        const GazeHardwareKeyAction(GazeHardwareKeyCommand.moveLeft, extendSelection: true),
      );
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.end), platform: win)?.command, GazeHardwareKeyCommand.moveLineEnd);
      // Option+Left (word jump) is left to the defaults.
      expect(gazeHardwareKeyActionFor(_down(LogicalKeyboardKey.arrowLeft), platform: mac, alt: true), isNull);
    });
  });

  group('gazeHardwareMoveSelection', () {
    TextEditingValue value(String text, TextSelection selection) => TextEditingValue(text: text, selection: selection);

    test('steps by grapheme cluster and extends with shift', () {
      const emoji = '\u{1F600}';
      final v = value('a${emoji}b', const TextSelection.collapsed(offset: 3));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveLeft), const TextSelection.collapsed(offset: 1));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveRight), const TextSelection.collapsed(offset: 4));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveLeft, extend: true), const TextSelection(baseOffset: 3, extentOffset: 1));
    });

    test('collapses a selection to its start / end without shift', () {
      final v = value('hello', const TextSelection(baseOffset: 4, extentOffset: 1));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveLeft), const TextSelection.collapsed(offset: 1));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveRight), const TextSelection.collapsed(offset: 4));
    });

    test('Home / End go to the current line', () {
      final v = value('one\ntwo\nthree', const TextSelection.collapsed(offset: 5));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveLineStart), const TextSelection.collapsed(offset: 4));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveLineEnd), const TextSelection.collapsed(offset: 7));
      expect(gazeHardwareMoveSelection(v, GazeHardwareKeyCommand.moveLineEnd, extend: true), const TextSelection(baseOffset: 5, extentOffset: 7));
    });
  });

  group('GazeKeyboardHardwareKeys widget', () {
    final desktop = TargetPlatformVariant(<TargetPlatform>{TargetPlatform.macOS, TargetPlatform.windows});
    late GazeKeyboardState state;
    late FocusNode node;
    late _CountingUndoController undo;
    String? clipboard;

    setUp(() {
      node = FocusNode();
      undo = _CountingUndoController();
      clipboard = null;
      state = GazeKeyboardState(
        controller: TextEditingController(),
        undoHistoryController: undo,
        route: '/test',
        type: KeyboardType.editor,
        selectedKeyboardPlatformType: KeyboardPlatformType.desktop,
      );
    });

    Future<void> pumpField(WidgetTester tester) async {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') clipboard = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        if (call.method == 'Clipboard.getData') return <String, Object?>{'text': clipboard};
        return null;
      });
      await tester.pumpWidget(
        ProviderScope(
          child: CupertinoApp(
            home: Center(
              child: GazeKeyboardHardwareKeys(
                state: state,
                child: CupertinoTextField(
                  readOnly: true,
                  autofocus: true,
                  focusNode: node,
                  controller: state.controller,
                  undoController: state.undoHistoryController,
                  keyboardType: TextInputType.none,
                  maxLines: 5,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(node.hasPrimaryFocus, isTrue, reason: 'the read-only field takes the focus with autofocus');
    }

    testWidgets('types, deletes, moves and selects on desktop', (tester) async {
      await pumpField(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyH, character: 'H');
      await tester.sendKeyEvent(LogicalKeyboardKey.keyI, character: 'i');
      await tester.sendKeyEvent(LogicalKeyboardKey.period, character: '.');
      await tester.sendKeyEvent(LogicalKeyboardKey.quote, character: '\u00e4');
      expect(state.controller.text, 'Hi.\u00e4', reason: 'no smart punctuation space for hardware typing');
      expect(state.controller.selection, const TextSelection.collapsed(offset: 4));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      expect(state.controller.text, 'Hi\u00e4');
      expect(state.controller.selection, const TextSelection.collapsed(offset: 2));

      await tester.sendKeyEvent(LogicalKeyboardKey.delete);
      expect(state.controller.text, 'Hi');

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyX, character: 'x');
      expect(state.controller.text, 'Hi\nx');

      // Gaze key edits in between keep working on the same controller and caret.
      state.controller.insert('y', state.type, state.inputFormatters);
      expect(state.controller.text, 'Hi\nxy');

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      expect(state.controller.selection, const TextSelection.collapsed(offset: 3));
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      expect(state.controller.selection, const TextSelection(baseOffset: 3, extentOffset: 5));
      await tester.sendKeyEvent(LogicalKeyboardKey.keyZ, character: 'z');
      expect(state.controller.text, 'Hi\nz');
    }, variant: desktop);

    testWidgets('clipboard and undo shortcuts on desktop', (tester) async {
      await pumpField(tester);
      final modifier = defaultTargetPlatform == TargetPlatform.macOS ? LogicalKeyboardKey.metaLeft : LogicalKeyboardKey.controlLeft;
      Future<void> shortcut(LogicalKeyboardKey key, {bool shift = false}) async {
        await tester.sendKeyDownEvent(modifier);
        if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(key);
        if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyUpEvent(modifier);
        await tester.pump();
      }

      state.controller.value = const TextEditingValue(text: 'hello world', selection: TextSelection.collapsed(offset: 11));
      // No selection: cut does nothing (the gaze cut button would take the whole text).
      await shortcut(LogicalKeyboardKey.keyX);
      expect(state.controller.text, 'hello world');

      await shortcut(LogicalKeyboardKey.keyA);
      expect(state.controller.selection, const TextSelection(baseOffset: 0, extentOffset: 11));
      await shortcut(LogicalKeyboardKey.keyC);
      expect(clipboard, 'hello world');

      state.controller.selection = const TextSelection(baseOffset: 11, extentOffset: 6);
      await shortcut(LogicalKeyboardKey.keyX);
      expect(clipboard, 'world');
      expect(state.controller.text, 'hello ');

      await shortcut(LogicalKeyboardKey.keyV);
      await shortcut(LogicalKeyboardKey.keyV);
      expect(state.controller.text, 'hello worldworld');

      await shortcut(LogicalKeyboardKey.keyZ);
      await shortcut(LogicalKeyboardKey.keyZ, shift: true);
      expect(undo.undos, 1);
      expect(undo.redos, 1);
    }, variant: desktop);

    testWidgets('the gaze keyboard text widget takes hardware keys', (tester) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      SharedPreferences.setMockInitialValues({});
      final gazeState = GazeInteractiveState(sharedPreferences: await SharedPreferences.getInstance());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [gazeInteractiveProvider.overrideWithValue(gazeState)],
          child: CupertinoApp(
            home: Center(
              child: SizedBox(
                width: 600,
                height: 120,
                child: GazeKeyboardTextWidget(node: node, state: state, scrollController: scrollController, minHeight: 100),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1));
      expect(node.hasPrimaryFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyO, character: 'o');
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK, character: 'k');
      expect(state.controller.text, 'ok');
      await tester.pump(const Duration(milliseconds: 300));
    }, variant: desktop);

    testWidgets('a disabled keyboard takes no hardware keys', (tester) async {
      await pumpField(tester);
      final container = ProviderScope.containerOf(tester.element(find.byType(CupertinoTextField)));
      container.read(state.disableStateProvider.notifier).set(true);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA, character: 'a');
      expect(state.controller.text, isEmpty);
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('changes nothing on mobile', (tester) async {
      await pumpField(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA, character: 'a');
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      expect(state.controller.text, isEmpty);
    }, variant: TargetPlatformVariant.mobile());
  });
}
