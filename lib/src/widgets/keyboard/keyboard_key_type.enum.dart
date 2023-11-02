import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum GazeKeyType {
  none,
  ctrl,
  alt,
  win,
  shift,
  caps,
  enter,
  del,
  tab,
  close,
  signs;

  Color defaultColor(Color primaryColor, Color customColor) {
    return switch (this) {
      GazeKeyType.caps => Colors.grey.shade800,
      GazeKeyType.shift => Colors.grey.shade800,
      GazeKeyType.enter => Colors.grey.shade800,
      GazeKeyType.tab => Colors.grey.shade800,
      GazeKeyType.signs => Colors.grey.shade800,
      GazeKeyType.close => primaryColor,
      _ => customColor,
    };
  }
}
