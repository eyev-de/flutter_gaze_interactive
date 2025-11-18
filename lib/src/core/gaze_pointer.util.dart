import 'constants.dart';

/// Utility class to for gaze pointer
class GazePointerUtil {
  /// Computes the inner factor for gaze pointer size
  /// to determine overlap area between pointer and interactive element.
  ///
  /// - [size]: The size of the gaze pointer
  /// Returns the computed factor between 0.3 and 0.6
  static double computeFactor({required double size}) {
    const minSize = gazeInteractiveMinPointerSize;
    const maxSize = gazeInteractiveMaxPointerSize;
    const minFactor = 0.3;
    const maxFactor = 0.6;
    final t = ((size - minSize) / (maxSize - minSize)).clamp(0.0, 1.0);
    return minFactor + (maxFactor - minFactor) * t;
  }
}
