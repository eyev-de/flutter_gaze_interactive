import 'package:flutter/material.dart';

class KeyboardKeyStackedString extends StatelessWidget {
  const KeyboardKeyStackedString({super.key, required this.characters, this.shift = false, this.textStyle = const TextStyle(fontSize: 20)});

  final bool shift;
  final List<String> characters;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final top = characters.length >= 2 ? characters[1] : '';
    final bottom = characters.first;
    return _KeyboardKeyStacked(
      shift: shift,
      topWidget: DefaultTextStyle.merge(style: textStyle.copyWith(color: Colors.grey, fontSize: 19), child: Text(top)),
      bottomWidget: DefaultTextStyle.merge(style: textStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold), child: Text(bottom)),
      shiftWidget: DefaultTextStyle.merge(style: textStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold), child: Text(top)),
    );
  }
}

class KeyboardKeyStackedText extends StatelessWidget {
  const KeyboardKeyStackedText({super.key, required this.texts, this.shift = false, this.textStyle = const TextStyle(fontSize: 20)});

  final bool shift;
  final List<Text> texts;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final top = texts.length >= 2 ? texts[1] : Container();
    final bottom = texts.first;
    return _KeyboardKeyStacked(
      shift: shift,
      topWidget: DefaultTextStyle.merge(style: textStyle.copyWith(color: Colors.grey), child: top),
      bottomWidget: DefaultTextStyle.merge(style: textStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold), child: bottom),
      shiftWidget: DefaultTextStyle.merge(style: textStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold), child: top),
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
