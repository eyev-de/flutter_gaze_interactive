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
    final obscureText = ref.watch(obscureTextProvider);
    return FormField(
      validator: properties.validator,
      onSaved: properties.onSaved,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GazeTextField(
              textField: _TextFieldGazeAnimation(
                route: route,
                onTap: onFocus?.call,
                properties: properties,
                controller: controller,
                focusNode: focusNode,
                obscureText: obscureText,
              ),
              obscureText: properties.obscureText,
              obscureButton: _TextFieldObscureTextGazeButton(
                enabled: properties.enabled,
                icon: ref.watch(obscureTextProvider) ? Icons.visibility_off : Icons.visibility,
                onTap: () => ref.read(obscureTextProvider.notifier).state = !ref.watch(obscureTextProvider),
              ),
            ),
            if (state.hasError)
              _TextFieldValidationError(
                text: state.errorText ?? ' - ',
                style: properties.inputDecoration?.errorStyle,
              ),
          ],
        );
      },
    );
  }
}

class _GazeTextField extends StatelessWidget {
  const _GazeTextField({required this.textField, required this.obscureText, required this.obscureButton});

  final _TextFieldGazeAnimation textField;
  final bool obscureText;
  final _TextFieldObscureTextGazeButton obscureButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textField,
        if (obscureText) ...[const SizedBox(width: 10), obscureButton],
      ],
    );
  }
}

class _TextFieldGazeAnimation extends StatelessWidget {
  const _TextFieldGazeAnimation({
    required this.route,
    required this.properties,
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onTap,
  });

  final String route;
  final GazeTextFieldProperties properties;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GazeSelectionAnimation(
        onGazed: onTap,
        wrappedKey: GlobalKey(),
        properties: GazeSelectionAnimationProperties(
          route: route,
          gazeInteractive: properties.enabled,
          snappable: properties.snappable,
        ),
        wrappedWidget: Positioned.directional(
          textDirection: TextDirection.ltr,
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            keyboardType: TextInputType.none,
            onTap: onTap,
            // GazeTextFieldProperties
            maxLength: properties.maxLength,
            style: properties.style,
            decoration: properties.inputDecoration,
            textInputAction: properties.textInputAction,
            onSubmitted: properties.onFieldSubmitted,
            textAlignVertical: properties.textAlignVertical,
            textAlign: properties.textAlign,
            cursorRadius: properties.cursorRadius,
            enabled: properties.enabled,
            autocorrect: properties.autocorrect,
            autofocus: properties.autofocus,
            enableSuggestions: properties.enableSuggestions,
            expands: properties.expands,
            obscureText: properties.obscureText && obscureText,
            maxLines: properties.obscureText ? 1 : null,
          ),
        ),
      ),
    );
  }
}

class _TextFieldObscureTextGazeButton extends StatelessWidget {
  const _TextFieldObscureTextGazeButton({required this.icon, required this.enabled, required this.onTap});

  final IconData icon;
  final bool enabled;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: GazeButton(
        onTap: onTap,
        properties: GazeButtonProperties(
          innerPadding: const EdgeInsets.symmetric(vertical: 24),
          gazeInteractive: enabled,
          backgroundColor: enabled ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.1),
          icon: Icon(icon),
        ),
      ),
    );
  }
}

class _TextFieldValidationError extends StatelessWidget {
  const _TextFieldValidationError({required this.style, required this.text});

  final TextStyle? style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Text(text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
