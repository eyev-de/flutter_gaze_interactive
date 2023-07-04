//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStoreNotifier<T> extends StateNotifier<T> {
  LocalStoreNotifier(
    this.sharedPreferences,
    this.sharedPreferencesKey,
    this.defaultValue, {
    T? initialValue,
  }) : super(initialValue ?? sharedPreferences.get(sharedPreferencesKey) as T? ?? defaultValue) {
    Future(
      () async {
        await update(state);
      },
    );
  }

  SharedPreferences sharedPreferences;
  String sharedPreferencesKey;
  T defaultValue;

  Future<void> update(T value) async {
    if (value is String) {
      await sharedPreferences.setString(sharedPreferencesKey, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(sharedPreferencesKey, value);
    } else if (value is int) {
      await sharedPreferences.setInt(sharedPreferencesKey, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(sharedPreferencesKey, value);
    } else if (value is List<String>) {
      await sharedPreferences.setStringList(sharedPreferencesKey, value);
    } else if (value is Enum) {
      await sharedPreferences.setString(sharedPreferencesKey, EnumToString.convertToString(value));
    } else if (value is List<Enum>) {
      await sharedPreferences.setStringList(sharedPreferencesKey, value.map(EnumToString.convertToString).toList());
    }
    state = value;
  }

  T get getState => state;

  // @override
  // set state(T value) {
  //   assert(false, "Don't use the setter for state. Instead use `await update(value)`.");
  //   Future(() async {
  //     await update(value);
  //   });
  // }
}
