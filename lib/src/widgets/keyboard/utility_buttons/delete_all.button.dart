import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/text_editing_controller_notifier.dart';
import '../keyboard_utility_buttons.dart';

class DeleteAllButton extends ConsumerWidget {
  DeleteAllButton({super.key, required this.controller, required this.node, required this.route});

  final TextEditingController controller;
  final FocusNode node;
  final String route;
  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    return GazeKeyboardUtilityBaseButton(
      backgroundColor: Colors.grey.shade800,
      icon: Icons.delete,
      iconColor: text == '' ? Colors.grey : Colors.red,
      horizontal: true,
      route: route,
      gazeInteractive: text != '',
      onTap: text == '' ? null : () => {node.requestFocus(), controller.text = ''},
    );
  }
}
