//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../api.dart';

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
    if (media == null) return offset;
    // Clamp ensures that the value is not smaller than 0 and not larger than (screen width - pointer size).
    final clampedX = offset.dx.clamp(0.0, media.size.width - size);
    final clampedY = offset.dy.clamp(0.0, media.size.height - size);
    return Offset(clampedX, clampedY);
  }
}

extension TextEditingControllerExtension on TextEditingController {
  void insert(String value, KeyboardType type, List<TextInputFormatter> inputFormatters) {
    final currentText = text;
    final sel = selection;

    // Setting `text` resets the selection to offset -1. Doing so as a separate
    // statement from updating the selection left the controller briefly in an
    // invalid state and fired two change notifications per keystroke; under
    // rapid input the next keypress could run while the selection was still -1,
    // making `substring(0, -1)` throw and silently dropping the character.
    //
    // Resolve a safe caret first: when there is no valid selection (offset -1,
    // e.g. right after the text was set programmatically) treat the caret as
    // the end of the text so we append instead of throwing.
    final bool collapsed = !sel.isValid || sel.isCollapsed;
    final int caret = sel.isValid
        ? (sel.base.affinity == TextAffinity.downstream ? sel.baseOffset : sel.extentOffset).clamp(0, currentText.length)
        : currentText.length;
    final int rangeEnd = sel.isValid
        ? (sel.base.affinity == TextAffinity.upstream ? sel.baseOffset : sel.extentOffset).clamp(0, currentText.length)
        : currentText.length;

    String newText;
    int caretAfter;
    if (currentText.isEmpty) {
      newText = value;
      caretAfter = value.length;
    } else if (collapsed) {
      String before = currentText.substring(0, caret);
      String after = currentText.substring(caret, currentText.length);
      // Trim if . ! ? is inserted
      if (value == '.' || value == '!' || value == '?') {
        before = before.trim();
        if (type != KeyboardType.email) {
          after = ' $after';
        }
      }
      newText = before + value + after;
      caretAfter = before.length + value.length;
    } else {
      final start = (caret == rangeEnd ? caret - 1 : caret).clamp(0, currentText.length);
      newText = currentText.replaceRange(start, rangeEnd, value);
      caretAfter = start + value.length;
    }

    if (inputFormatters.isNotEmpty) {
      newText = inputFormatters.fold(newText, (v, formatter) => formatter.formatEditUpdate(TextEditingValue(text: v), TextEditingValue(text: v)).text);
    }

    // Single atomic update: one notification, one rebuild, and never a transient
    // selection == -1 between setting the text and the selection.
    this.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: min(caretAfter, newText.length)),
    );
  }

  /// Deletes the highlighted range, or the single character before the caret
  /// when the selection is collapsed. Mirrors a hardware Backspace key.
  void backspace(List<TextInputFormatter> inputFormatters) {
    final currentText = text;
    if (currentText.isEmpty) return;
    final sel = selection;

    final int start;
    final int end;
    if (sel.isValid && !sel.isCollapsed) {
      // Delete the highlighted range.
      start = sel.start;
      end = sel.end;
    } else {
      // Collapsed (or no) selection: delete the char before the caret. When the
      // selection is invalid (-1) treat the caret as the end of the text.
      final caret = sel.isValid ? sel.baseOffset.clamp(0, currentText.length) : currentText.length;
      if (caret <= 0) return;
      start = caret - 1;
      end = caret;
    }

    var newText = currentText.replaceRange(start, end, '');
    if (inputFormatters.isNotEmpty) {
      newText = inputFormatters.fold(newText, (v, formatter) => formatter.formatEditUpdate(TextEditingValue(text: v), TextEditingValue(text: v)).text);
    }
    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: min(start, newText.length)),
    );
  }

  Future<void> paste(List<TextInputFormatter> inputFormatters, {bool selecting = false}) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain) ?? const ClipboardData(text: '');
    String pasteText = data.text ?? '';
    if (inputFormatters.isNotEmpty) {
      pasteText = inputFormatters.fold(
        text,
        (value, formatter) => formatter.formatEditUpdate(TextEditingValue(text: value), TextEditingValue(text: value)).text,
      );
    }
    if (selecting) {
      final start = selection.start;
      text = text.replaceRange(start, selection.end, pasteText);
      selection = TextSelection.fromPosition(TextPosition(offset: start + pasteText.length));
    } else {
      final cursorPosition = selection.baseOffset;
      text = text.replaceRange(cursorPosition, cursorPosition, pasteText);
      selection = TextSelection.fromPosition(TextPosition(offset: cursorPosition + pasteText.length));
    }
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
      selection: TextSelection(baseOffset: baseOffset, extentOffset: extentOffset),
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
      selection: TextSelection(baseOffset: baseOffset, extentOffset: extentOffset),
    );
  }

  void moveCursorMostRight() {
    int baseOffset = selection.baseOffset;
    int extentOffset = selection.extentOffset;
    baseOffset = extentOffset = text.length;
    value = TextEditingValue(
      text: text,
      selection: TextSelection(baseOffset: baseOffset, extentOffset: extentOffset),
    );
  }
}

extension ColorExtension on Color {
  String get hex {
    final hexString = value.toRadixString(16);
    return hexString.substring(2, hexString.length);
  }

  Color blendWith({required Color background}) => Color.alphaBlend(this, background);

  Color onColor({Color? backgroundColor, required bool disabled}) {
    final color = blendWith(background: backgroundColor ?? surfaceColor);
    final dark = color == tealColor ? surfaceColor : Colors.black;
    if (disabled) {
      return textDisabledColor;
    } else {
      return color.computeLuminance() > 0.5 ? dark : Colors.white;
    }
  }

  Color get background => withValues(alpha: 0.5);

  Color get disabled => withValues(alpha: 0.4);
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

extension IterableExt<T> on Iterable<T> {
  Iterable<T> superJoin(T separator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];
    final _l = [iterator.current];
    while (iterator.moveNext()) {
      _l
        ..add(separator)
        ..add(iterator.current);
    }
    return _l;
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension LocaleNameExtension on LocaleName {
  bool get equalsSystemLocale => localeId == Platform.localeName.replaceAll('_', '-');

  String get language {
    final match = RegExp(r'^\S+').firstMatch(name);
    if (match == null) return '';
    return match.group(0) ?? '';
  }
}

extension ListLocaleNameExtension on List<LocaleName> {
  LocaleName? get systemLocaleName => firstWhereOrNull((locale) => locale.equalsSystemLocale);
}
