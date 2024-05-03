import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api.dart';
import '../../core/text_editing_controller_notifier.dart';

enum MailCompletions {
  en,
  de;

  List<String> get completions {
    return this == MailCompletions.de ? ['@gmail.com', '@outlook.de', '@gmx.de', '@web.de'] : ['@gmail.com', '@icloud.com', '@outlook.com', '@gmx.com'];
  }
}

class KeyboardMailCompletions extends StatelessWidget {
  const KeyboardMailCompletions({super.key, required this.state, required this.node});

  final GazeKeyboardState state;
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    final completions = Platform.localeName.endsWith('DE') ? MailCompletions.de.completions : MailCompletions.en.completions;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Flexible(
            flex: 8,
            child: Row(children: completions.map((completion) => _KeyboardMailCompletion(completion: completion, state: state, node: node)).toList()),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _KeyboardMailCompletion extends ConsumerWidget {
  _KeyboardMailCompletion({required this.completion, required this.state, required this.node});

  final String completion;
  final GazeKeyboardState state;
  final FocusNode node;

  late final controllerTextProvider = StateNotifierProvider((ref) => TextEditingControllerNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(controllerTextProvider);
    final usable = text == '' || (text! as String).contains('@');
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: GazeButton(
          properties: GazeButtonProperties(
            route: state.route,
            gazeInteractive: !usable,
            backgroundColor: Colors.grey.shade800,
            innerPadding: const EdgeInsets.all(0),
            borderRadius: BorderRadius.circular(15),
            text: Text(completion, style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(color: usable ? Colors.grey : Colors.white)),
          ),
          onTap: usable
              ? null
              : () {
                  node.requestFocus();
                  state.controller.text = state.controller.text + completion;
                },
        ),
      ),
    );
  }
}
