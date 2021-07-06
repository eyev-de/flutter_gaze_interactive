//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'button.dart';

class GazeRadioButton extends StatelessWidget {
  final bool selected;
  final Color color;
  final void Function() onTap;
  GazeRadioButton({Key? key, required this.selected, this.color = Colors.yellow, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GazeButton(
      properties: GazeButtonProperties(
        key: GlobalKey(),
        innerPadding: const EdgeInsets.fromLTRB(60, 60, 60, 60),
        horizontal: true,
        borderRadius: BorderRadius.circular(20),
        gazeInteractive: !selected,
        child: Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IgnorePointer(
                child: Container(
                  width: 30,
                  height: 30,
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
