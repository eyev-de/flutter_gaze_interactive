//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'button/button.dart';

class GazeRadioButton extends StatelessWidget {
  GazeRadioButton({
    super.key,
    required this.route,
    required this.selected,
    required this.onTap,
    this.size = 30,
    this.color = Colors.yellow,
    this.innerPadding = const EdgeInsets.all(60),
  });

  final String route;
  final bool selected;
  final void Function() onTap;
  final double size;
  final Color color;
  final EdgeInsets innerPadding;

  @override
  Widget build(BuildContext context) {
    return GazeButton(
      onTap: selected ? null : onTap,
      properties: GazeButtonProperties(route: route, horizontal: true, gazeInteractive: !selected, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: innerPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IgnorePointer(
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? color : null,
                  border: selected ? null : Border.all(color: color, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
