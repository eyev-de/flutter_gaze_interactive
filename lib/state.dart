//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../extensions.dart';

enum GazeInteractiveType { selectable, scrollable }

class GazeInteractionData {
  final GlobalKey key;
  final String route;
  final void Function() onGazeEnter;
  final void Function() onGazeLeave;
  final GazeInteractiveType type;
  GazeInteractionData({
    required this.key,
    required this.route,
    required this.onGazeEnter,
    required this.onGazeLeave,
    required this.type,
  });
}

class GazePointerData {
  final GlobalKey key;
  final void Function(Offset) onGaze;
  GazePointerData({
    required this.key,
    required this.onGaze,
  });
}

class GazeInteractive extends ChangeNotifier {
  static final GazeInteractive _instance = GazeInteractive._internal();
  factory GazeInteractive() {
    return _instance;
  }
  GazeInteractive._internal() {
    load();
  }

  bool Function(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute)? predicate;

  String _currentRoute = '';
  String get currentRoute => _currentRoute;
  set currentRoute(String value) {
    if (_currentRoute != value) {
      _currentRoute = value;
      notifyListeners();
    }
  }

  Rect _rect = Rect.zero;
  Rect get rect => _rect;
  final List<GazeInteractionData> _listOfButtons = [];
  final List<GazeInteractionData> _listOfScrollViews = [];
  GazeInteractionData? _currentButton;
  GazeInteractionData? _currentScrollView;

  final ListQueue<GazePointerData> _listOfGazeViews = ListQueue<GazePointerData>();
  GazePointerData? _currentGazeView;

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var tmp = prefs.getInt('gazeInteractiveDuration') ?? 1800;
    _gazeInteractiveDuration = Duration(milliseconds: tmp);
    _gazeInteractiveScrollFactor = prefs.getDouble('gazeInteractiveScrollFactor') ?? 80;
    tmp = prefs.getInt('gazeInteractiveRecoverTime') ?? 2000;
    _gazeInteractiveRecoverTime = Duration(milliseconds: tmp);
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gazeInteractiveDuration', gazeInteractiveDuration.inMilliseconds);
    await prefs.setDouble('gazeInteractiveScrollFactor', gazeInteractiveScrollFactor);
    await prefs.setInt('gazeInteractiveRecoverTime', gazeInteractiveRecoverTime.inMilliseconds);
  }

  bool _active = true;
  bool get active => _active;
  set active(bool value) {
    _active = value;
    if (!_active) {
      _currentScrollView?.onGazeLeave();
      _currentScrollView = null;
      _currentButton?.onGazeLeave();
      _currentButton = null;
    }
    notifyListeners();
  }

  Duration _gazeInteractiveDuration = const Duration(milliseconds: 1800);
  Duration get gazeInteractiveDuration => _gazeInteractiveDuration;
  set gazeInteractiveDuration(Duration value) {
    _gazeInteractiveDuration = value;
    save();
    notifyListeners();
  }

  Duration _gazeInteractiveRecoverTime = const Duration(milliseconds: 3000);
  Duration get gazeInteractiveRecoverTime => _gazeInteractiveRecoverTime;
  set gazeInteractiveRecoverTime(Duration value) {
    _gazeInteractiveRecoverTime = value;
    save();
    notifyListeners();
  }

  double _gazeInteractiveScrollFactor = 80;
  double get gazeInteractiveScrollFactor => _gazeInteractiveScrollFactor;
  set gazeInteractiveScrollFactor(double value) {
    _gazeInteractiveScrollFactor = value;
    save();
    notifyListeners();
  }

  void register(GazeInteractionData data) {
    // print('Register:');
    switch (data.type) {
      case GazeInteractiveType.selectable:
        final exists = _listOfButtons.where((element) => element.key == data.key);
        if (exists.isEmpty) _listOfButtons.add(data);
        break;
      case GazeInteractiveType.scrollable:
        final exists = _listOfScrollViews.where((element) => element.key == data.key);
        if (exists.isEmpty) _listOfScrollViews.add(data);
        break;
    }
    // print('List of GazeButtons contains ${_listOfButtons.length} elements.');
    // print('List of GazeListViews contains ${_listOfScrollViews.length} elemenst.');
  }

  void unregister(GlobalKey key, GazeInteractiveType type) {
    // print('Unregister:');
    switch (type) {
      case GazeInteractiveType.selectable:
        _listOfButtons.removeWhere((element) => element.key == key);
        break;
      case GazeInteractiveType.scrollable:
        _listOfScrollViews.removeWhere((element) => element.key == key);
        break;
    }
    // print('List of GazeButtons contains ${_listOfButtons.length} elements.');
    // print('List of GazeListViews contains ${_listOfScrollViews.length} elemenst.');
  }

  void registerGazeView(GazePointerData element) {
    _listOfGazeViews.add(element);
    _currentGazeView = element;
  }

  void unregisterGazeView(GlobalKey key) {
    _listOfGazeViews.removeWhere((element) => element.key == key);
    if (_listOfGazeViews.isNotEmpty) {
      _currentGazeView = _listOfGazeViews.first;
    } else {
      _currentButton = null;
    }
  }

  void onGaze(Offset position) {
    _currentGazeView?.onGaze(position);
  }

  void newPosition({
    required Offset position,
    required double width,
    required double height,
  }) {
    if (!_active) return;
    _rect = Rect.fromCenter(
      center: position,
      width: width,
      height: height,
    );
    notifyListeners();
    _currentScrollView = _algo(
      rect: rect,
      current: _currentScrollView,
      list: _listOfScrollViews,
      currentGazePointer: _currentGazeView,
      currentRoute: currentRoute,
      predicate: predicate,
    );
    _currentButton = _algo(
      rect: rect,
      current: _currentButton,
      list: _listOfButtons,
      currentGazePointer: _currentGazeView,
      currentRoute: currentRoute,
      predicate: predicate,
    );
  }

  static GazeInteractionData? _algo({
    required Rect rect,
    GazeInteractionData? current,
    required List<GazeInteractionData> list,
    GazePointerData? currentGazePointer,
    required String currentRoute,
    bool Function(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute)? predicate,
  }) {
    if (current != null) {
      if (_check(
        gazePointerRect: rect,
        item: current,
        currentGazePointer: currentGazePointer,
        currentRoute: currentRoute,
        predicate: predicate,
      )) {
        // New position but no change in _current
        return current;
      } else {
        // New position and change in _current
        current.onGazeLeave();
      }
    }
    // Searching list
    for (final item in list) {
      if (_check(
        gazePointerRect: rect,
        item: item,
        currentGazePointer: currentGazePointer,
        currentRoute: currentRoute,
        predicate: predicate,
      )) {
        // New current found
        item.onGazeEnter();
        return item;
      }
    }
    return null;
  }

  static bool _check({
    required Rect gazePointerRect,
    required GazeInteractionData item,
    required GazePointerData? currentGazePointer,
    required String currentRoute,
    bool Function(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute)? predicate,
  }) {
    // Get bounds of Widget
    final itemRect = item.key.globalPaintBounds;
    // Check if bounds and context exist
    if (itemRect != null) {
      // Check in case of supplied custom predicate
      if (predicate != null) return predicate(itemRect, gazePointerRect, item.route, currentRoute);
      // Check if the route is the current one and if the rect overlaps the bounds of the widget
      // This should be enough in most cases
      // Beware full screen dialogs and multiple navigators
      if (item.route == currentRoute && itemRect.overlaps(gazePointerRect)) {
        return true;
      }
    }
    return false;
  }
}
