import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../api.dart';

class GazeToggleButton {
  GazeToggleButton({required this.label, this.icon, this.onTap, this.active = false, this.onButtonColor});

  final Text label;
  final IconData? icon;
  final void Function()? onTap;
  final bool active;

  /// Ignored: the content color is adaptive (readable on the segment's current, fading background) and picked by the button itself.
  final Color? onButtonColor;
}

class GazeToggleButtons extends StatefulWidget {
  const GazeToggleButtons({super.key, required this.route, required this.buttons, this.axis = Axis.horizontal, this.borderWidth = 4, this.color});

  const GazeToggleButtons.horizontal({super.key, required this.route, required this.buttons, this.borderWidth = 4, this.color}) : axis = Axis.horizontal;

  const GazeToggleButtons.vertical({super.key, required this.route, required this.buttons, this.borderWidth = 4, this.color}) : axis = Axis.vertical;

  final String route;
  final List<GazeToggleButton> buttons;
  final Axis axis;

  /// Inset of the track and gap between the segments.
  final double borderWidth;
  final Color? color;

  /// Corner radius of the selection pill / segments, matched to the app's tiles
  /// (settings tiles use 14). The track around it stays concentric: segment
  /// radius + the gap ([borderWidth]).
  static const double _segmentRadius = 14;

  @override
  State<GazeToggleButtons> createState() => _GazeToggleButtonsState();
}

class _GazeToggleButtonsState extends State<GazeToggleButtons> with SingleTickerProviderStateMixin {
  static const Duration _slideDuration = Duration(milliseconds: 250);

  final GlobalKey _stackKey = GlobalKey();
  late List<GlobalKey> _segmentKeys = _newKeys();

  /// Segment rects relative to the stack, measured after layout. Empty until the first measurement (and after the segment count changed).
  List<Rect> _rects = const [];

  /// The selection pill slides from [_from] to [_to] (equal while it rests). Null = no pill (no active segment or not measured yet).
  Rect? _from;
  Rect? _to;
  bool _measureScheduled = false;

  late final AnimationController _controller = AnimationController(vsync: this, duration: _slideDuration);
  late final CurvedAnimation _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  List<GlobalKey> _newKeys() => List.generate(widget.buttons.length, (_) => GlobalKey());

  static int? _activeIndexOf(List<GazeToggleButton> buttons) {
    final index = buttons.indexWhere((button) => button.active);
    return index < 0 ? null : index;
  }

  bool get _measured => _rects.isNotEmpty && _rects.length == widget.buttons.length;

  Rect? get _pillRect {
    final to = _to;
    if (to == null) return null;
    return Rect.lerp(_from ?? to, to, _controller.isAnimating ? _curve.value : 1);
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GazeToggleButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buttons.length != widget.buttons.length || oldWidget.axis != widget.axis) {
      // Different segments: forget the measurement, the pill reappears (without a slide) after the next one.
      _segmentKeys = _newKeys();
      _rects = const [];
      _from = _to = null;
      _controller.stop();
      return;
    }
    final oldIndex = _activeIndexOf(oldWidget.buttons);
    final newIndex = _activeIndexOf(widget.buttons);
    if (oldIndex == newIndex) return;
    if (newIndex == null) {
      _from = _to = null;
      _controller.stop();
    } else if (_measured && _to != null) {
      _from = _pillRect;
      _to = _rects[newIndex];
      _controller.forward(from: 0);
    } else {
      // Nothing was shown before: the pill appears at the new segment directly.
      _from = _to = _measured ? _rects[newIndex] : null;
    }
  }

  void _scheduleMeasure() {
    if (_measureScheduled) return;
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      if (mounted) _measure();
    });
  }

  void _measure() {
    final stack = _stackKey.currentContext?.findRenderObject();
    if (stack is! RenderBox || !stack.attached || !stack.hasSize) return;
    final rects = <Rect>[];
    for (final key in _segmentKeys) {
      final box = key.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.attached || !box.hasSize) return;
      rects.add(box.localToGlobal(Offset.zero, ancestor: stack) & box.size);
    }
    if (listEquals(rects, _rects)) return;
    setState(() {
      _rects = rects;
      final index = _activeIndexOf(widget.buttons);
      if (index == null || index >= rects.length) {
        _from = _to = null;
      } else if (_controller.isAnimating && _to != null) {
        _to = rects[index]; // Layout changed during the slide: keep sliding, towards the new target.
      } else {
        _from = _to = rects[index]; // First measurement or a resize: no slide.
      }
    });
  }

  /// Whether the pill sits under the center of the segment's [rect] (along the axis): its label then needs the on-pill foreground. A hard switch
  /// at the center, so a label never changes color more than once per slide.
  bool _underPill(Rect rect, Rect? pill) {
    if (pill == null) return false;
    final center = rect.center;
    return widget.axis == Axis.horizontal ? pill.left <= center.dx && center.dx <= pill.right : pill.top <= center.dy && center.dy <= pill.bottom;
  }

  /// White on a dark pill, a dark color on a bright one (same rule as the adaptive foreground of the fade animation).
  Color _onPillColor(BuildContext context, Color pill) {
    final scheme = Theme.of(context).colorScheme;
    final effective = pill.a < 1 ? Color.alphaBlend(pill, scheme.surface) : pill;
    if (ThemeData.estimateBrightnessForColor(effective) == Brightness.dark) return Colors.white;
    return ThemeData.estimateBrightnessForColor(scheme.onPrimary) == Brightness.dark ? scheme.onPrimary : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    _scheduleMeasure();
    final color = widget.color ?? Theme.of(context).primaryColor;
    const segmentRadius = BorderRadius.all(Radius.circular(GazeToggleButtons._segmentRadius));
    final activeIndex = _activeIndexOf(widget.buttons);
    // A disabled active segment dims the pill like GazeButton dims a disabled solid fill.
    final pillColor = activeIndex != null && widget.buttons[activeIndex].onTap == null ? color.withValues(alpha: 0.3) : color;
    final onPill = _onPillColor(context, pillColor);

    final content = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final pill = _pillRect;
        final buttons = <Widget>[
          for (var i = 0; i < widget.buttons.length; i++)
            _GazeToggleButton(
              key: _segmentKeys[i],
              button: widget.buttons[i],
              route: widget.route,
              color: color,
              onButtonColor: widget.buttons[i].onButtonColor,
              borderRadius: segmentRadius,
              // Before the first measurement the pill does not exist yet: the active segment paints its own fill so the first frame is already right.
              solidFill: widget.buttons[i].active && !_measured,
              foreground: _measured && _underPill(_rects[i], pill) ? onPill : null,
            ),
        ];
        return Stack(
          key: _stackKey,
          children: [
            if (pill != null)
              Positioned.fromRect(
                rect: pill,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: pillColor, borderRadius: segmentRadius),
                ),
              ),
            SizeChangedLayoutNotifier(
              // Stretch: all segments span the full cross extent, so the pill has the same thickness everywhere.
              child: Flex(
                mainAxisSize: MainAxisSize.min,
                direction: widget.axis,
                spacing: widget.borderWidth,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buttons,
              ),
            ),
          ],
        );
      },
    );
    return Container(
      padding: EdgeInsets.all(widget.borderWidth),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.all(Radius.circular(GazeToggleButtons._segmentRadius + widget.borderWidth))),
      child: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (_) {
          _scheduleMeasure();
          return false;
        },
        child: widget.axis == Axis.horizontal ? IntrinsicHeight(child: content) : IntrinsicWidth(child: content),
      ),
    );
  }
}

class _GazeToggleButton extends StatelessWidget {
  const _GazeToggleButton({
    super.key,
    required this.button,
    required this.route,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.color,
    this.onButtonColor,
    this.solidFill = false,
    this.foreground,
  });

  final GazeToggleButton button;
  final String route;
  final Color? color;
  final Color? onButtonColor;
  final BorderRadius borderRadius;

  /// The segment paints the active fill itself (only until the selection pill has been measured).
  final bool solidFill;

  /// Explicit content color while the selection pill is under this segment; null = adaptive to the segment's own (fading) background.
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final _buttonColor = color ?? Theme.of(context).primaryColor;
    final labelText = button.label.data;
    // The active fill is the selection pill behind the segments, so every segment is transparent. GazeButton dims every colour except exactly
    // Colors.transparent to alpha 0.3 without onTap; with onTap the alpha-0 colour keeps the dwell fade from passing through black.
    final inactiveColor = button.onTap == null ? Colors.transparent : _buttonColor.withValues(alpha: 0);
    return Flexible(
      child: GazeButton(
        onTap: button.onTap,
        color: solidFill ? _buttonColor : inactiveColor,
        properties: GazeButtonProperties(
          gazeSelectionAnimationType: GazeSelectionAnimationType.fade,
          animationColor: color ?? Theme.of(context).primaryColor,
          route: route,
          adaptiveForeground: true,
          gazeInteractive: button.active != true,
          direction: Axis.horizontal,
          borderRadius: borderRadius,
          innerPadding: const EdgeInsets.all(16),
          // Without a pill underneath no explicit colors: the adaptive foreground picks a readable one for the (fading) background. Inactive segments
          // stay visually secondary through the opacity, not through an alpha color.
          text: labelText == null || labelText.isEmpty
              ? null
              : Opacity(
                  opacity: button.active ? 1 : 0.7,
                  child: Text(
                    labelText,
                    overflow: button.label.overflow,
                    maxLines: button.label.maxLines,
                    softWrap: button.label.softWrap,
                    textAlign: button.label.textAlign,
                    style: foreground == null ? button.label.style : (button.label.style ?? const TextStyle()).copyWith(color: foreground),
                  ),
                ),
          icon: button.icon != null ? Icon(button.icon, color: foreground) : null,
          borderColor: Colors.transparent,
        ),
      ),
    );
  }
}
