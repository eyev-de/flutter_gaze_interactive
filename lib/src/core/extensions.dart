//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

extension GazePointerValidationExtension on BuildContext {
  Offset validateGazePointer({required Offset offset, required double size}) {
    final media = MediaQuery.maybeOf(this);
    if (media != null && offset.dx + size > media.size.width) return Offset(media.size.width - size, offset.dy);
    if (media != null && offset.dy + size > media.size.height) return Offset(offset.dx, media.size.height - size);
    if (offset.dx < 0) return Offset(0, offset.dy);
    if (offset.dy < 0) return Offset(offset.dx, 0);
    return offset;
  }
}

extension TextEditingControllerExtension on TextEditingController {
  void insert(String value) {
    var startIndex = selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
    final endIndex = selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;

    if (text.isEmpty) {
      text = value;
    } else if (selection.isCollapsed) {
      String before = text.substring(0, selection.baseOffset);
      String after = text.substring(selection.baseOffset, text.length);
      // Trim if . ! ? is inserted
      if (value == '.' || value == '!' || value == '?') {
        before = before.trim();
        after = ' $after';
      }
      text = before + value + after;
    } else {
      startIndex = selection.baseOffset == selection.extentOffset ? startIndex - 1 : startIndex;
      text = text.replaceRange(startIndex, endIndex, value);
    }
    if (startIndex.isNegative) startIndex = 0;
    selection = TextSelection.fromPosition(TextPosition(offset: min(startIndex + 1, text.length)));
  }

  Future<void> paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain) ?? const ClipboardData(text: '');
    final pasteText = data.text ?? '';
    var startIndex = selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
    var endIndex = selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;
    startIndex = selection.baseOffset == selection.extentOffset ? startIndex : startIndex;
    if (startIndex.isNegative) startIndex = 0;
    if (endIndex.isNegative) endIndex = 0;
    text = text.replaceRange(startIndex, endIndex, pasteText);
    endIndex = endIndex > 0
        ? endIndex + pasteText.length <= text.length
            ? endIndex + pasteText.length
            : text.length
        : text.length;
    selection = TextSelection.fromPosition(TextPosition(offset: endIndex));
  }

  void cut() {
    String cutText = text;
    if (!selection.isCollapsed) {
      var startIndex = selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
      final endIndex = selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;
      startIndex = selection.baseOffset == selection.extentOffset ? startIndex - 1 : startIndex;
      if (startIndex.isNegative) startIndex = 0;
      cutText = text.substring(startIndex, endIndex);
      text = text.replaceRange(startIndex, endIndex, '');
      selection = TextSelection.fromPosition(TextPosition(offset: startIndex));
    } else {
      text = '';
    }
    Clipboard.setData(ClipboardData(text: cutText));
  }

  void copy() {
    String copyText = text;
    if (!selection.isCollapsed) {
      var startIndex = selection.base.affinity == TextAffinity.downstream ? selection.baseOffset : selection.extentOffset;
      final endIndex = selection.base.affinity == TextAffinity.upstream ? selection.baseOffset : selection.extentOffset;
      startIndex = selection.baseOffset == selection.extentOffset ? startIndex - 1 : startIndex;
      if (startIndex.isNegative) startIndex = 0;
      copyText = text.substring(startIndex, endIndex);
    }
    Clipboard.setData(ClipboardData(text: copyText));
  }

  void moveCursorLeft({bool selecting = false}) {
    int baseOffset = selection.baseOffset;
    int extentOffset = selection.extentOffset;
    if (selecting) {
      extentOffset = selection.extentOffset + 1 > text.length ? text.length : selection.extentOffset + 1;
    } else {
      baseOffset = extentOffset = selection.extentOffset + 1 > text.length ? text.length : selection.extentOffset + 1;
    }
    value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      ),
    );
  }

  void moveCursorRight({bool selecting = false}) {
    int baseOffset = selection.baseOffset;
    int extentOffset = selection.extentOffset;
    if (selecting) {
      baseOffset = selection.baseOffset - 1 < 0 ? 0 : selection.baseOffset - 1;
    } else {
      baseOffset = extentOffset = selection.baseOffset - 1 < 0 ? 0 : selection.baseOffset - 1;
    }
    value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      ),
    );
  }

  void moveCursorMostRight() {
    int baseOffset = selection.baseOffset;
    int extentOffset = selection.extentOffset;
    baseOffset = extentOffset = text.length;
    value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      ),
    );
  }
}

extension ColorExtension on Color {
  String get hex {
    final hexString = value.toRadixString(16);
    return hexString.substring(2, hexString.length);
  }
}

extension StringExtension on String {
  Color get color {
    final hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
