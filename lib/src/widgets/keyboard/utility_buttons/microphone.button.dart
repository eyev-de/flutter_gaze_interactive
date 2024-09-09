import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulsator/pulsator.dart';

import '../../../../api.dart';
import '../../../core/text_editing_controller_notifier.dart';

class MicrophoneButton extends GazeKeyboardUtilityButton {
  MicrophoneButton({
    super.key,
    required super.state,
    required super.node,
    super.label = 'Mic',
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final BorderRadius borderRadius;
  late final controllerProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(state.selectingStateProvider);
    final isListening = ref.watch(keyboardSpeechToTextIsListeningProvider);
    // final disabled = selecting || (ref.watch(controllerProvider) == '' || ref.watch(state.disableStateProvider));

    return SizedBox(
      height: double.infinity,
      child: GazeButton(
        properties: GazeButtonProperties(
          borderRadius: borderRadius,
          direction: Axis.horizontal,
          route: state.route,
        ),
        child: Center(
          child: isListening
              ? PulseIcon(icon: Icons.mic, pulseColor: Theme.of(context).primaryColor, iconSize: 30, innerSize: 40, pulseSize: 80)
              : const SizedBox(width: 80, child: Icon(Icons.mic, size: 30)),
        ),
        onTap: () async {
          if (isListening == false) {
            ref.read(keyboardSpeechToTextIsListeningProvider.notifier).listen();
            await ref.read(keyboardSpeechToTextProvider.notifier).listen(locale: 'de-DE', controller: state.controller);
          } else {
            ref.read(keyboardSpeechToTextIsListeningProvider.notifier).dismiss();
            await ref.read(keyboardSpeechToTextProvider).stop();
          }
        },
      ),
    );
  }
}
