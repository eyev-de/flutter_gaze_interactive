//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../button/button.dart';
import '../scrollable/scrollable.dart';
import 'keyboard_state.dart';
import 'scroll_calculator.dart';

class GazeKeyboardTextWidget extends StatefulWidget {
  GazeKeyboardTextWidget({
    Key? key,
    required this.node,
    required this.state,
    this.onTap,
    this.maxLines = 10,
    this.minHeight = 100,
  }) : super(key: key) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => node.requestFocus());
  }

  final FocusNode node;
  final GazeKeyboardState state;
  final void Function()? onTap;
  final int maxLines;
  final double minHeight;

  @override
  State<GazeKeyboardTextWidget> createState() => _GazeKeyboardTextWidgetState();
}

class _GazeKeyboardTextWidgetState extends State<GazeKeyboardTextWidget> {
  final controller = ScrollController();
  final cupertinoTextFieldKey = GlobalKey();

  late ScrollCalculator scrollCalculator;

  @override
  void initState() {
    super.initState();
    widget.state.controller.addListener(_autoScroll);
    scrollCalculator = ScrollCalculator(
      controller: widget.state.controller,
      scrollController: controller,
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
    final textOffset = widget.state.controller.selection.baseOffset;
    if (textOffset <= 0) return;
    final offset = scrollCalculator.calcScrollOffset();
    if (offset == null) return;
    controller.animateTo(offset, duration: const Duration(milliseconds: 60), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return GazeScrollable(
      indicatorHeight: 40,
      indicatorWidth: 40,
      indicatorInnerPadding: const EdgeInsets.all(5),
      route: widget.state.route,
      controller: controller,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GazeButton(
          onTap: widget.onTap,
          properties: GazeButtonProperties(
            gazeInteractive: widget.onTap != null,
            // Keyboard Text field should be snapped to
            snappable: true,
            child: Container(
              constraints: BoxConstraints(minHeight: widget.minHeight),
              child: CupertinoTextField(
                key: cupertinoTextFieldKey,
                enabled: true,
                showCursor: true,
                minLines: 1,
                maxLines: widget.maxLines,
                style: scrollCalculator.textStyle,
                padding: scrollCalculator.textFieldPadding,
                focusNode: widget.node,
                scrollController: controller,
                controller: widget.state.controller,
                placeholder: widget.state.placeholder,
                cursorColor: Colors.white,
                keyboardType: TextInputType.none,
                decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: const BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
