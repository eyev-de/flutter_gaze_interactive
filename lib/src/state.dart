//  Gaze Interactive
//
//  Created by the eyeV App Dev Team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/element_data.dart';
import 'core/element_type.dart';
import 'core/extensions.dart';
import 'core/local_store_notifiers.dart';

final clickSoundSource = AssetSource('packages/gaze_interactive/lib/assets/click.mp3');
final player = AudioPlayer()..setSource(clickSoundSource);

class GazeInteractive {
  late WidgetRef ref;
  Logger? logger;
  final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());
  static final GazeInteractive _instance = GazeInteractive._internal();
  factory GazeInteractive() {
    AudioCache.instance.prefix = '';
    unawaited(player.setVolume(1));
    return _instance;
  }
  GazeInteractive._internal();

  bool Function(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute)? predicate;

  String get currentRoute => ref.read(currentRouteStateProvider);
  set currentRoute(String value) {
    if (ref.read(currentRouteStateProvider) != value) {
      Future.delayed(const Duration(), () {
        ref.read(currentRouteStateProvider.notifier).state = value;
      });
    }
  }

  bool get active => ref.read(activeStateProvider);
  set active(bool value) {
    if (ref.read(activeStateProvider) != value) {
      Future.delayed(const Duration(), () {
        ref.read(activeStateProvider.notifier).state = value;
      });
    }
  }

  final activeStateProvider = StateProvider<bool>((ref) => true);

  final currentRouteStateProvider = StateProvider<String>((ref) => '');

  final currentRectStateProvider = StateProvider<Rect>((ref) => Rect.zero);

  final List<GazeElementData> _registeredGazeViews = [];
  List<GazeElementData> _currentGazeViews = [];

  void leaveAllGazeViews() {
    logger?.i('Leaving ${_currentGazeViews.length} gaze views...');
    for (final gazeView in _currentGazeViews) {
      gazeView.onGazeLeave?.call();
    }
    _currentGazeViews.clear();
  }

  final ListQueue<GazePointerData> _listOfGazePointerViews = ListQueue<GazePointerData>();
  GazePointerData? _currentGazePointerView;

  late final duration = StateNotifierProvider<GazeInteractiveDurationLocalNotifier, int>((ref) {
    return GazeInteractiveDurationLocalNotifier(ref.read(sharedPreferencesProvider));
  });

  late final recoverTime = StateNotifierProvider<GazeInteractiveRecoverTimeLocalNotifier, int>((ref) {
    return GazeInteractiveRecoverTimeLocalNotifier(ref.read(sharedPreferencesProvider));
  });

  late final scrollFactor = StateNotifierProvider<GazeInteractiveScrollFactorLocalNotifier, double>((ref) {
    return GazeInteractiveScrollFactorLocalNotifier(ref.read(sharedPreferencesProvider));
  });

  late final pointerSize = StateNotifierProvider<GazeInteractivePointerSizeLocalNotifier, double>((ref) {
    return GazeInteractivePointerSizeLocalNotifier(ref.read(sharedPreferencesProvider));
  });

  late final fixationRadius = StateNotifierProvider<GazeInteractiveFixationRadiusLocalNotifier, double>((ref) {
    return GazeInteractiveFixationRadiusLocalNotifier(ref.read(sharedPreferencesProvider));
  });

  void register(GazeElementData data) {
    logger?.i('GazeInteractiveLib: Register GazeInteractive: ${data.type}:');
    if (data.type == GazeElementType.pointer) {
      _listOfGazePointerViews.add(data as GazePointerData);
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
    final active = ref.read(activeStateProvider);
    if (active) {
      _currentGazePointerView?.onPointerMove = onPointerMove;
      _currentGazePointerView?.onGaze?.call(position);
      for (final view in _currentGazeViews) {
        view.onGaze?.call(position);
      }
    }
  }

  /// API endpoint for signaling a fixation.
  void onFixation() {
    final active = ref.read(activeStateProvider);
    if (active) {
      _currentGazePointerView?.onFixation?.call();
    }
  }

  /// Internal endpoint
  /// DO NOT USE
  /// TODO(krjw): Change it!!!
  void onPointerMove(
    Offset position,
    Size size,
  ) {
    final active = ref.read(activeStateProvider);
    if (!active) return;
    final rect = Rect.fromCenter(
      center: position,
      width: size.width,
      height: size.height,
    );
    ref.read(currentRectStateProvider.notifier).state = rect;
    final currentRoute = ref.read(currentRouteStateProvider);
    if (_currentGazePointerView != null) {
      _currentGazeViews = _getNewListOfActiveGazeElements(
        gazePointerRect: rect,
        currentElements: _currentGazeViews,
        registeredElements: _registeredGazeViews,
        currentGazePointer: _currentGazePointerView!,
        currentRoute: currentRoute,
        predicate: predicate,
      );
    }
  }

  static List<GazeElementData> _getNewListOfActiveGazeElements({
    required Rect gazePointerRect,
    required List<GazeElementData> currentElements,
    required List<GazeElementData> registeredElements,
    required GazeElementData currentGazePointer,
    required String currentRoute,
    bool Function(Rect elementRect, Rect gazePointerRect, String elementRoute, String currentRoute)? predicate,
  }) {
    if (currentElements.isNotEmpty) {
      // Remove all that were left by the gaze pointer
      currentElements.removeWhere((element) {
        if (!_determineIfGazeElementIsLookedAt(
          gazePointerRect: gazePointerRect,
          element: element,
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
    // Do not use entries in currentElements
    final _registeredElements = registeredElements.where((e1) => currentElements.where((e2) => e1.key == e2.key).isEmpty);
    // Searching registeredElements for a new element
    for (final element in _registeredElements) {
      if (_determineIfGazeElementIsLookedAt(
        gazePointerRect: gazePointerRect,
        element: element,
        currentGazePointer: currentGazePointer,
        currentRoute: currentRoute,
        predicate: predicate,
      )) {
        // New element was found
        element.onGazeEnter?.call();
        currentElements.add(element);
      }
    }
    return currentElements;
  }

  static bool _determineIfGazeElementIsLookedAt({
    required Rect gazePointerRect,
    required GazeElementData element,
    required GazeElementData? currentGazePointer,
    required String currentRoute,
    bool Function(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute)? predicate,
  }) {
    // Get bounds of the element
    final elementRect = element.key.globalPaintBounds;
    // Check if bounds and context exist
    if (elementRect != null) {
      // Check in case of supplied custom predicate
      if (predicate != null) return predicate(elementRect, gazePointerRect, element.route!, currentRoute);
      // Check if the route is the current one and if the rect of the gaze pointer overlaps the bounds of the element
      // This should be enough in most cases
      // Beware full screen dialogs and multiple navigators
      if (element.route == currentRoute && elementRect.overlaps(gazePointerRect)) {
        return true;
      }
    }
    return false;
  }
}

class GazeContext extends StatelessWidget {
  final Widget child;
  final SharedPreferences sharedPreferences;

  const GazeContext({super.key, required this.child, required this.sharedPreferences});

  @override
  Widget build(Object context) => ProviderScope(overrides: [
        GazeInteractive().sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ], child: _GazeContext(child: child));
}

class _GazeContext extends ConsumerStatefulWidget {
  final Widget child;
  const _GazeContext({required this.child});

  @override
  _GazeContextState createState() => _GazeContextState();
}

class _GazeContextState extends ConsumerState<_GazeContext> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GazeInteractive().ref = ref;
    ref
      ..listen(GazeInteractive().activeStateProvider, (prev, next) {
        GazeInteractive().leaveAllGazeViews();
      })
      ..listen(GazeInteractive().currentRouteStateProvider, (prev, next) {
        GazeInteractive().leaveAllGazeViews();
      });
    return ProviderScope(child: widget.child);
  }
}
