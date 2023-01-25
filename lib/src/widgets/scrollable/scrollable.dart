//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'scrollable_impl.dart';

class GazeScrollable extends StatelessWidget {
  final GlobalKey gazeInteractiveKey = GlobalKey();
  final Widget child;
  final ScrollController controller;
  final String route;
  final double indicatorWidth;
  final double indicatorHeight;
  final EdgeInsets indicatorInnerPadding;
  GazeScrollable({
    Key? key,
    required this.child,
    required this.controller,
    required this.route,
    this.indicatorWidth = 300,
    this.indicatorHeight = 60,
    this.indicatorInnerPadding = const EdgeInsets.all(10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GazeScrollableImpl(
      controller: controller,
      wrappedKey: gazeInteractiveKey,
      route: route,
      indicatorWidth: indicatorWidth,
      indicatorHeight: indicatorHeight,
      indicatorInnerPadding: indicatorInnerPadding,
      child: child,
    );
  }
}
