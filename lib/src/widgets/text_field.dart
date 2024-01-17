//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api.dart';

final obscureTextProvider = StateProvider((ref) => true);

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
    this.autofocus = false,
    this.enableSuggestions = true,
    this.expands = false,
    this.obscureText = false,
    // Textfields are snappable by default
    this.snappable = true,
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
  final bool autofocus;
  final bool enableSuggestions;
  final bool expands;
  final bool obscureText;
  final bool snappable;
}

class GazeTextField extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: GazeSelectionAnimation(
            properties: GazeSelectionAnimationProperties(
              route: route,
              gazeInteractive: properties.enabled,
              snappable: properties.snappable,
            ),
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
                autofocus: properties.autofocus,
                enableSuggestions: properties.enableSuggestions,
                expands: properties.expands,
                obscureText: properties.obscureText && ref.watch(obscureTextProvider),
                maxLines: properties.obscureText ? 1 : null,
              ),
            ),
            onGazed: onFocus?.call,
          ),
        ),
        if (properties.obscureText) ...[
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: GazeButton(
              properties: GazeButtonProperties(
                innerPadding: const EdgeInsets.symmetric(vertical: 24),
                gazeInteractive: properties.enabled,
                backgroundColor: properties.enabled ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.1),
                icon: Icon(ref.watch(obscureTextProvider) ? Icons.visibility_off : Icons.visibility),
              ),
              onTap: () {
                ref.read(obscureTextProvider.notifier).state = !ref.watch(obscureTextProvider);
              },
            ),
          )
        ],
      ],
    );
  }
}
