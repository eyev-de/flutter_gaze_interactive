//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoolNotifier extends Notifier<bool> {
  BoolNotifier(this._defaultValue);
  final bool _defaultValue;

  @override
  bool build() => _defaultValue;

  // ignore: use_setters_to_change_properties
  void set(bool value) => state = value;

  void toggle() => state = !state;
}

class SimpleNotifier<T> extends Notifier<T> {
  SimpleNotifier(this._defaultValue);
  final T _defaultValue;

  @override
  T build() => _defaultValue;

  // ignore: use_setters_to_change_properties
  void set(T value) => state = value;
}
