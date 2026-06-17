//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api.dart';
import '../../core/extensions.dart';
import 'keyboard_key_stacked.dart';

class GazeKey extends ConsumerWidget {
  GazeKey({
    super.key,
    required this.content,
    required this.keyboardState,
    this.type = GazeKeyType.none,
    this.widthRatio = 1,
    this.heightRatio = 1,
    this.altStr,
    this.ctrlStr,
    this.onBack,
    this.colors = const [],
    this.stacked = false,
    Color? color,
  }) : _color = color ?? tealColor.disabled;
  final Object content;
  final GazeKeyType type;
  final GazeKeyboardState keyboardState;
  final String? altStr;
  final String? ctrlStr;
  final double widthRatio;
  final double heightRatio;
  final void Function(BuildContext)? onBack;

  /// color of the tile depending on the respective content (same index)
  final List<Color?> colors;

  /// color of the tile regardless of the state
  final Color _color;

  /// Enables the content of the first two characters to be displayed on top of each other on a tile (no signs)
  final bool stacked;

  static final validCharacters = RegExp(r'^[a-zA-Zäöü]+$');

  static Widget _buildContent(
    BuildContext context,
    Object content,
    bool shift,
    GazeKeyboardState keyboardState,
    bool signs,
    GazeKeyType type,
    bool stacked,
    Color backgroundColor,
    bool disabled,
    double fontSize,
    double iconSize,
  ) {
    final signColor = backgroundColor.onColor(disabled: disabled);
    final textStyle = TextStyle(fontSize: fontSize, color: signColor);
    switch (content) {
      case final List<dynamic> list:
        if (stacked && !signs) {
          return _GazeKeyStacked(characters: list, textStyle: textStyle, shift: shift, backgroundColor: backgroundColor, iconSize: iconSize);
        }
        final cntnt = (keyboardState.keyboardPlatformType == KeyboardPlatformType.mobile && keyboardState.type != KeyboardType.speak)
            ? getIOSKey(list: list, signs: signs, shift: shift)
            : list[shift ? 1 : 0];
        if (cntnt is String) {
          if (cntnt.isEmpty) return Container();
          return Center(
            child: DefaultTextStyle.merge(style: textStyle, child: Text(cntnt)),
          );
        }
        if (cntnt is Text) {
          if (cntnt.data?.isEmpty ?? true) return Container();
          return Center(
            child: DefaultTextStyle.merge(style: textStyle, child: cntnt),
          );
        }
        return _SpaceOut(child: Icon(cntnt as IconData, color: signColor, size: iconSize));
      case final String str:
        final _switchTo = shift && str.length == 1 && validCharacters.hasMatch(content);
        return _SpaceOut(child: Text(_switchTo ? str.toUpperCase() : str, style: textStyle));
      case final IconData icon:
        return _SpaceOut(child: Icon(icon, color: signColor, size: iconSize));
      default:
        // This is just blank space
        return Container();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if this key should change in appearance according to shift / caps lock state
    final shift = ref.watch(keyboardState.shiftStateProvider);
    final capsLock = ref.watch(keyboardState.capsLockStateProvider);
    // Current shift / caps lock state
    final shiftState = shift ^ capsLock;
    final signsState = ref.watch(keyboardState.signsStateProvider);
    // Either shiftState was set or it is false
    // It can be null
    final changeColor = type == GazeKeyType.caps && capsLock || type == GazeKeyType.shift && shift;
    final widgetColor = getIOSKeyColor(colors: colors, signs: signsState, shift: shiftState);
    final defaultColor = type.defaultColor(customColor: Theme.of(context).primaryColor, fallbackColor: widgetColor ?? _color);
    final animationColor = type == GazeKeyType.close ? Colors.white.withValues(alpha: 0.5) : Theme.of(context).primaryColor;

    // if disabled -> keyboard buttons should not be clickable (gaze interactive)
    final disabled = ref.watch(keyboardState.disableStateProvider);

    // Persisted, user-adjustable size of the characters / icons shown on the keys.
    // A value of 0 means "auto" -> resolved per key from its box further below.
    final fontSize = ref.watch(ref.read(gazeInteractiveProvider).keyboardFontSize);
    final iconSize = ref.watch(ref.read(gazeInteractiveProvider).keyboardIconSize);

    final baseColor = changeColor ? Theme.of(context).primaryColor : defaultColor;
    final baseDisabledColor = type.defaultColor(customColor: tealColor.background, fallbackColor: Colors.black);
    final finalBackgroundColor = disabled ? baseDisabledColor : baseColor;

    // Whether this cell renders a button depends only on the content/state, not on
    // the size, so probe with the baseline sizes to detect blank (spacer) cells.
    final probe = _buildContent(
      context,
      content,
      shiftState,
      keyboardState,
      signsState,
      type,
      stacked,
      finalBackgroundColor,
      disabled,
      gazeInteractiveDefaultKeyboardFontSize,
      gazeInteractiveDefaultKeyboardIconSize,
    );
    if (probe is Container) return Flexible(flex: widthRatio.round(), child: probe); // This is just blank space
    return Flexible(
      flex: widthRatio.round(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: GazeButton(
          color: finalBackgroundColor,
          properties: GazeButtonProperties(
            innerPadding: EdgeInsets.zero,
            route: keyboardState.route,
            animationColor: !changeColor ? animationColor : defaultColor,
            gazeSelectionAnimationType: GazeSelectionAnimationType.fade,
            reselectable: true,
            reselectableCount: type == GazeKeyType.none ? ref.read(ref.read(gazeInteractiveProvider).reselectionNumberOfLetterKeys) : null,
            gazeInteractive: disabled == false,
            withSound: type != GazeKeyType.close,
            // All keyboard keys should not be snapped to
            snappable: false,
          ),
          onTap: disabled
              ? null
              : () {
                  if (content is List) {
                    // What will be done & inserted in text field on pressed IconData on shift/signs tap
                    switch (type) {
                      case GazeKeyType.shift:
                      case GazeKeyType.caps:
                      case GazeKeyType.signs:
                      case GazeKeyType.close:
                        _onTap.call(null, type, ref, context);
                        break;
                      case GazeKeyType.alt:
                      case GazeKeyType.ctrl:
                      case GazeKeyType.del:
                      case GazeKeyType.enter:
                      case GazeKeyType.tab:
                      case GazeKeyType.win:
                      case GazeKeyType.none:
                        // What will be inserted on pressed normal key (not shift/signs)
                        if (keyboardState.keyboardPlatformType == KeyboardPlatformType.mobile && keyboardState.type != KeyboardType.speak) {
                          _onTap.call(getIOSKey(list: content as List, signs: signsState, shift: shiftState), type, ref, context);
                        } else {
                          _onTap.call((shiftState ? (content as List)[1] : (content as List)[0]) as String?, type, ref, context);
                        }
                        break;
                    }
                  } else if (content is String) {
                    if (shiftState) {
                      if ((content as String).length == 1 && validCharacters.hasMatch(content as String)) {
                        _onTap.call((content as String).toUpperCase(), type, ref, context);
                      } else {
                        _onTap.call(content as String, type, ref, context);
                      }
                    } else {
                      _onTap.call(content as String, type, ref, context);
                    }
                  } else if (content == Icons.space_bar) {
                    _onTap.call(' ', type, ref, context);
                  } else {
                    _onTap.call(null, type, ref, context);
                  }
                },
          child: LayoutBuilder(
            builder: (context, constraints) {
              // A configured size > 0 wins; otherwise auto-size to this key's box.
              // Stacked keys draw two characters on top of each other, so they
              // get a font size budgeted for two lines instead of one.
              final resolvedFontSize = fontSize > 0
                  ? fontSize
                  : (stacked ? GazeKeyboardKeySizing.optimalStackedFontSize(constraints) : GazeKeyboardKeySizing.optimalFontSize(constraints));
              final resolvedIconSize = iconSize > 0 ? iconSize : GazeKeyboardKeySizing.optimalIconSize(constraints);
              return _buildContent(
                context,
                content,
                shiftState,
                keyboardState,
                signsState,
                type,
                stacked,
                finalBackgroundColor,
                disabled,
                resolvedFontSize,
                resolvedIconSize,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onTap(data, GazeKeyType type, WidgetRef ref, BuildContext context) {
    final shift = ref.read(keyboardState.shiftStateProvider);
    final alt = ref.read(keyboardState.altStateProvider);
    final signs = ref.read(keyboardState.signsStateProvider);
    final ctrl = ref.read(keyboardState.ctrlStateProvider);
    final capsLock = ref.read(keyboardState.capsLockStateProvider);

    keyboardState.onKey?.call(data: data, type: type);
    switch (type) {
      case GazeKeyType.none:
        if (data != null) keyboardState.controller.insert(data is Text ? data.data ?? '' : data as String, keyboardState.type, keyboardState.inputFormatters);
        if (shift) ref.read(keyboardState.shiftStateProvider.notifier).set(false);
        if (alt) ref.read(keyboardState.altStateProvider.notifier).set(false);
        if (ctrl) ref.read(keyboardState.ctrlStateProvider.notifier).set(false);
        break;
      case GazeKeyType.shift:
        ref.read(keyboardState.shiftStateProvider.notifier).set(!shift);
        break;
      case GazeKeyType.caps:
        ref.read(keyboardState.capsLockStateProvider.notifier).set(!capsLock);
        break;
      case GazeKeyType.del:
        keyboardState.controller.backspace(keyboardState.inputFormatters);
        break;
      case GazeKeyType.enter:
        if (keyboardState.type == KeyboardType.editor) keyboardState.controller.insert('\n', keyboardState.type, keyboardState.inputFormatters);
        break;
      case GazeKeyType.tab:
        if (keyboardState.type == KeyboardType.editor) keyboardState.controller.insert('\t', keyboardState.type, keyboardState.inputFormatters);
        // _controller.sendKeyEvent(LogicalKeyboardKey.tab);
        // widget.node?.requestFocus();
        break;
      case GazeKeyType.ctrl:
        ref.read(keyboardState.ctrlStateProvider.notifier).set(!ctrl);
        break;
      case GazeKeyType.alt:
        ref.read(keyboardState.altStateProvider.notifier).set(!alt);
        break;
      case GazeKeyType.close:
        ref.read(keyboardState.disableStateProvider.notifier).set(false);
        ref.read(keyboardSpeechToTextProvider.notifier).stop();
        keyboardState.onTabClose?.call(context);
        break;
      case GazeKeyType.win:
        break;
      case GazeKeyType.signs:
        // shift / capsLock becomes unselected when signs is pressed
        if (shift) ref.read(keyboardState.shiftStateProvider.notifier).set(false);
        if (capsLock) ref.read(keyboardState.capsLockStateProvider.notifier).set(false);
        ref.read(keyboardState.signsStateProvider.notifier).set(!signs);
        break;
    }
  }

  /// Based on the shift and signs key the correct ios key will be chosen.
  @visibleForTesting
  static dynamic getIOSKey({required List<dynamic> list, required bool signs, required bool shift}) {
    if (list.length == 4) return shift ? (signs ? list[3] : list[1]) : (signs ? list[2] : list[0]);
    throw Exception('iOSKey not found, signs or shift key value might be null or key list length != 4');
  }

  /// Based on the shift and signs key the correct ios key will be chosen.
  @visibleForTesting
  static Color? getIOSKeyColor({required List<Color?> colors, required bool signs, required bool shift}) {
    if (colors.length == 4) return shift ? (signs ? colors[3] : colors[1]) : (signs ? colors[2] : colors[0]);
    if (colors.length == 2) return shift ? colors[1] : colors[0];
    return null;
  }
}

class _GazeKeyStacked extends StatelessWidget {
  const _GazeKeyStacked({required this.characters, required this.textStyle, required this.backgroundColor, required this.iconSize, this.shift = false});

  final List<dynamic> characters;
  final TextStyle textStyle;
  final bool shift;
  final Color backgroundColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) return Container();
    if (characters.first is String) {
      return KeyboardKeyStackedString(characters: characters as List<String>, shift: shift, backgroundColor: backgroundColor, textStyle: textStyle);
    }
    if (characters.first is Text) return KeyboardKeyStackedText(texts: List<Text>.from(characters), shift: shift, backgroundColor: backgroundColor, textStyle: textStyle);
    if (characters.first is IconData) return KeyboardKeyStackedIcon(icons: characters as List<IconData>, shift: shift, size: iconSize);
    return Container();
  }
}

class _SpaceOut extends StatelessWidget {
  const _SpaceOut({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [child]),
      ],
    );
  }
}

/// Computes aesthetically pleasing key content sizes from the box a key occupies.
///
/// Used when [GazeInteractiveState.keyboardFontSize] / `keyboardIconSize` are left
/// at their "auto" default ([gazeInteractiveKeyboardSizeAuto], i.e. a value <= 0):
/// the size then adapts to the actual key dimensions so the keyboard stays "big but
/// nice" on any screen. Consumers can call it directly to preview the auto sizes.
class GazeKeyboardKeySizing {
  const GazeKeyboardKeySizing._();

  /// Optimal font size for the characters drawn on a key of the given [constraints].
  static double optimalFontSize(BoxConstraints constraints) => _optimal(
    constraints,
    heightFactor: 0.42,
    widthFactor: 0.6,
    min: gazeInteractiveMinKeyboardFontSize,
    max: gazeInteractiveMaxKeyboardFontSize,
    fallback: gazeInteractiveDefaultKeyboardFontSize,
  );

  /// Optimal font size for a *stacked* key (two characters drawn on top of
  /// each other, e.g. `. ,` or `? !`).
  ///
  /// Both characters share the key height, so each line gets a smaller share of
  /// the box than a single-content key (see [optimalFontSize]). The stacked
  /// renderer additionally enlarges the bottom character and adds a gap between
  /// the lines, so the budget here is deliberately conservative to leave room
  /// for both lines plus their spacing within the key.
  static double optimalStackedFontSize(BoxConstraints constraints) => _optimal(
    constraints,
    heightFactor: 0.26,
    widthFactor: 0.5,
    min: gazeInteractiveMinKeyboardFontSize,
    max: gazeInteractiveMaxKeyboardFontSize,
    fallback: gazeInteractiveDefaultKeyboardFontSize,
  );

  /// Optimal icon size for the icons drawn on a key of the given [constraints].
  static double optimalIconSize(BoxConstraints constraints) => _optimal(
    constraints,
    heightFactor: 0.52,
    widthFactor: 0.7,
    min: gazeInteractiveMinKeyboardIconSize,
    max: gazeInteractiveMaxKeyboardIconSize,
    fallback: gazeInteractiveDefaultKeyboardIconSize,
  );

  /// Optimal icon size for a keyboard utility button of the given [constraints].
  ///
  /// Utility buttons stack an icon over a text label, so the icon gets a smaller
  /// share of its box than a single-content key does (see [optimalIconSize]).
  static double optimalUtilityIconSize(BoxConstraints constraints) => _optimal(
    constraints,
    heightFactor: 0.34,
    widthFactor: 0.5,
    min: gazeInteractiveMinKeyboardUtilityIconSize,
    max: gazeInteractiveMaxKeyboardUtilityIconSize,
    fallback: gazeInteractiveDefaultKeyboardUtilityIconSize,
  );

  /// Optimal font size for the label of a keyboard utility button of the given
  /// [constraints].
  ///
  /// Utility buttons stack an icon over a text label, so the label gets a smaller
  /// share of its box than the icon does (see [optimalUtilityIconSize]).
  static double optimalUtilityFontSize(BoxConstraints constraints) => _optimal(
    constraints,
    heightFactor: 0.22,
    widthFactor: 0.45,
    min: gazeInteractiveMinKeyboardUtilityFontSize,
    max: gazeInteractiveMaxKeyboardUtilityFontSize,
    fallback: gazeInteractiveDefaultKeyboardUtilityFontSize,
  );

  /// Picks the larger size that still fits both dimensions of the key box, then
  /// clamps it into the configured range. Falls back to the baseline when a
  /// dimension is unbounded (e.g. inside an unconstrained test harness).
  static double _optimal(
    BoxConstraints constraints, {
    required double heightFactor,
    required double widthFactor,
    required double min,
    required double max,
    required double fallback,
  }) {
    final candidates = <double>[
      if (constraints.maxHeight.isFinite) constraints.maxHeight * heightFactor,
      if (constraints.maxWidth.isFinite) constraints.maxWidth * widthFactor,
    ];
    if (candidates.isEmpty) return fallback;
    return candidates.reduce(math.min).clamp(min, max).toDouble();
  }
}
