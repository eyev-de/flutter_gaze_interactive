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

  Color defaultColor({required Color customColor, required Color fallbackColor}) {
    return switch (this) {
      GazeKeyType.caps => customColor,
      GazeKeyType.shift => customColor,
      GazeKeyType.enter => customColor,
      GazeKeyType.tab => customColor,
      GazeKeyType.signs => customColor,
      GazeKeyType.close => customColor,
      _ => fallbackColor,
    };
  }
}
