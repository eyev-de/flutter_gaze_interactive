import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaze_interactive/api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final GazeKeyboardState state = GazeKeyboardState(
    node: FocusNode(),
    route: '/dialog',
    placeholder: 'Search',
    type: KeyboardType.editor,
    controller: TextEditingController(),
    undoHistoryController: UndoHistoryController(),
    selectedKeyboardPlatformType: KeyboardPlatformType.mobile,
  );
  const List<String> content = ['q', 'Q', '1', '['];
  final List<dynamic> contentShift = (Keyboards.germanMobile(state)[1][0] as GazeKey).content as List<dynamic>;
  final List<dynamic> contentSigns = (Keyboards.germanMobile(state)[2][0] as GazeKey).content as List<dynamic>;

  test('On iOS Keyboard when shift key is NOT pressed and signs key is NOT pressed, top left key should return q.', () {
    final String key = GazeKey.getIOSKey(list: content, signs: false, shift: false) as String;
    expect(key, 'q');
  });

  test('On iOS Keyboard when shift key IS pressed and signs key is NOT pressed, top left key should return Q.', () {
    final String key = GazeKey.getIOSKey(list: content, signs: false, shift: true) as String;
    expect(key, 'Q');
  });

  test('On iOS Keyboard when shift key is NOT pressed and signs key IS  pressed, top left key should return 1.', () {
    final String key = GazeKey.getIOSKey(list: content, signs: true, shift: false) as String;
    expect(key, '1');
  });

  test('On iOS Keyboard when shift key IS  pressed and signs key IS  pressed, top left key should return 1.', () {
    final String key = GazeKey.getIOSKey(list: content, signs: true, shift: true) as String;
    expect(key, '[');
  });

  // Shift

  test('On iOS Keyboard shift key list of icons should be as followed', () {
    expect(contentShift, [CupertinoIcons.shift, CupertinoIcons.shift_fill, '#+=', CupertinoIcons.textformat_123]);
  });

  test('On iOS Keyboard when shift key is NOT pressed and signs key is NOT pressed, shift key should be shift.', () {
    final IconData key = GazeKey.getIOSKey(list: contentShift, signs: false, shift: false) as IconData;
    expect(key, CupertinoIcons.shift);
  });

  test('On iOS Keyboard when shift key IS pressed and signs key is NOT pressed, shift key should be shift filled.', () {
    final IconData key = GazeKey.getIOSKey(list: contentShift, signs: false, shift: true) as IconData;
    expect(key, CupertinoIcons.shift_fill);
  });

  test('On iOS Keyboard when shift key is NOT pressed and signs key IS pressed, shift key should be "#+=".', () {
    final String key = GazeKey.getIOSKey(list: contentShift, signs: true, shift: false) as String;
    expect(key, '#+=');
  });

  test('On iOS Keyboard when shift key IS pressed and signs key IS pressed, shift key should be 123.', () {
    final IconData key = GazeKey.getIOSKey(list: contentShift, signs: true, shift: true) as IconData;
    expect(key, CupertinoIcons.textformat_123);
  });

  // signs key

  test('On iOS Keyboard signs key list of icons should be as followed', () {
    expect(contentSigns, [CupertinoIcons.textformat_123, CupertinoIcons.textformat_123, CupertinoIcons.textformat_abc, CupertinoIcons.textformat_abc]);
  });

  test('On iOS Keyboard when shift key is NOT pressed and signs key is NOT pressed, signs key should be 123.', () {
    final IconData key = GazeKey.getIOSKey(list: contentSigns, signs: false, shift: false) as IconData;
    expect(key, CupertinoIcons.textformat_123);
  });

  test('On iOS Keyboard when shift key IS pressed and signs key is NOT pressed, signs key should be 123.', () {
    final IconData key = GazeKey.getIOSKey(list: contentSigns, signs: false, shift: true) as IconData;
    expect(key, CupertinoIcons.textformat_123);
  });

  test('On iOS Keyboard when shift key is NOT pressed and signs key IS  pressed, signs key should be abc.', () {
    final IconData key = GazeKey.getIOSKey(list: contentSigns, signs: true, shift: false) as IconData;
    expect(key, CupertinoIcons.textformat_abc);
  });

  test('On iOS Keyboard when shift key IS  pressed and signs key IS  pressed, signs key should be abc.', () {
    final IconData key = GazeKey.getIOSKey(list: contentSigns, signs: true, shift: true) as IconData;
    expect(key, CupertinoIcons.textformat_abc);
  });
}
