//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'list_view_wrapper.dart';

class GazeListView extends StatelessWidget {
  final GlobalKey gazeInteractiveKey = GlobalKey();
  final Widget wrappedWidget;
  final ScrollController controller;
  final String route;
  final double indicatorWidth;
  GazeListView({
    Key? key,
    required this.wrappedWidget,
    required this.controller,
    required this.route,
    this.indicatorWidth = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GazeListViewWrapper(
      wrappedWidget: wrappedWidget,
      controller: controller,
      wrappedKey: gazeInteractiveKey,
      route: route,
      indicatorWidth: indicatorWidth,
    );
  }
}
