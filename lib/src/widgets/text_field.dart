//  Gaze Interactive
//
//  Created by the eyeV App Dev Team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'button/selection_animation.dart';

class GazeTextFieldProperties {
  final int? maxLength;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final Decoration? decoration;
  final Radius cursorRadius;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool obscureText;
  final InputDecoration? inputDecoration;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Color backgroundColor;
  GazeTextFieldProperties({
    this.maxLength,
    this.enabled = true,
    this.padding = const EdgeInsets.fromLTRB(20, 30, 20, 30),
    this.decoration = const BoxDecoration(
      color: Color(0xFF212121),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    this.cursorRadius = const Radius.circular(2),
    this.style,
    this.keyboardType = TextInputType.name,
    this.textAlignVertical,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.inputDecoration,
    this.onSaved,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.backgroundColor = const Color(0xFF212121), // Colors.grey.shade900
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
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: properties.padding,
          decoration: properties.decoration,
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            maxLength: properties.maxLength,
            maxLines: properties.obscureText ? 1 : null,
            enabled: properties.enabled,
            cursorRadius: properties.cursorRadius,
            style: properties.style,
            keyboardType: properties.keyboardType,
            expands: !properties.obscureText,
            textAlignVertical: properties.textAlignVertical,
            textAlign: properties.textAlign,
            autocorrect: properties.autocorrect,
            enableSuggestions: properties.enableSuggestions,
            decoration: properties.inputDecoration,
            onTap: onFocus?.call,
            onSaved: properties.onSaved,
            onFieldSubmitted: properties.onFieldSubmitted,
            validator: properties.validator,
            textInputAction: properties.textInputAction,
            obscureText: properties.obscureText,
          ),
        ),
      ),
      onGazed: onFocus?.call,
    );
  }
}
