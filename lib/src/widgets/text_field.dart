//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button/selection_animation.dart';

class GazeTextFieldProperties {
  final String? placeholder;
  final int? maxLength;
  final bool enabled;
  final TextStyle? placeholderStyle;
  final EdgeInsetsGeometry padding;
  final Radius cursorRadius;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  GazeTextFieldProperties({
    this.maxLength,
    this.placeholder,
    this.enabled = true,
    this.placeholderStyle,
    this.padding = const EdgeInsets.fromLTRB(20, 30, 20, 30),
    this.cursorRadius = const Radius.circular(2),
    this.style,
    this.keyboardType = TextInputType.name,
    this.textAlignVertical,
    this.textAlign = TextAlign.start,
  });
}

class GazeTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String route;

  final GazeTextFieldProperties properties;

  final void Function(String)? onChanged;
  final void Function()? onFocus;

  GazeTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.properties,
    required this.route,
    this.onChanged,
    this.onFocus,
  }) : super(key: key) {
    controller.addListener(() {
      if (onChanged != null) onChanged!(controller.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    return GazeSelectionAnimation(
      properties: GazeSelectionAnimationProperties(
        route: route,
        gazeInteractive: properties.enabled,
      ),
      wrappedKey: GlobalKey(),
      wrappedWidget: Positioned.fill(
        child: CupertinoTextField(
          focusNode: focusNode,
          controller: controller,
          maxLength: properties.maxLength,
          maxLines: null,
          placeholder: properties.placeholder,
          enabled: properties.enabled,
          placeholderStyle: properties.placeholderStyle,
          padding: properties.padding,
          cursorRadius: properties.cursorRadius,
          style: properties.style,
          keyboardType: properties.keyboardType,
          expands: true,
          textAlignVertical: properties.textAlignVertical,
          textAlign: properties.textAlign,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: onFocus?.call,
        ),
      ),
      onGazed: onFocus?.call,
    );
  }
}
