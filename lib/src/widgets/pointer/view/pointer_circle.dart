import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import '../../../../api.dart';
import 'pointer_view.provider.dart';

class PointerCircle extends ConsumerWidget {
  const PointerCircle({super.key, required this.type, required this.size, required this.animation});

  final GazePointerType type;
  final double size;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(pointerColorProvider(type: type));
    if (type == GazePointerType.active) {
      const _dotSize = 5.0;
      final _lighterColor = Color.alphaBlend(color.withOpacity(0.6), Colors.white);
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              child: SizedBox.square(
                dimension: size,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_lighterColor),
                    strokeWidth: 10,
                    value: animation.value,
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: size / 2 - _dotSize / 2,
              left: size / 2 - _dotSize / 2,
              child: Container(
                alignment: Alignment.center,
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(color: _lighterColor, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      );
    }
    final snapState = ref.watch(snappingStateProvider);
    // GazePointerType.passive
    if (snapState == SnapState.inSnapTimer) {
      return ShakeWidget(
        duration: Duration(milliseconds: ref.read(GazeInteractive().snappingTimerMilliseconds)),
        shakeConstant: ShakeDefaultConstant1(),
        autoPlay: true,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: kDebugMode
              ? Center(
                  child: Text(snapState.icon, style: const TextStyle(fontSize: 30)),
                )
              : null,
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: kDebugMode || ref.watch(snapIconStateProvider)
            ? Center(
                child: Text(snapState.icon, style: const TextStyle(fontSize: 30)),
              )
            : null,
      );
    }
  }
}
