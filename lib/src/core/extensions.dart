//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
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
