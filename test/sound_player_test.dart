import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaze_interactive/src/core/sound_player.util.dart';

void main() {
  test('nextPoolIndex rotates round robin', () {
    var i = 0;
    final seen = <int>[];
    for (var n = 0; n < 9; n++) {
      seen.add(i);
      i = nextPoolIndex(i, SoundPlayerUtil.poolSize);
    }
    expect(seen, [0, 1, 2, 3, 0, 1, 2, 3, 0]);
  });

  test('SerialJobQueue never interleaves jobs and survives errors', () async {
    final queue = SerialJobQueue();
    final log = <String>[];
    final gate = Completer<void>();
    final first = queue.run(() async {
      log.add('a start');
      await gate.future;
      log.add('a end');
    });
    final failing = queue.run(() async {
      log.add('b');
      throw StateError('boom');
    });
    final last = queue.run(() async => log.add('c'));
    await Future<void>.delayed(Duration.zero);
    expect(log, ['a start']);
    gate.complete();
    await Future.wait([first, failing, last]);
    expect(log, ['a start', 'a end', 'b', 'c']);
    await queue.idle;
  });
}
