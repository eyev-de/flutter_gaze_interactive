//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//
import 'package:flutter/material.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    try {
      final renderObject = currentContext?.findRenderObject() as RenderBox?;
      final translation = renderObject?.getTransformTo(null).getTranslation();
      if (translation != null && renderObject != null && renderObject.hasSize && currentState != null && currentState!.mounted) {
        return renderObject.paintBounds.shift(Offset(translation.x, translation.y));
      }
    } finally {}
    return null;
  }
}
