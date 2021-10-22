//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button_wrapper.dart';

class GazeTextField extends StatelessWidget {
  final GlobalKey gazeInteractiveKey;

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChanged;
  final void Function()? onFocus;

  final String? placeholder;
  final int? maxLength;
  final bool enabled;
  final TextStyle? placeholderStyle;
  final EdgeInsetsGeometry padding;
  final Radius cursorRadius;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final String? route;
  final TextAlignVertical? textAlignVertical;

  GazeTextField({
    required this.gazeInteractiveKey,
    required this.controller,
    required this.focusNode,
    this.maxLength,
    this.placeholder,
    this.enabled = true,
    this.placeholderStyle,
    this.padding = const EdgeInsets.fromLTRB(20, 30, 20, 30),
    this.cursorRadius = const Radius.circular(20),
    this.style,
    this.keyboardType = TextInputType.name,
    this.route,
    this.textAlignVertical,
    this.onChanged,
    this.onFocus,
  }) : super(key: gazeInteractiveKey) {
    controller.addListener(() {
      if (onChanged != null) onChanged!(controller.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    return GazeButtonWrapper(
      properties: GazeButtonWrapperProperties(
        borderRadius: BorderRadius.all(cursorRadius),
        route: route,
        gazeInteractive: enabled,
      ),
      wrappedKey: gazeInteractiveKey,
      wrappedWidget: Positioned.fill(
        child: CupertinoTextField(
          focusNode: focusNode,
          controller: controller,
          maxLength: maxLength,
          minLines: null,
          maxLines: null,
          placeholder: placeholder,
          enabled: enabled,
          placeholderStyle: placeholderStyle,
          padding: padding,
          cursorRadius: cursorRadius,
          style: style,
          keyboardType: keyboardType,
          expands: true,
          textAlignVertical: textAlignVertical,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: () {
            if (onFocus != null) onFocus!();
          },
        ),
      ),
      onGazed: () {
        if (onFocus != null) onFocus!();
      },
    );
  }
}
