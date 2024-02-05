import 'dart:math';

import 'package:flutter/cupertino.dart';

class ScrollCalculator {
  ScrollCalculator({
    required this.controller,
    required this.scrollController,
    required this.textStyle,
    required this.textFieldGlobalKey,
    required this.textFieldPadding,
    this.isZoomed = true,
  });

  final TextEditingController controller;
  final ScrollController scrollController;
  final TextStyle textStyle;
  final GlobalKey textFieldGlobalKey;
  final EdgeInsets textFieldPadding;
  final bool isZoomed;

  double? calcScrollOffset() {
    // do not try to scroll if already at max scroll extent
    final double scrollOffset = scrollController.offset;

    double? textFieldWidth = textFieldGlobalKey.currentContext?.size?.width;
    double? textFieldHeight = textFieldGlobalKey.currentContext?.size?.height;
    if (textFieldWidth == null || textFieldHeight == null) return null;

    final int cursorOffset = controller.selection.baseOffset;
    // get number of line in which the cursor is currently located
    // for first char in new line we need to add one char (here 's') to calc
    final cursorSpan = TextSpan(text: controller.text.substring(0, min(cursorOffset.round(), controller.text.length)), style: textStyle);
    final cursorTp = TextPainter(text: cursorSpan, textDirection: TextDirection.ltr);
    // get total lines of text in text field
    final tp = TextPainter(text: TextSpan(text: controller.text, style: textStyle), textDirection: TextDirection.ltr);
    // 5 pixel puffer to scroll a little earlier
    final puffer = isZoomed ? 15 : 25;
    // calculate the space the text has in text field - padding
    textFieldWidth = textFieldWidth - (textFieldPadding.left + textFieldPadding.right) - puffer;
    textFieldHeight = textFieldHeight - (textFieldPadding.top + textFieldPadding.bottom);
    // Calculate number of lines to cursor with layout
    cursorTp.layout(maxWidth: textFieldWidth, minWidth: textFieldWidth);
    final lm = cursorTp.computeLineMetrics();
    final numLinesToCursor = lm.length;
    tp.layout(minWidth: textFieldWidth, maxWidth: textFieldWidth);
    final double lineHeight = tp.computeLineMetrics()[0].height;
    // how many lines are hidden because of scrollOffset
    final int linesBeforeView = (scrollOffset / lineHeight).ceil();
    // how many lines fit into text field view on any scroll positions
    final double linesInView = textFieldHeight / lineHeight;
    // Cursor in view do nothing
    if (numLinesToCursor > linesBeforeView && numLinesToCursor <= linesInView + linesBeforeView) return null;

    // scroll to cursor on the bottom of view
    final double ret = (numLinesToCursor * lineHeight) - textFieldHeight;
    if (ret > 0) {
      return ret;
    } else {
      return 0;
    }
  }
}
