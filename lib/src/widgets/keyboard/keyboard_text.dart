//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../scrollable/scrollable.dart';
import 'state.dart';

class GazeKeyboardTextWidget extends StatelessWidget {
  final GazeKeyboardState state;
  final FocusNode node;
  final controller = ScrollController();
  final double minHeight;
  final int maxLines;

  GazeKeyboardTextWidget({
    Key? key,
    required this.state,
    required this.node,
    this.minHeight = 100,
    this.maxLines = 10,
  }) : super(key: key) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      node.requestFocus();
    });
  }

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
        child: Container(
          constraints: BoxConstraints(minHeight: minHeight),
          child: CupertinoTextField(
            controller: state.controller,
            placeholder: state.placeholder,
            focusNode: node,
            style: Theme.of(context).textTheme.titleLarge,
            enabled: true,
            cursorColor: Colors.white,
            showCursor: true,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
            ),
            minLines: 1,
            maxLines: maxLines,
            keyboardType: TextInputType.none,
            padding: const EdgeInsets.all(20),
            scrollController: controller,
          ),
        ),
      ),
    );
  }
}
