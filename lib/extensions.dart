//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

extension ThemeDataExtension on ThemeData {
  EdgeInsets get switchButtonPadding => !kIsWeb
      ? (Platform.isMacOS || Platform.isWindows || Platform.isLinux)
          ? const EdgeInsets.fromLTRB(15, 35, 15, 35)
          : const EdgeInsets.fromLTRB(15, 35, 15, 35)
      : const EdgeInsets.fromLTRB(15, 35, 15, 35);
  EdgeInsets get segmentedPadding => !kIsWeb
      ? (Platform.isMacOS || Platform.isWindows || Platform.isLinux)
          ? const EdgeInsets.fromLTRB(30, 30, 30, 30)
          : const EdgeInsets.fromLTRB(20, 10, 20, 10)
      : const EdgeInsets.fromLTRB(30, 30, 30, 30);
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject != null) {
      return renderObject.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}
