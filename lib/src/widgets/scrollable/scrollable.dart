//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'scrollable_impl.dart';

enum GazeScrollableIndicatorSize {
  small,
  medium,
  large;

  Size get size {
    return switch (this) {
      GazeScrollableIndicatorSize.small => const Size(40, 32),
      GazeScrollableIndicatorSize.medium => const Size(50, 45),
      GazeScrollableIndicatorSize.large => const Size(200, 60),
    };
  }

  EdgeInsets get padding {
    return switch (this) {
      GazeScrollableIndicatorSize.small => const EdgeInsets.all(3),
      GazeScrollableIndicatorSize.medium => const EdgeInsets.all(5),
      GazeScrollableIndicatorSize.large => const EdgeInsets.all(10),
    };
  }
}

class GazeScrollable extends StatelessWidget {
  GazeScrollable({
    Key? key,
    required this.route,
    required this.child,
    required this.controller,
    this.indicatorSize = GazeScrollableIndicatorSize.medium,
  }) : super(key: key);

  final String route;
  final Widget child;
  final ScrollController controller;
  final GazeScrollableIndicatorSize indicatorSize;

  final GlobalKey gazeInteractiveKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GazeScrollableImpl(
      route: route,
      controller: controller,
      wrappedKey: gazeInteractiveKey,
      indicatorWidth: indicatorSize.size.width,
      indicatorHeight: indicatorSize.size.height,
      indicatorInnerPadding: indicatorSize.padding,
      child: child,
    );
  }
}
