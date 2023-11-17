//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'scrollable_impl.dart';

class GazeScrollable extends StatelessWidget {
  GazeScrollable({
    Key? key,
    required this.route,
    required this.child,
    required this.controller,
    this.indicatorWidth = 300,
    this.indicatorHeight = 60,
    this.indicatorInnerPadding = const EdgeInsets.all(10),
  }) : super(key: key);

  final String route;
  final Widget child;
  final ScrollController controller;
  final double indicatorWidth;
  final double indicatorHeight;
  final EdgeInsets indicatorInnerPadding;

  final GlobalKey gazeInteractiveKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GazeScrollableImpl(
      route: route,
      controller: controller,
      wrappedKey: gazeInteractiveKey,
      indicatorWidth: indicatorWidth,
      indicatorHeight: indicatorHeight,
      indicatorInnerPadding: indicatorInnerPadding,
      child: child,
    );
  }
}
