//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

class TextPartStyleDefinition {
  final String part;
  final TextStyle style;
  TextPartStyleDefinition({
    required this.part,
    required this.style,
  });
}

class TextPartStyleDefinitions {
  final List<TextPartStyleDefinition> definitionList;
  TextPartStyleDefinitions({required this.definitionList});
}

class StyleableTextFieldController extends TextEditingController {
  StyleableTextFieldController({
    List<TextPartStyleDefinition>? initialTextPartStyles,
  }) : _textPartStyles = initialTextPartStyles ?? [];
  List<TextPartStyleDefinition> _textPartStyles;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_textPartStyles.isNotEmpty) {
      final List<InlineSpan> textSpanChildren = <InlineSpan>[];
      for (final textPartStyle in _textPartStyles) {
        _addTextSpan(textSpanChildren, textPartStyle.part, textPartStyle.style);
      }
      return TextSpan(style: style, children: textSpanChildren);
    } else {
      assert(!value.composing.isValid || !withComposing || value.isComposingRangeValid);
      if (!value.isComposingRangeValid || !withComposing) {
        return TextSpan(style: style, text: text);
      }
      final TextStyle composingStyle =
          style?.merge(const TextStyle(decoration: TextDecoration.underline)) ?? const TextStyle(decoration: TextDecoration.underline);
      return TextSpan(
        style: style,
        children: <TextSpan>[
          TextSpan(text: value.composing.textBefore(value.text)),
          TextSpan(
            style: composingStyle,
            text: value.composing.textInside(value.text),
          ),
          TextSpan(text: value.composing.textAfter(value.text)),
        ],
      );
    }
  }

  void updateStyles(
    List<TextPartStyleDefinition> newTextPartStyles,
  ) {
    _textPartStyles = newTextPartStyles;
    notifyListeners();
  }

  void _addTextSpan(
    List<InlineSpan> textSpanChildren,
    String textToBeStyled,
    TextStyle style,
  ) {
    textSpanChildren.add(
      TextSpan(
        text: textToBeStyled,
        style: style,
      ),
    );
  }
}
