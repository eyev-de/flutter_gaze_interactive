//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'button/button.dart';

class GazeRadioButton extends StatelessWidget {
  final bool selected;
  final Color color;
  final EdgeInsets innerPadding;
  final double size;
  final void Function() onTap;
  final String route;

  GazeRadioButton({
    Key? key,
    required this.selected,
    this.color = Colors.yellow,
    this.innerPadding = const EdgeInsets.fromLTRB(60, 60, 60, 60),
    this.size = 30,
    required this.onTap,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GazeButton(
      properties: GazeButtonProperties(
        horizontal: true,
        borderRadius: BorderRadius.circular(20),
        gazeInteractive: !selected,
        route: route,
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
                    border: selected
                        ? null
                        : Border.all(
                            color: color,
                            width: 2,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: selected ? null : onTap,
    );
  }
}
