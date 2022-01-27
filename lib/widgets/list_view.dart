//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import '../gaze_interactive.dart';

class GazeListView extends StatelessWidget {
  final GlobalKey gazeInteractiveKey = GlobalKey();
  final Widget wrappedWidget;
  final ScrollController controller;
  final String route;
  GazeListView({
    Key? key,
    required this.wrappedWidget,
    required this.controller,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GazeListViewWrapper(
      wrappedWidget: wrappedWidget,
      controller: controller,
      wrappedKey: gazeInteractiveKey,
      route: route,
    );
  }
}
