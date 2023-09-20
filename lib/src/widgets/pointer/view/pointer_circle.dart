import 'package:flutter/material.dart';

import '../../../../api.dart';

class PointerCircle extends StatelessWidget {
  const PointerCircle({super.key, required this.type, required this.size, required this.animation});

  final GazePointerType type;
  final double size;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    if (type == GazePointerType.active) {
      const _dotSize = 5.0;
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Positioned(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) => CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent.shade100),
                  strokeWidth: 10,
                  value: animation.value,
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
                decoration: BoxDecoration(color: Colors.redAccent.shade100, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      );
    }

    // GazePointerType.passive
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
      ),
    );
  }
}
