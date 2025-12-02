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
        if (type != KeyboardType.email) {
          after = ' $after';
        }
      }
      text = before + value + after;
    } else {
      startIndex = selection.baseOffset == selection.extentOffset ? startIndex - 1 : startIndex;
      text = text.replaceRange(startIndex, endIndex, value);
    }
    if (startIndex.isNegative) startIndex = 0;
    if (inputFormatters.isNotEmpty) {
      text = inputFormatters.fold(text, (value, formatter) => formatter.formatEditUpdate(TextEditingValue(text: value), TextEditingValue(text: value)).text);
    }
    selection = TextSelection.fromPosition(TextPosition(offset: min(startIndex + 1, text.length)));
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
