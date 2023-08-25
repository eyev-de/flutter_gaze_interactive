//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'button/selection_animation.dart';

class GazeTextFieldProperties {
  GazeTextFieldProperties({
    this.maxLength,
    this.style,
    this.onSaved,
    this.validator,
    this.inputDecoration,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textAlignVertical,
    this.textAlign = TextAlign.start,
    this.cursorRadius = const Radius.circular(2),
    this.enabled = true,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.obscureText = false,
  });

  final int? maxLength;
  final TextStyle? style;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final InputDecoration? inputDecoration;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final Radius cursorRadius;
  final bool enabled;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool expands;
  final bool obscureText;
}

class GazeTextField extends StatelessWidget {
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

  final TextEditingController controller;
  final FocusNode focusNode;
  final String route;
  final GazeTextFieldProperties properties;
  final void Function(String)? onChanged;
  final void Function()? onFocus;

  @override
  Widget build(BuildContext context) {
    return GazeSelectionAnimation(
      properties: GazeSelectionAnimationProperties(route: route, gazeInteractive: properties.enabled),
      wrappedKey: GlobalKey(),
      wrappedWidget: Positioned.directional(
        textDirection: TextDirection.ltr,
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: TextInputType.none,
          onTap: onFocus?.call,
          // GazeTextFieldProperties
          maxLength: properties.maxLength,
          style: properties.style,
          onSaved: properties.onSaved,
          validator: properties.validator,
          decoration: properties.inputDecoration,
          textInputAction: properties.textInputAction,
          onFieldSubmitted: properties.onFieldSubmitted,
          textAlignVertical: properties.textAlignVertical,
          textAlign: properties.textAlign,
          cursorRadius: properties.cursorRadius,
          enabled: properties.enabled,
          autocorrect: properties.autocorrect,
          enableSuggestions: properties.enableSuggestions,
          expands: properties.expands,
          obscureText: properties.obscureText,
          maxLines: properties.obscureText ? 1 : null,
        ),
      ),
      onGazed: onFocus?.call,
    );
  }
}
