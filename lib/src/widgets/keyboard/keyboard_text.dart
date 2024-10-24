//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../api.dart';
import '../../core/extensions.dart';

class GazeKeyboardTextWidget extends StatefulWidget {
  GazeKeyboardTextWidget({
    Key? key,
    required this.node,
    required this.state,
    required this.scrollController,
    this.onTap,
    this.maxLines = 10,
    this.minHeight = 100,
  }) : super(key: key);

  final FocusNode node;
  final GazeKeyboardState state;
  final void Function()? onTap;
  final int maxLines;
  final double minHeight;
  final ScrollController scrollController;

  @override
  State<GazeKeyboardTextWidget> createState() => _GazeKeyboardTextWidgetState();
}

class _GazeKeyboardTextWidgetState extends State<GazeKeyboardTextWidget> {
  final cupertinoTextFieldKey = GlobalKey();

  late ScrollCalculator scrollCalculator;

  @override
  void initState() {
    super.initState();
    widget.state.controller.addListener(_autoScroll);
    scrollCalculator = ScrollCalculator(
      controller: widget.state.controller,
      scrollController: widget.scrollController,
      textFieldGlobalKey: cupertinoTextFieldKey,
      textFieldPadding: const EdgeInsets.all(20),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontSize: 24,
        wordSpacing: 0,
        letterSpacing: 0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  @override
  void deactivate() {
    widget.state.controller.removeListener(_autoScroll);
    super.deactivate();
  }

  void _autoScroll() {
    // delay necessary since the listener is called multiple times
    Future.delayed(const Duration(milliseconds: 200), () {
      final textOffset = widget.state.controller.selection.baseOffset;
      if (textOffset <= 0) return;
      final offset = scrollCalculator.calcScrollOffset();
      if (offset != null) {
        widget.scrollController.animateTo(offset, duration: const Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GazeScrollable(
      indicatorSize: GazeScrollableIndicatorSize.small,
      route: widget.state.route,
      controller: widget.scrollController,
      child: GazeButton(
        onTap: widget.onTap,
        // Keyboard text field should be snapped to
        properties: GazeButtonProperties(route: widget.state.route, gazeInteractive: widget.onTap != null),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              constraints: BoxConstraints(minHeight: widget.minHeight),
              child: CupertinoTextField(
                key: cupertinoTextFieldKey,
                showCursor: true,
                autofocus: true,
                minLines: 1,
                undoController: widget.state.undoHistoryController,
                maxLines: widget.maxLines,
                style: scrollCalculator.textStyle,
                padding: scrollCalculator.textFieldPadding,
                focusNode: widget.node,
                scrollController: widget.scrollController,
                controller: widget.state.controller,
                placeholder: widget.state.placeholder,
                cursorColor: Colors.white,
                keyboardType: TextInputType.none,
                suffix: widget.state.type != KeyboardType.email ? SizedBox(height: widget.minHeight, width: 70) : null,
                decoration: BoxDecoration(
                  color: tealColor.disabled,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            if (widget.state.type != KeyboardType.email)
              Positioned.fill(
                child: _GazeKeyboardTextSuffix(state: widget.state, node: widget.node, height: widget.minHeight),
              ),
          ],
        ),
      ),
    );
  }
}

class _GazeKeyboardTextSuffix extends StatelessWidget {
  const _GazeKeyboardTextSuffix({required this.state, required this.node, this.height});

  final GazeKeyboardState state;
  final FocusNode node;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: MicrophoneButton(
        state: state,
        node: node,
        height: height,
        iconColor: Theme.of(context).primaryColor.onColor(disabled: false),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
      ),
    );
  }
}
