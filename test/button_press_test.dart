import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaze_interactive/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _app({required bool onDown, required VoidCallback onTap, GazeButtonTapTypes tapType = GazeButtonTapTypes.single, bool enabled = true}) async {
  SharedPreferences.setMockInitialValues({});
  final state = GazeInteractiveState(sharedPreferences: await SharedPreferences.getInstance());
  return ProviderScope(
    overrides: [gazeInteractiveProvider.overrideWithValue(state)],
    child: MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            height: 100,
            child: GazeButton(
              onTap: enabled ? onTap : null,
              properties: GazeButtonProperties(
                route: 'test',
                text: const Text('Key'),
                gazeInteractive: false,
                withSound: false,
                activateOnPointerDown: onDown,
                tapType: tapType,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// Mounts the app and flushes the zero-duration timers of the local store notifiers.
Future<void> _pump(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  group('activateOnPointerDown', () {
    testWidgets('fires on pointer down and not again on up', (tester) async {
      var taps = 0;
      await _pump(tester, await _app(onDown: true, onTap: () => taps++));
      final gesture = await tester.startGesture(tester.getCenter(find.text('Key')));
      expect(taps, 1);
      await gesture.up();
      await tester.pump();
      expect(taps, 1);
      // The next press is not suppressed by the previous one.
      await tester.tap(find.text('Key'));
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('a press that moves beyond the tap slop still fires exactly once', (tester) async {
      var taps = 0;
      await _pump(tester, await _app(onDown: true, onTap: () => taps++));
      final gesture = await tester.startGesture(tester.getCenter(find.text('Key')));
      await gesture.moveBy(const Offset(60, 0));
      await gesture.up();
      await tester.pump();
      expect(taps, 1);
      // A stuck suppression flag would swallow this semantics-less keyboard-like tap; a regular press must work.
      await tester.tap(find.text('Key'));
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('mouse secondary button does not fire, primary does', (tester) async {
      var taps = 0;
      await _pump(tester, await _app(onDown: true, onTap: () => taps++));
      final center = tester.getCenter(find.text('Key'));
      final secondary = await tester.startGesture(center, kind: PointerDeviceKind.mouse, buttons: kSecondaryMouseButton);
      expect(taps, 0);
      await secondary.up();
      await tester.pump();
      expect(taps, 0);
      final primary = await tester.startGesture(center, kind: PointerDeviceKind.mouse);
      expect(taps, 1);
      await primary.up();
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('a tap without pointer press (semantics) still fires', (tester) async {
      var taps = 0;
      final handle = tester.ensureSemantics();
      await _pump(tester, await _app(onDown: true, onTap: () => taps++));
      tester.semantics.tap(find.semantics.byLabel('Key'));
      await tester.pump();
      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('disabled button does not fire', (tester) async {
      var taps = 0;
      await _pump(tester, await _app(onDown: true, onTap: () => taps++, enabled: false));
      final gesture = await tester.startGesture(tester.getCenter(find.text('Key')));
      await gesture.up();
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('double tap buttons do not fire on pointer down', (tester) async {
      var taps = 0;
      await _pump(tester, await _app(onDown: true, onTap: () => taps++, tapType: GazeButtonTapTypes.double));
      final gesture = await tester.startGesture(tester.getCenter(find.text('Key')));
      expect(taps, 0);
      await gesture.up();
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(taps, 0);
    });
  });

  group('default behaviour', () {
    testWidgets('fires on up, not on down', (tester) async {
      var taps = 0;
      await _pump(tester, await _app(onDown: false, onTap: () => taps++));
      final gesture = await tester.startGesture(tester.getCenter(find.text('Key')));
      expect(taps, 0);
      await gesture.up();
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('a press that moves beyond the tap slop is cancelled', (tester) async {
      var taps = 0;
      await _pump(tester, await _app(onDown: false, onTap: () => taps++));
      final gesture = await tester.startGesture(tester.getCenter(find.text('Key')));
      await gesture.moveBy(const Offset(60, 0));
      await gesture.up();
      await tester.pump();
      expect(taps, 0);
    });
  });
}
