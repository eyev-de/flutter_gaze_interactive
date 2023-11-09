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

class GazeKeyboardTextWidget extends StatelessWidget {
  GazeKeyboardTextWidget({
    Key? key,
    required this.state,
    required this.node,
    this.bigFont = false,
    this.minHeight = 100,
    this.maxLines = 10,
    this.onTap,
  }) : super(key: key) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => node.requestFocus());
  }

  final GazeKeyboardState state;
  final FocusNode node;
  final controller = ScrollController();
  final double minHeight;
  final bool bigFont;

  final int maxLines;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GazeScrollable(
      indicatorHeight: 40,
      indicatorWidth: 40,
      indicatorInnerPadding: const EdgeInsets.all(5),
      route: state.route,
      controller: controller,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GazeButton(
          properties: GazeButtonProperties(
            child: Container(
              constraints: BoxConstraints(minHeight: minHeight),
              child: CupertinoTextField(
                controller: state.controller,
                placeholder: state.placeholder,
                focusNode: node,
                style: bigFont ? Theme.of(context).textTheme.headlineSmall : Theme.of(context).textTheme.bodyLarge,
                enabled: true,
                cursorColor: Colors.white,
                showCursor: true,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                minLines: 1,
                maxLines: maxLines,
                keyboardType: TextInputType.none,
                padding: const EdgeInsets.all(20),
                scrollController: controller,
              ),
            ),
            gazeInteractive: onTap != null,
            // Keyboard Textfield should be snapped to
            snappable: true,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
