import 'package:flutter/material.dart';

/// A class that represents a shape that can be interacted with using gaze.
class GazeShape {
  const GazeShape({
    required this.rect,
    this.borderRadius = BorderRadius.zero,
  });

  /// The rectangular area of the shape.
  final Rect rect;

  /// The border radius of the shape.
  final BorderRadius borderRadius;

  /// Returns true if the shape is a circle.
  bool get isCircle {
    if (rect.width != rect.height) return false;
    if (toRRect.isCircle) return true;
    final radius = rect.width / 2;
    if (borderRadius.isUniformWithValue(value: radius)) return true;
    if (borderRadius.topLeft.x >= radius && borderRadius.topRight.x >= radius && borderRadius.bottomLeft.x >= radius && borderRadius.bottomRight.x >= radius) {
      return true;
    }
    return false;
  }

  /// Returns true if the shape is a uniformly rounded rectangle.
  bool get isUniformRoundedRect => borderRadius.isUniformWithValue() && !isCircle;

  /// Returns true if the shape is a non-uniformly rounded rectangle.
  /// For example a rectangle only rounded at the top corners.
  // bool get isRoundedRect => !borderRadius.isUniformWithValue() && !isCircle;

  /// Returns true if the shape is a rectangle (no rounded corners).
  bool get isRect => toRRect.isRect;

  /// Converts the shape to a RRect.
  RRect get toRRect => RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );

  /// Checks if this shape overlaps with the given [gazePointer].
  bool overlaps(GazeShape gazePointer, {double factor = 0.1}) {
    // Scale the gazePointer if it's a circle
    final gazeScaled = gazePointer.isCircle
        // Scale the gazePointer by the given factor
        ? GazeShape(
            rect: Rect.fromCenter(center: gazePointer.rect.center, width: gazePointer.rect.width * factor, height: gazePointer.rect.height * factor),
            borderRadius: gazePointer.borderRadius,
          )
        : gazePointer;
    // Fast Intersection for Rectangles
    if (isRect) return toRRect.outerRect.overlaps(gazeScaled.toRRect.outerRect);
    // Precise Intersection for Rectangles with custom BorderRadius
    return _intersect(toRRect, gazeScaled.toRRect);
  }

  /// Precise Intersection for RRects
  bool _intersect(RRect a, RRect b) {
    final pathA = Path()..addRRect(a);
    final pathB = Path()..addRRect(b);
    final intersection = Path.combine(PathOperation.intersect, pathA, pathB);
    // If the intersection path is not empty, the RRects intersect
    return intersection.computeMetrics().isNotEmpty;
  }
}

/// Extension methods for BorderRadius
extension on BorderRadius {
  /// Checks if all corners of the border radius are equal to the given value.
  bool isUniformWithValue({double value = 0}) {
    return topLeft.x == value &&
        topLeft.y == value &&
        topRight.x == value &&
        topRight.y == value &&
        bottomLeft.x == value &&
        bottomLeft.y == value &&
        bottomRight.x == value &&
        bottomRight.y == value;
  }
}
