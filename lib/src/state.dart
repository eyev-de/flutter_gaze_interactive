//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'element_data.dart';
import 'element_type.dart';
import 'extensions.dart';

class GazeInteractive extends ChangeNotifier {
  Logger? logger;
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
      leaveAllGazeViews();
      notifyListeners();
    }
  }

  Rect _rect = Rect.zero;
  Rect get rect => _rect;

  final List<GazeElementData> _registeredGazeViews = [];
  List<GazeElementData> _currentGazeViews = [];

  void leaveAllGazeViews() {
    for (final gazeView in _currentGazeViews) {
      gazeView.onGazeLeave?.call();
    }
    _currentGazeViews.clear();
  }

  final ListQueue<GazeElementData> _listOfGazePointerViews = ListQueue<GazeElementData>();
  GazeElementData? _currentGazePointerView;

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var tmp = prefs.getInt('gazeInteractiveDuration') ?? 1800;
    _duration = Duration(milliseconds: tmp);
    _scrollFactor = prefs.getDouble('gazeInteractiveScrollFactor') ?? 80;
    _pointerSize = prefs.getDouble('gazeInteractiveGazePointerSize') ?? 50;
    _fixationRadius = prefs.getDouble('gazeInteractiveFixationRadius') ?? 100;
    tmp = prefs.getInt('gazeInteractiveRecoverTime') ?? 2000;
    _recoverTime = Duration(milliseconds: tmp);
  }

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gazeInteractiveDuration', duration.inMilliseconds);
    await prefs.setDouble('gazeInteractiveScrollFactor', scrollFactor);
    await prefs.setDouble('gazeInteractiveGazePointerSize', pointerSize);
    await prefs.setDouble('gazeInteractiveFixationRadius', fixationRadius);
    await prefs.setInt('gazeInteractiveRecoverTime', recoverTime.inMilliseconds);
  }

  bool _active = true;
  bool get active => _active;
  set active(bool value) {
    _active = value;
    if (!_active) {
      leaveAllGazeViews();
    }
    notifyListeners();
  }

  Duration _duration = const Duration(milliseconds: 1800);
  Duration get duration => _duration;
  set duration(Duration value) {
    _duration = value;
    save();
    notifyListeners();
  }

  Duration _recoverTime = const Duration(milliseconds: 3000);
  Duration get recoverTime => _recoverTime;
  set recoverTime(Duration value) {
    _recoverTime = value;
    save();
    notifyListeners();
  }

  double _scrollFactor = 80;
  double get scrollFactor => _scrollFactor;
  set scrollFactor(double value) {
    _scrollFactor = value;
    save();
    notifyListeners();
  }

  double _pointerSize = 50;
  double get pointerSize => _pointerSize;
  set pointerSize(double value) {
    _pointerSize = value;
    save();
    notifyListeners();
  }

  double _fixationRadius = 100;
  double get fixationRadius => _fixationRadius;
  set fixationRadius(double value) {
    _fixationRadius = value;
    save();
    notifyListeners();
  }

  void register(GazeElementData data) {
    logger?.i('GazeInteractiveLib: Register GazeInteractive: ${data.type}:');
    if (data.type == GazeElementType.pointer) {
      _listOfGazePointerViews.add(data);
      _currentGazePointerView = data;
    } else {
      final exists = _registeredGazeViews.where((element) => element.key == data.key);
      if (exists.isEmpty) _registeredGazeViews.add(data);
    }
    logger?.i('GazeInteractiveLib: List of GazeListViews contains ${_registeredGazeViews.length} elemenst.');
    logger?.i('GazeInteractiveLib: List of GazePointerViews contains ${_listOfGazePointerViews.length} elements.');
  }

  void unregister({required GlobalKey key, required GazeElementType type}) {
    logger?.i('GazeInteractiveLib: Unregister GazeInteractive: $type');
    if (type == GazeElementType.pointer) {
      _listOfGazePointerViews.removeWhere((element) => element.key == key);
      if (_listOfGazePointerViews.isNotEmpty) {
        _currentGazePointerView = _listOfGazePointerViews.last;
      } else {
        // _currentButton = null;
        leaveAllGazeViews();
      }
    } else {
      _registeredGazeViews.removeWhere((element) => element.key == key);
    }
    logger?.i('GazeInteractiveLib: List of GazeListViews contains ${_registeredGazeViews.length} elemenst.');
    logger?.i('GazeInteractiveLib: List of GazePointerViews contains ${_listOfGazePointerViews.length} elements.');
  }

  /// API endpoint for updating the current gaze position.
  void onGaze(Offset position) {
    if (active) {
      _currentGazePointerView?.onGaze?.call(position);
      for (final view in _currentGazeViews) {
        view.onGaze?.call(position);
      }
    }
  }

  /// API endpoint for signaling a fixation.
  void onFixation() {
    if (active) {
      _currentGazePointerView?.onFixation?.call();
    }
  }

  /// Internal endpoint
  /// DO NOT USE
  /// TODO(krjw): Change it!!!
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
    if (_currentGazePointerView != null) {
      _currentGazeViews = _algo(
        rect: rect,
        current: _currentGazeViews,
        list: _registeredGazeViews,
        currentGazePointer: _currentGazePointerView!,
        currentRoute: currentRoute,
        predicate: predicate,
      );
    }
  }

  static List<GazeElementData> _algo({
    required Rect rect,
    required List<GazeElementData> current,
    required List<GazeElementData> list,
    required GazeElementData currentGazePointer,
    required String currentRoute,
    bool Function(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute)? predicate,
  }) {
    if (current.isNotEmpty) {
      // Remove all that were left
      current.removeWhere((element) {
        if (!_check(
          gazePointerRect: rect,
          item: element,
          currentGazePointer: currentGazePointer,
          currentRoute: currentRoute,
          predicate: predicate,
        )) {
          element.onGazeLeave?.call();
          return true;
        }
        return false;
      });
    }
    // Do not use entries in current
    final _list = list.where((e1) => current.where((e2) => e1.key == e2.key).isEmpty);
    // Searching list for new item
    for (final item in _list) {
      if (_check(
        gazePointerRect: rect,
        item: item,
        currentGazePointer: currentGazePointer,
        currentRoute: currentRoute,
        predicate: predicate,
      )) {
        // New item found
        item.onGazeEnter?.call();
        current.add(item);
      }
    }
    return current;
  }

  static bool _check({
    required Rect gazePointerRect,
    required GazeElementData item,
    required GazeElementData? currentGazePointer,
    required String currentRoute,
    bool Function(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute)? predicate,
  }) {
    // Get bounds of Widget
    final itemRect = item.key.globalPaintBounds;
    // Check if bounds and context exist
    if (itemRect != null) {
      // Check in case of supplied custom predicate
      if (predicate != null) return predicate(itemRect, gazePointerRect, item.route!, currentRoute);
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
