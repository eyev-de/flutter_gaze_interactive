import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaze_interactive/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _app({required Axis axis, required int active, double? width}) async {
  SharedPreferences.setMockInitialValues({});
  final state = GazeInteractiveState(sharedPreferences: await SharedPreferences.getInstance());
  final widget = GazeToggleButtons(
    route: 'test',
    axis: axis,
    color: const Color(0xFF0000FF),
    buttons: [
      GazeToggleButton(label: const Text('A'), active: active == 0, onTap: () {}),
      GazeToggleButton(label: const Text('Longer label'), active: active == 1, onTap: () {}),
      GazeToggleButton(label: const Text('Mid'), active: active == 2, onTap: () {}),
    ],
  );
  return ProviderScope(
    overrides: [gazeInteractiveProvider.overrideWithValue(state)],
    child: MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: width == null ? widget : SizedBox(width: width, child: widget),
        ),
      ),
    ),
  );
}

Rect _pill(WidgetTester tester) {
  final box = find.descendant(of: find.byType(GazeToggleButtons), matching: find.byType(DecoratedBox));
  final pills = box.evaluate().where(
    (e) => (e.widget as DecoratedBox).decoration is BoxDecoration && ((e.widget as DecoratedBox).decoration as BoxDecoration).color == const Color(0xFF0000FF),
  );
  expect(pills.length, 1);
  final render = pills.first.renderObject! as RenderBox;
  return render.localToGlobal(Offset.zero) & render.size;
}

Rect _segment(WidgetTester tester, String label) {
  final render = tester.renderObject<RenderBox>(find.ancestor(of: find.text(label), matching: find.byType(GazeButton)).first);
  return render.localToGlobal(Offset.zero) & render.size;
}

void main() {
  for (final axis in Axis.values) {
    testWidgets('pill slides along $axis', (tester) async {
      await tester.pumpWidget(await _app(axis: axis, active: 0, width: axis == Axis.vertical ? 300 : null));
      await tester.pump();
      await tester.pump();
      expect(_pill(tester), _segment(tester, 'A'));
      await tester.pumpWidget(await _app(axis: axis, active: 2, width: axis == Axis.vertical ? 300 : null));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 125));
      final mid = _pill(tester);
      final a = _segment(tester, 'A');
      final target = _segment(tester, 'Mid');
      expect(mid, isNot(a));
      expect(mid, isNot(target));
      await tester.pumpAndSettle();
      expect(_pill(tester), target);
    });
  }

  testWidgets('vertical without a width constraint', (tester) async {
    await tester.pumpWidget(await _app(axis: Axis.vertical, active: 1));
    await tester.pump();
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(_pill(tester), _segment(tester, 'Longer label'));
    await tester.pumpAndSettle();
  });
}
