import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api.dart';
import '../../../core/extensions.dart';
import '../../../core/text_editing_controller_notifier.dart';

class DeleteAllButton extends GazeKeyboardUtilityButton {
  DeleteAllButton({
    super.key,
    required super.node,
    required super.state,
    super.label = 'All',
    required this.controller,
    required this.route,
    this.dialogTitle = 'Delete',
    this.dialogText = 'Do you really want to delete the whole text?',
    this.dialogCancelText = 'Cancel',
    this.dialogConfirmText = 'Delete',
  });

  final TextEditingController controller;
  final String route;
  final String dialogTitle;
  final String dialogText;
  final String dialogCancelText;
  final String dialogConfirmText;
  late final controllerTextProvider = NotifierProvider<TextEditingControllerTextNotifier, String>(
    () => TextEditingControllerTextNotifier(controller: controller),
  );

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
      onTap: text == ''
          ? null
          : () {
              node.requestFocus();
              _showConfirmationDialog(context, ref.read(gazeInteractiveProvider));
            },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context, GazeInteractiveState gazeInteractive) {
    final dialogRoute = '$route/dialog';
    // Move the gaze route onto the dialog so only its buttons are gaze-interactive while it is open.
    gazeInteractive.currentRoute = dialogRoute;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (dialogContext) => Stack(
        children: [
          AlertDialog(
            backgroundColor: surfaceColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text(dialogTitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: MediaQuery.of(dialogContext).size.width / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(dialogText, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _DeleteAllDialogButton(
                            text: dialogCancelText,
                            route: dialogRoute,
                            color: deleteButtonColor,
                            textColor: deleteButtonTextColor,
                            onTap: () => Navigator.of(dialogContext).pop(),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _DeleteAllDialogButton(
                            text: dialogConfirmText,
                            route: dialogRoute,
                            color: tealColor,
                            textColor: surfaceColor,
                            onTap: () {
                              controller.text = '';
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GazePointerView(),
        ],
      ),
    ).then((_) => gazeInteractive.currentRoute = route);
  }
}

class _DeleteAllDialogButton extends StatelessWidget {
  const _DeleteAllDialogButton({required this.text, required this.route, required this.color, required this.textColor, required this.onTap});

  final String text;
  final String route;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GazeButton(
      color: color,
      onTap: onTap,
      properties: GazeButtonProperties(
        route: route,
        withSound: true,
        direction: Axis.horizontal,
        innerPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        text: Text(text, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
