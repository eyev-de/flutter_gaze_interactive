//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaze_interactive/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Diag {
  _Diag(this.message, this.error);
  final String message;
  final Object? error;
}

class _Harness {
  _Harness(this.state);
  final GazeInteractiveState state;
  final List<_Diag> diagnostics = [];
  int nowMs = 0;
  int _sweeps = 0;

  /// One hit-test sweep at the middle of [_bounds] (alternating by 10px so the movement gate never swallows it).
  void sweep() {
    _sweeps++;
    state.onPointerMove(Offset(100 + (_sweeps % 2) * 10, 100), const Size(20, 20));
  }

  void sweepAt(int ms) {
    nowMs = ms;
    sweep();
  }

  static const Rect _bounds = Rect.fromLTWH(0, 0, 300, 300);

  GazeElementData element(String route, {void Function()? onEnter, void Function()? onLeave, GlobalKey? key}) {
    final data = GazeElementData(key: key ?? GlobalKey(), route: route, onGazeEnter: onEnter, onGazeLeave: onLeave)..cachedBounds = _bounds;
    state.register(data);
    return data;
  }
}

// The sweep lazily creates the snapping radius notifier, which schedules a zero-duration timer: create it here and flush the timer.
Future<void> _warmUp(WidgetTester tester, GazeInteractiveState state) async {
  state.ref.read(state.snappingRadius);
  await tester.pump(const Duration(milliseconds: 1));
}

Future<_Harness> _mount(WidgetTester tester, {Widget? child, String route = 'a'}) async {
  SharedPreferences.setMockInitialValues({});
  final state = GazeInteractiveState(sharedPreferences: await SharedPreferences.getInstance());
  final harness = _Harness(state);
  state
    ..diagnosticNowMs = (() => harness.nowMs)
    ..onDiagnostic = (message, {error, stackTrace}) => harness.diagnostics.add(_Diag(message, error));
  await tester.pumpWidget(
    GazeContext(
      state: state,
      child: MaterialApp(home: child ?? const SizedBox()),
    ),
  );
  await tester.pump(const Duration(milliseconds: 1));
  state
    ..currentRoute = route
    ..register(GazePointerData(key: GlobalKey(), onGaze: (_) {}));
  await _warmUp(tester, state);
  return harness;
}

PredicateReturnState _defaultPredicate(GazeShape element, GazeShape pointer, GazeShape snap, String itemRoute, String currentRoute) =>
    itemRoute == currentRoute && element.rect.contains(pointer.rect.center) ? PredicateReturnState.gaze : PredicateReturnState.none;

void main() {
  group('element errors in the sweep', () {
    testWidgets('a throwing element does not stop a healthy one; the error is reported once, then rate limited', (tester) async {
      final h = await _mount(tester);
      var healthyEntered = 0;
      h.element('broken');
      h.element('a', onEnter: () => healthyEntered++);
      h.state.predicate = (element, pointer, snap, itemRoute, currentRoute) {
        if (itemRoute == 'broken') throw StateError('boom');
        return _defaultPredicate(element, pointer, snap, itemRoute, currentRoute);
      };

      h.sweepAt(0);
      expect(healthyEntered, 1, reason: 'the healthy element is entered although the sweep visited a throwing one first');
      expect(h.state.currentGazeViews.map((e) => e.route), ['a']);
      expect(h.diagnostics, hasLength(1));
      expect(h.diagnostics.single.error, isA<StateError>());
      expect(h.diagnostics.single.message, contains('route broken'));

      // Same element again, within the 10 s window: suppressed.
      h.sweepAt(1000);
      h.sweepAt(2000);
      expect(h.diagnostics, hasLength(1));

      // After the window one report carrying the number of suppressed errors.
      h.sweepAt(11000);
      expect(h.diagnostics, hasLength(2));
      expect(h.diagnostics.last.message, contains('2 further errors suppressed'));
      expect(h.diagnostics.last.error, isA<StateError>());
      expect(healthyEntered, 1, reason: 'the healthy element stayed entered, never re-entered');
    });

    testWidgets('a whole broken subtree reports at most 3 new elements per window, the rest is counted into the next report', (tester) async {
      final h = await _mount(tester);
      for (var i = 0; i < 8; i++) {
        h.element('broken');
      }
      h.state.predicate = (element, pointer, snap, itemRoute, currentRoute) {
        if (itemRoute == 'broken') throw StateError('boom');
        return _defaultPredicate(element, pointer, snap, itemRoute, currentRoute);
      };
      h.sweepAt(0);
      expect(h.diagnostics, hasLength(3), reason: '8 new broken elements in one sweep: only 3 stack traces');
      h.sweepAt(5000);
      expect(h.diagnostics, hasLength(3), reason: 'still inside the window');
      h.sweepAt(10000);
      expect(h.diagnostics, hasLength(4), reason: 'next window: one report');
      expect(h.diagnostics.last.message, contains('further errors suppressed'));
    });

    testWidgets('a throwing callback does not stop the other elements and never breaks the sweep', (tester) async {
      final h = await _mount(tester);
      var entered = 0;
      h.element('a', onEnter: () => throw StateError('enter boom'));
      h.element('a', onEnter: () => entered++);
      h.sweepAt(0);
      expect(entered, 1);
      expect(h.diagnostics, hasLength(1));
      expect(h.diagnostics.single.message, contains('onGazeEnter'));
    });

    testWidgets('a throwing onGaze callback does not stop the other views', (tester) async {
      final h = await _mount(tester);
      var gazed = 0;
      h.state.currentGazeViews
        ..add(GazeElementData(key: GlobalKey(), route: 'a', onGaze: (_) => throw StateError('gaze boom')))
        ..add(GazeElementData(key: GlobalKey(), route: 'a', onGaze: (_) => gazed++));
      h.state.onGaze(const Offset(1, 1));
      expect(gazed, 1);
      expect(h.diagnostics, hasLength(1));
      h.state.onGaze(const Offset(2, 2));
      expect(h.diagnostics, hasLength(1), reason: 'second error of the same element is rate limited');
      await tester.pump(const Duration(seconds: 1)); // lets the cursor idle timer started by onGaze run out
    });

    testWidgets('without onDiagnostic nothing throws', (tester) async {
      final h = await _mount(tester);
      h.state.onDiagnostic = null;
      h.element('broken');
      h.state.predicate = (element, pointer, snap, itemRoute, currentRoute) => throw StateError('boom');
      expect(h.sweep, returnsNormally);
    });
  });

  group('routeFilter', () {
    testWidgets('skips an element before any bounds / predicate work', (tester) async {
      final h = await _mount(tester);
      var healthyEntered = 0;
      final measured = <String>[];
      h.element('broken');
      h.element('a', onEnter: () => healthyEntered++);
      h.state
        ..routeFilter = ((itemRoute, currentRoute) => itemRoute == currentRoute)
        ..predicate = (element, pointer, snap, itemRoute, currentRoute) {
          // The predicate receives the measured rect, so it must never see a filtered element.
          measured.add(itemRoute);
          if (itemRoute == 'broken') throw StateError('would throw when measured');
          return _defaultPredicate(element, pointer, snap, itemRoute, currentRoute);
        };
      h.sweepAt(0);
      h.sweepAt(1000);
      expect(measured.toSet(), {'a'});
      expect(h.diagnostics, isEmpty);
      expect(healthyEntered, 1);
    });

    testWidgets('an entered element is left once the filter rejects it', (tester) async {
      final h = await _mount(tester);
      var left = 0;
      h.element('a', onLeave: () => left++);
      h.sweepAt(0);
      expect(h.state.currentGazeViews, hasLength(1));
      h.state.routeFilter = (itemRoute, currentRoute) => false;
      h.sweepAt(100);
      expect(h.state.currentGazeViews, isEmpty);
      expect(left, 1);
    });
  });

  group('register / activate', () {
    testWidgets('register is idempotent per key (elements and pointers)', (tester) async {
      final h = await _mount(tester);
      final key = GlobalKey();
      var entered = 0;
      h.element('a', key: key, onEnter: () => entered++);
      h.element('a', key: key, onEnter: () => entered++);
      h.sweepAt(0);
      expect(h.state.currentGazeViews, hasLength(1));
      expect(entered, 1);

      // Had the duplicate pointer survived the single unregister, it would still be the current one and receive the gaze.
      final pointerKey = GlobalKey();
      var gazed = 0;
      h.state
        ..register(GazePointerData(key: pointerKey, onGaze: (_) => gazed++))
        ..register(GazePointerData(key: pointerKey, onGaze: (_) => gazed++))
        ..unregister(key: pointerKey, type: GazeElementType.pointer)
        ..onGaze(const Offset(1, 1));
      expect(gazed, 0);
      await tester.pump(const Duration(seconds: 1)); // lets the cursor idle timer started by onGaze run out
    });

    testWidgets('a button stays registered across a GlobalKey reparent (deactivate + activate)', (tester) async {
      final buttonKey = GlobalKey();
      final button = GazeButton(
        key: buttonKey,
        onTap: () {},
        properties: GazeButtonProperties(route: 'a', text: const Text('K')),
      );
      Widget app({required bool left}) => Row(
        children: [
          Expanded(child: left ? button : const SizedBox()),
          Expanded(child: left ? const SizedBox() : button),
        ],
      );
      SharedPreferences.setMockInitialValues({});
      final state = GazeInteractiveState(sharedPreferences: await SharedPreferences.getInstance());
      Future<void> mount({required bool left}) async {
        await tester.pumpWidget(
          GazeContext(
            state: state,
            child: MaterialApp(
              home: Scaffold(body: app(left: left)),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 1));
      }

      await mount(left: true);
      state
        ..currentRoute = 'a'
        ..register(GazePointerData(key: GlobalKey(), onGaze: (_) {}));
      await _warmUp(tester, state);
      state.onPointerMove(tester.getCenter(find.text('K')), const Size(10, 10));
      expect(state.currentGazeViews, hasLength(1));

      await mount(left: false);
      state.leaveAllGazeViews();
      state.onPointerMove(tester.getCenter(find.text('K')) + const Offset(1, 0), const Size(10, 10));
      expect(state.currentGazeViews, hasLength(1), reason: 'the reparented button must have registered again in activate()');
    });
  });

  group('unreachable episode', () {
    testWidgets('reports once after 3 s without a reachable element, once on recovery, with a flapping guard', (tester) async {
      final h = await _mount(tester);
      h.state.routeFilter = (itemRoute, currentRoute) => itemRoute == currentRoute;
      h.element('b');
      h.element('c');

      for (final t in [0, 1000, 2000]) {
        h.sweepAt(t);
      }
      expect(h.diagnostics, isEmpty, reason: 'not yet 3 s');
      h.sweepAt(3000);
      expect(h.diagnostics, hasLength(1));
      final report = h.diagnostics.single.message;
      expect(report, contains('no element is reachable'));
      expect(report, contains('currentRoute a'));
      expect(report, contains('registered 2'));
      expect(report, contains('filtered by route 2'));
      expect(report, contains('no bounds 0'));
      expect(report, contains('errors 0'));
      expect(report, contains('[b, c]'));
      h.sweepAt(4000);
      h.sweepAt(5000);
      expect(h.diagnostics, hasLength(1), reason: 'reported once per episode');

      // Recovery: a reachable element appears.
      final healthyKey = GlobalKey();
      h.element('a', key: healthyKey);
      h.sweepAt(6000);
      expect(h.diagnostics, hasLength(2));
      expect(h.diagnostics.last.message, contains('reachable again after 6.0 s'));
      h.sweepAt(7000);
      expect(h.diagnostics, hasLength(2), reason: 'recovery is reported once');

      // A new episode within 60 s of the last report is not reported again (flapping guard).
      h.state.unregister(key: healthyKey, type: GazeElementType.all);
      for (var t = 8000; t <= 14000; t += 1000) {
        h.sweepAt(t);
      }
      expect(h.diagnostics, hasLength(2));

      // Once the guard has passed, the next long episode reports again.
      for (var t = 61000; t <= 65000; t += 1000) {
        h.sweepAt(t);
      }
      expect(h.diagnostics, hasLength(3));
      expect(h.diagnostics.last.message, contains('no element is reachable'));
    });

    testWidgets('an unrecovered, unreported short episode never reports recovery; null bounds and errors count as unreachable', (tester) async {
      final h = await _mount(tester);
      final noBounds = GazeElementData(key: GlobalKey(), route: 'a');
      h.state.register(noBounds);
      h.sweepAt(0);
      h.sweepAt(1000);
      final healthyKey = GlobalKey();
      h.element('a', key: healthyKey);
      h.sweepAt(2000);
      expect(h.diagnostics, isEmpty);
      h.state.unregister(key: healthyKey, type: GazeElementType.all);
      for (var t = 3000; t <= 6000; t += 1000) {
        h.sweepAt(t);
      }
      expect(h.diagnostics, hasLength(1));
      expect(h.diagnostics.single.message, contains('no bounds 1'));
    });

    testWidgets('a gaze pause longer than 1.5 s restarts the episode instead of counting as an outage', (tester) async {
      final h = await _mount(tester);
      h.state.routeFilter = (itemRoute, currentRoute) => false;
      h.element('b');
      h.sweepAt(0);
      h.sweepAt(60000);
      expect(h.diagnostics, isEmpty);
    });
  });
}
