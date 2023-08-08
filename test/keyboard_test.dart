import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaze_interactive/api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final GazeKeyboardState state = GazeKeyboardState(
    node: FocusNode(),
    placeholder: 'Search',
    controller: TextEditingController(),
    route: '/dialog',
    type: KeyboardType.editor,
    selectedKeyboardPlatformType: KeyboardPlatformType.iOS,
  );
  const List<String> content = ['q', 'Q', '1', '['];

  final List<IconData> contentShift = (Keyboards.germanIOS(state)[1][0] as GazeKey).content as List<IconData>;
  final List<IconData> contentSigns = (Keyboards.germanIOS(state)[2][0] as GazeKey).content as List<IconData>;

  // Testing: GazeKey.getIOSKey(list: content, signs: false, shift: false)

  setUpAll(() async {
    final GazeKeyboardState state = GazeKeyboardState(
      node: FocusNode(),
      placeholder: 'Search',
      controller: TextEditingController(),
      route: '/dialog',
      type: KeyboardType.editor,
      selectedKeyboardPlatformType: KeyboardPlatformType.iOS,
    );
    const List<String> content = ['q', 'Q', '1', '['];
    //List<List<Widget>> contentShifts = Keyboards.germanIOS(state);

    // ignore: prefer_final_locals
    final List<IconData> contentShift = (Keyboards.germanIOS(state)[1][0] as GazeKey).content as List<IconData>;
    final List<IconData> contentSigns = (Keyboards.germanIOS(state)[2][0] as GazeKey).content as List<IconData>;
    // Testing: GazeKey.getIOSKey(list: content, signs: false, shift: false)
  });

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
    expect(contentShift, [CupertinoIcons.shift, CupertinoIcons.shift_fill, CupertinoIcons.plus, CupertinoIcons.textformat_123]);
  });

  test('On iOS Keyboard when shift key is NOT pressed and signs key is NOT pressed, shift key should be shift.', () {
    final IconData key = GazeKey.getIOSKey(list: contentShift, signs: false, shift: false) as IconData;
    expect(key, CupertinoIcons.shift);
  });

  test('On iOS Keyboard when shift key IS pressed and signs key is NOT pressed, shift key should be shift filled.', () {
    final IconData key = GazeKey.getIOSKey(list: contentShift, signs: false, shift: true) as IconData;
    expect(key, CupertinoIcons.shift_fill);
  });

  test('On iOS Keyboard when shift key is NOT pressed and signs key IS  pressed, shift key should be +.', () {
    final IconData key = GazeKey.getIOSKey(list: contentShift, signs: true, shift: false) as IconData;
    expect(key, CupertinoIcons.plus);
  });

  test('On iOS Keyboard when shift key IS  pressed and signs key IS  pressed, shift key should be 123.', () {
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
  test('On iOS Keyboard when signs key is null, throws exception', () {
    expect(() => GazeKey.getIOSKey(list: content, signs: null, shift: true), throwsA(isA<Exception>()));
  });

  test('On iOS Keyboard when shift key is null, throws exception', () {
    expect(() => GazeKey.getIOSKey(list: content, signs: false, shift: null), throwsA(isA<Exception>()));
  });

  test('On iOS Keyboard when content length != 4 key is null, throws exception', () {
    expect(() => GazeKey.getIOSKey(list: ['q', '1', '['], signs: null, shift: true), throwsA(isA<Exception>()));

    expect(() => GazeKey.getIOSKey(list: ['q', 'Q', 'w', '1', '['], signs: null, shift: true), throwsA(isA<Exception>()));
  });
}
