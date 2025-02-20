import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';

class DeleteAllButton extends GazeKeyboardUtilityButton {
  DeleteAllButton({super.key, required super.node, required super.state, super.label = 'All', required this.controller, required this.route});

  final TextEditingController controller;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return GazeKeyboardUtilityBaseButton(
      route: route,
      gazeInteractive: text != '',
      horizontal: label?.isEmpty ?? true,
      backgroundColor: text == '' ? tealColor.disabled : deleteButtonColor.background,
      text: label?.isEmpty ?? true ? null : label,
      iconColor: text == '' ? textDisabledColor : deleteButtonTextColor,
      textStyle: TextStyle(color: text == '' ? textDisabledColor : deleteButtonTextColor),
      icon: Platform.isIOS || Platform.isMacOS ? CupertinoIcons.delete : Icons.delete,
      onTap: text == '' ? null : () => {node.requestFocus(), controller.text = ''},
    );
  }
}
