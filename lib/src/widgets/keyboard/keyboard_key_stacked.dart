import 'package:flutter/material.dart';

import '../../core/extensions.dart';

class KeyboardKeyStackedString extends StatelessWidget {
  KeyboardKeyStackedString({super.key, required this.characters, required this.backgroundColor, this.shift = false, this.textStyle});

  final bool shift;
  final List<String> characters;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double defaultFontSize = 17;

  @override
  Widget build(BuildContext context) {
    final textColor = backgroundColor.onColor(disabled: false);
    final top = characters.length >= 2 ? characters[1] : '';
    final bottom = characters.first;
    final topTextStyle = (textStyle ?? TextStyle(fontSize: defaultFontSize)).copyWith(color: textColor.background, fontWeight: FontWeight.bold);
    final bottomTextStyle = (textStyle ?? TextStyle(fontSize: defaultFontSize + 3)).copyWith(color: textColor, fontWeight: FontWeight.bold);
    final shiftTextStyle = (textStyle ?? TextStyle(fontSize: defaultFontSize)).copyWith(color: textColor, fontWeight: FontWeight.bold);
    return _KeyboardKeyStacked(
      shift: shift,
      topWidget: DefaultTextStyle.merge(style: topTextStyle, child: Text(top)),
      bottomWidget: DefaultTextStyle.merge(style: bottomTextStyle, child: Text(bottom)),
      shiftWidget: DefaultTextStyle.merge(style: shiftTextStyle, child: Text(top)),
    );
  }
}

class KeyboardKeyStackedText extends StatelessWidget {
  KeyboardKeyStackedText({super.key, required this.backgroundColor, required this.texts, this.shift = false, this.textStyle});

  final bool shift;
  final List<Text> texts;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final double defaultFontSize = 18;

  @override
  Widget build(BuildContext context) {
    final textColor = backgroundColor.onColor(disabled: false);
    final top = texts.length >= 2 ? texts[1] : Container();
    final bottom = texts.first;
    final topTextStyle = (textStyle ?? TextStyle(fontSize: defaultFontSize)).copyWith(color: textColor.background, fontWeight: FontWeight.bold);
    final bottomTextStyle = (textStyle ?? TextStyle(fontSize: defaultFontSize + 3)).copyWith(color: textColor, fontWeight: FontWeight.bold);
    final shiftTextStyle = (textStyle ?? TextStyle(fontSize: defaultFontSize)).copyWith(color: textColor, fontWeight: FontWeight.bold);
    return _KeyboardKeyStacked(
      shift: shift,
      topWidget: DefaultTextStyle.merge(style: topTextStyle, child: top),
      bottomWidget: DefaultTextStyle.merge(style: bottomTextStyle, child: bottom),
      shiftWidget: DefaultTextStyle.merge(style: shiftTextStyle, child: top),
    );
  }
}

class KeyboardKeyStackedIcon extends StatelessWidget {
  const KeyboardKeyStackedIcon({super.key, required this.icons, this.shift = false});

  final bool shift;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final top = icons.length >= 2 ? Icon(icons[1]) : Container();
    return _KeyboardKeyStacked(
      shift: shift,
      topWidget: top,
      bottomWidget: Icon(icons.first),
      shiftWidget: top,
    );
  }
}

class _KeyboardKeyStacked extends StatelessWidget {
  const _KeyboardKeyStacked({
    required this.topWidget,
    required this.bottomWidget,
    required this.shiftWidget,
    required this.shift,
  });

  final Widget topWidget;
  final Widget bottomWidget;
  final Widget shiftWidget;
  final bool shift;

  @override
  Widget build(BuildContext context) {
    if (shift) return Center(child: shiftWidget);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            topWidget,
            const Spacer(),
            bottomWidget,
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
