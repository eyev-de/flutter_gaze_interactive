//  Skyle
//
//  Created by Konstantin Wachendorff.
//  Copyright © 2021 eyeV GmbH. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../state.dart';
import 'button_wrapper.dart';

class GazeTextField extends StatelessWidget {
  final GlobalKey gazeInteractiveKey = GlobalKey();

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChanged;
  final void Function()? onFocus;

  final String? placeholder;
  final int? maxLength;
  final bool? enabled;
  final TextStyle? placeholderStyle;
  final EdgeInsetsGeometry padding;
  final Radius cursorRadius;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final String? route;

  GazeTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.maxLength,
    this.placeholder,
    this.enabled,
    this.placeholderStyle,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    this.cursorRadius = const Radius.circular(20),
    this.style,
    this.keyboardType = TextInputType.name,
    this.route,
    this.onChanged,
    this.onFocus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GazeButtonWrapper(
      properties: GazeButtonWrapperProperties(
        borderRadius: BorderRadius.all(cursorRadius),
        route: route,
      ),
      gazeInteractive: GazeInteractive(),
      wrappedKey: gazeInteractiveKey,
      wrappedWidget: CupertinoTextField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        maxLength: maxLength,
        placeholder: placeholder,
        enabled: enabled,
        placeholderStyle: placeholderStyle,
        padding: padding,
        cursorRadius: cursorRadius,
        style: style,
        keyboardType: keyboardType,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onGazed: () {
        focusNode.requestFocus();
        if (onFocus != null) onFocus!();
      },
    );
  }
}
