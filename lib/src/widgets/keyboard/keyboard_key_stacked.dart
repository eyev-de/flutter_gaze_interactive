import 'package:flutter/material.dart';

import '../../core/constants.dart';
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
    // Scale the stacked defaults relative to the user-chosen key font size so
    // these keys grow/shrink in sync with the regular keys while keeping their
    // proportions (bottom character slightly larger).
    final scale = (textStyle?.fontSize ?? gazeInteractiveDefaultKeyboardFontSize) / gazeInteractiveDefaultKeyboardFontSize;
    final topTextStyle = TextStyle(fontSize: defaultFontSize * scale, color: textColor.background, fontWeight: FontWeight.bold);
    final bottomTextStyle = TextStyle(fontSize: (defaultFontSize + 3) * scale, color: textColor, fontWeight: FontWeight.bold);
    final shiftTextStyle = TextStyle(fontSize: defaultFontSize * scale, color: textColor, fontWeight: FontWeight.bold);
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
    // Scale the stacked defaults relative to the user-chosen key font size so
    // these keys grow/shrink in sync with the regular keys while keeping their
    // proportions (bottom character slightly larger).
    final scale = (textStyle?.fontSize ?? gazeInteractiveDefaultKeyboardFontSize) / gazeInteractiveDefaultKeyboardFontSize;
    final topTextStyle = TextStyle(fontSize: defaultFontSize * scale, color: textColor.background, fontWeight: FontWeight.bold);
    final bottomTextStyle = TextStyle(fontSize: (defaultFontSize + 3) * scale, color: textColor, fontWeight: FontWeight.bold);
    final shiftTextStyle = TextStyle(fontSize: defaultFontSize * scale, color: textColor, fontWeight: FontWeight.bold);
    return _KeyboardKeyStacked(
      shift: shift,
      topWidget: DefaultTextStyle.merge(style: topTextStyle, child: top),
      bottomWidget: DefaultTextStyle.merge(style: bottomTextStyle, child: bottom),
      shiftWidget: DefaultTextStyle.merge(style: shiftTextStyle, child: top),
    );
  }
}

class KeyboardKeyStackedIcon extends StatelessWidget {
  const KeyboardKeyStackedIcon({super.key, required this.icons, this.shift = false, this.size});

  final bool shift;
  final List<IconData> icons;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final top = icons.length >= 2 ? Icon(icons[1], size: size) : Container();
    return _KeyboardKeyStacked(shift: shift, topWidget: top, bottomWidget: Icon(icons.first, size: size), shiftWidget: top);
  }
}

class _KeyboardKeyStacked extends StatelessWidget {
  const _KeyboardKeyStacked({required this.topWidget, required this.bottomWidget, required this.shiftWidget, required this.shift});

  final Widget topWidget;
  final Widget bottomWidget;
  final Widget shiftWidget;
  final bool shift;

  @override
  Widget build(BuildContext context) {
    // Wrap the content in a scale-down FittedBox so the two stacked characters
    // always fit inside the key box. The auto font size is budgeted for two
    // lines (see GazeKeyboardKeySizing.optimalStackedFontSize), but the
    // FittedBox is the hard guarantee against overflow for any font size /
    // key dimensions (incl. user-configured sizes on small keys).
    if (shift) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: FittedBox(fit: BoxFit.scaleDown, child: shiftWidget),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [topWidget, const SizedBox(height: 4), bottomWidget],
          ),
        ),
      ),
    );
  }
}
