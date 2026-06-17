//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Reports the global paint bounds of [child] whenever it paints — i.e. only
/// when its geometry can actually have changed, not on a timer and not on every
/// gaze sample. Flutter marks a box as needing paint at the end of every
/// layout, so painting is a superset of "geometry changed": resize, scroll and
/// ancestor-driven repositioning all funnel through paint.
///
/// This is used to keep `GazeElementData.cachedBounds` fresh so the gaze
/// hit-test loop can read a cached [Rect] instead of walking the render tree
/// (`getTransformTo`) for every registered element on every frame. A keyboard
/// sitting still does zero measuring; only elements that relayout or repaint
/// (scroll, resize, ancestor animations) recompute their bounds.
class GazeBoundsReporter extends SingleChildRenderObjectWidget {
  const GazeBoundsReporter({
    super.key,
    required this.onBounds,
    required Widget super.child,
  });

  /// Called with the current global bounds whenever they change.
  final ValueChanged<Rect?> onBounds;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderGazeBoundsReporter(onBounds);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderGazeBoundsReporter renderObject,
  ) {
    renderObject.onBounds = onBounds;
  }
}

class _RenderGazeBoundsReporter extends RenderProxyBox {
  _RenderGazeBoundsReporter(this.onBounds);

  ValueChanged<Rect?> onBounds;
  Rect? _lastReported;

  void _report() {
    if (!attached || !hasSize) return;
    final rect = localToGlobal(Offset.zero) & size;
    if (rect != _lastReported) {
      _lastReported = rect;
      onBounds(rect);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Reporting happens only here, never in performLayout: localToGlobal walks
    // up the ancestor chain reading each ancestor's size/transform, and during
    // our own layout those ancestors (e.g. the keyboard's SlideTransition /
    // RenderFractionalTranslation) have not been sized yet — reading their size
    // then throws "RenderBox was not laid out" / "size accessed beyond scope".
    // paint runs only after the whole layout phase completes, so every ancestor
    // transform is final. Because layout always schedules a repaint, this also
    // catches resize, scroll and ancestor-animation repositioning.
    _report();
    super.paint(context, offset);
  }
}
