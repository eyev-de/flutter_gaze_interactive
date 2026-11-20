//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';
import 'button_selection_animation.dart';

enum GazeButtonTapTypes { single, double }

class GazeButtonProperties {
  GazeButtonProperties({
    required this.route,
    this.text,
    this.icon,
    this.iconPadding,
    this.borderColor,
    this.borderWidth = 3,
    this.animationDuration,
    this.recoverDuration,
    this.maxTextLines = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.innerPadding = const EdgeInsets.all(20),
    this.direction = Axis.vertical,
    this.alignment = Alignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.gazeInteractive = true,
    this.tapType = GazeButtonTapTypes.single,
    this.gazeSelectionAnimationType = GazeSelectionAnimationType.progress,
    this.animationColor = Colors.black,
    this.reselectableCount,
    this.reselectable = false,
    this.withSound = false,
    this.snappable = true,
    this.adaptiveForeground = false,
    this.activateOnPointerDown = false,
  });

  final String route;
  final Widget? text;
  final Icon? icon;
  final EdgeInsets? iconPadding;
  final Color? borderColor;
  final double borderWidth;
  final int? animationDuration;
  final int? recoverDuration;
  final int maxTextLines;
  final BorderRadius borderRadius;
  final EdgeInsets innerPadding;
  final Axis direction;
  final Alignment alignment;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool gazeInteractive;
  final GazeButtonTapTypes tapType;
  final GazeSelectionAnimationType gazeSelectionAnimationType;
  final Color animationColor;
  final int? reselectableCount;
  final bool reselectable;
  final bool snappable;
  final bool withSound;

  /// Fade animation only: text and icon color follow the fading background (see [GazeSelectionAnimationProperties.adaptiveForeground]). The
  /// button's own default white text color is dropped for it, an explicit color on [text] / [icon] still wins.
  final bool adaptiveForeground;

  /// Fires the tap on pointer-down instead of pointer-up (touch, stylus and the primary mouse button; not trackpad). Only applies to enabled
  /// [GazeButtonTapTypes.single] buttons. A regular tap is cancelled when the pointer moves more than the tap slop between down and up, which
  /// loses presses when typing fast (e.g. on the on-screen keyboard). A press fired on down is not fired a second time on up; taps without a
  /// pointer press (semantics, Enter/Space) still fire.
  final bool activateOnPointerDown;
}

class GazeButton extends ConsumerStatefulWidget {
  GazeButton({
    super.key,
    required this.properties,
    this.child,
    this.color = Colors.transparent,
    this.onTap,
  }) : assert(
         (child == null || properties.text == null) &&
             (child == null || properties.icon == null),
         'You cannot specify a child widget as well as a text or icon. The child widget replaces all previously specified properties',
       );

  final GazeButtonProperties properties;
  final Widget? child;
  final Color color;
  final void Function()? onTap;

  @override
  ConsumerState<GazeButton> createState() => _GazeButtonState();
}

class _GazeButtonState extends ConsumerState<GazeButton> {
  // Created once and kept stable across rebuilds. GazeSelectionAnimation uses
  // this as its widget key, so a stable key lets it preserve its State
  // (gaze registration + animation controller) instead of being torn down and
  // re-registered every time this button rebuilds (e.g. on shift/caps toggle).
  final GlobalKey _wrappedKey = GlobalKey();

  void _handleTap() {
    // Resolve the container before the tap: the tap may dispose this widget (and with it its ref).
    final container = widget.properties.withSound ? ProviderScope.containerOf(context, listen: false) : null;
    // Tap first, the click sound is fire-and-forget and must never delay or break the action.
    widget.onTap!();
    if (container != null) unawaited(maybePlayButtonClickSound(container.read).catchError((Object _) {}));
  }

  @override
  Widget build(BuildContext context) {
    final properties = widget.properties;
    final color = widget.color;
    final onTap = widget.onTap;
    final disabledColor = color == Colors.transparent
        ? color
        : color.withValues(alpha: 0.3);
    return GazeSelectionAnimation(
      onGazed: onTap != null ? _handleTap : null,
      wrappedKey: _wrappedKey,
      wrappedWidget: _Button(
        properties: properties,
        onTap: onTap != null ? _handleTap : null,
        child: widget.child,
      ),
      properties: GazeSelectionAnimationProperties(
        backgroundColor: onTap != null ? color : disabledColor,
        route: properties.route,
        borderRadius: properties.borderRadius,
        borderWidth: properties.borderWidth,
        gazeInteractive: onTap != null && properties.gazeInteractive,
        type: properties.gazeSelectionAnimationType,
        animationColor: properties.animationColor,
        durationMs: properties.animationDuration,
        recoverMs: properties.recoverDuration,
        reselectable: properties.reselectable,
        reselectableCount: properties.reselectableCount,
        snappable: properties.snappable,
        adaptiveForeground: properties.adaptiveForeground,
      ),
    );
  }
}

class _Button extends StatefulWidget {
  const _Button({
    required this.properties,
    required this.onTap,
    required this.child,
  });

  final GazeButtonProperties properties;
  final void Function()? onTap;
  final Widget? child;

  @override
  State<_Button> createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  // True between a pointer-down that already fired the tap and the end of that pointer sequence; InkWell.onTap is swallowed meanwhile.
  bool _firedOnPointerDown = false;

  GazeButtonProperties get properties => widget.properties;
  void Function()? get onTap => widget.onTap;

  bool get _activatesOnPointerDown => properties.activateOnPointerDown && onTap != null && properties.tapType == GazeButtonTapTypes.single;

  bool _acceptsPointer(PointerDownEvent event) => switch (event.kind) {
    PointerDeviceKind.touch || PointerDeviceKind.stylus || PointerDeviceKind.invertedStylus || PointerDeviceKind.unknown => true,
    PointerDeviceKind.mouse => event.buttons & kPrimaryMouseButton != 0,
    PointerDeviceKind.trackpad => false,
  };

  void _onPointerDown(PointerDownEvent event) {
    if (!_acceptsPointer(event)) return;
    _firedOnPointerDown = true;
    onTap?.call();
  }

  // The tap recognizer delivers InkWell.onTap synchronously in the same dispatch as the pointer-up (right after this Listener ran), so a microtask
  // runs strictly after it. Clearing there (instead of in onTap) cannot leave the flag stuck when no onTap follows: drag beyond the slop,
  // cancel, or a second finger the recognizer never tracks.
  void _onPointerEnd(PointerEvent event) {
    if (_firedOnPointerDown) scheduleMicrotask(() => _firedOnPointerDown = false);
  }

  void _onInkWellTap() {
    if (_firedOnPointerDown) {
      _firedOnPointerDown = false;
      return;
    }
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = properties.text != null && properties.text is Text ? (properties.text! as Text).style?.color ?? Colors.white : Colors.white;
    final disabled = onTap == null;
    final child = widget.child;
    final ink = InkWell(
      borderRadius: properties.borderRadius,
      hoverColor: textColor.withAlpha(20),
      focusColor: textColor.withAlpha(20),
      splashColor: textColor.withAlpha(60),
      highlightColor: textColor.withAlpha(20),
      splashFactory: disabled ? NoSplash.splashFactory : null,
      onTap: !disabled && properties.tapType == GazeButtonTapTypes.single ? _onInkWellTap : null,
      onDoubleTap: !disabled && properties.tapType == GazeButtonTapTypes.double ? onTap : null,
      child: child != null
          ? AnimatedContainer(duration: const Duration(milliseconds: 150), child: child)
          : AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: properties.innerPadding,
              decoration: BoxDecoration(borderRadius: properties.borderRadius, border: _getBorder()),
              child: _ButtonChild(properties: properties),
            ),
    );
    // Always a Listener (callbacks null when inactive), so enabling / disabling the button never changes the tree above the InkWell (no remount).
    final active = _activatesOnPointerDown;
    return Listener(
      onPointerDown: active ? _onPointerDown : null,
      onPointerUp: active ? _onPointerEnd : null,
      onPointerCancel: active ? _onPointerEnd : null,
      child: ink,
    );
  }

  Border? _getBorder() {
    if (properties.borderColor == null) return null;
    if (onTap == null && properties.borderColor == Colors.transparent) return Border.all(color: Colors.transparent, width: properties.borderWidth);
    if (onTap == null) return Border.all(color: properties.borderColor!.withValues(alpha: 0.3), width: properties.borderWidth);
    return Border.all(color: properties.borderColor!, width: properties.borderWidth);
  }
}

class _ButtonChild extends StatelessWidget {
  const _ButtonChild({required this.properties});

  final GazeButtonProperties properties;

  @override
  Widget build(BuildContext context) {
    final padding = properties.text == null
        ? EdgeInsets.zero
        : EdgeInsets.only(right: properties.direction == Axis.horizontal ? 10 : 0, bottom: properties.direction == Axis.vertical ? 5 : 0);
    return Align(
      alignment: properties.alignment,
      child: Flex(
        direction: properties.direction,
        mainAxisAlignment: properties.mainAxisAlignment,
        crossAxisAlignment: properties.crossAxisAlignment,
        children: [
          if (properties.icon != null) Padding(padding: properties.iconPadding ?? padding, child: properties.icon),
          if (properties.text != null)
            Flexible(
              child: DefaultTextStyle.merge(
                style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
                  // Adaptive: take over the foreground the selection animation merged into the DefaultTextStyle instead of forcing white.
                  color: properties.adaptiveForeground ? DefaultTextStyle.of(context).style.color : Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: properties.maxTextLines,
                child: properties.text!,
              ),
            ),
        ],
      ),
    );
  }
}
