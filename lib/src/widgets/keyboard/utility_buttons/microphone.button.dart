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
    this.disabledColor = Colors.grey,
    this.highlightColor,
  });

  final BorderRadius borderRadius;
  final Color disabledColor;
  final Color? highlightColor;
  late final controllerProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(keyboardSpeechToTextStatusProvider);
    final selecting = ref.watch(state.selectingStateProvider);
    final isListening = ref.watch(keyboardSpeechToTextIsListeningProvider);
    final disabled = selecting || (!isListening && ref.watch(state.disableStateProvider));

    // if delete button is used -> stop speech to text
    ref.listen(controllerProvider, (before, after) async {
      if (after == '') {
        ref.read(keyboardSpeechToTextStatusProvider.notifier).status(status: KeyboardTextFieldStatus(cursor: -1));
        ref.read(state.disableStateProvider.notifier).state = false;
        await ref.read(keyboardSpeechToTextProvider.notifier).stop();
      }
    });

    final available = ref.watch(keyboardSpeechToTextAvailableProvider);
    return available.when(
      data: (data) {
        if (data == null || data == false) return _MicrophoneButton(route: state.route, icon: Icons.mic_off, disabledColor: disabledColor, disabled: true);
        return _MicrophoneButton(
          route: state.route,
          isListening: isListening,
          disabled: disabled,
          borderRadius: borderRadius,
          disabledColor: disabledColor,
          highlightColor: highlightColor,
          onTap: () async {
            if (isListening == false) {
              final selection = state.controller.value.selection;
              ref.read(keyboardSpeechToTextStatusProvider.notifier).status(
                    status: KeyboardTextFieldStatus(
                      before: selection.textBefore(state.controller.text),
                      after: selection.textAfter(state.controller.text),
                      cursor: state.controller.selection.baseOffset,
                    ),
                  );
              ref.read(keyboardSpeechToTextIsListeningProvider.notifier).listen();
              ref.read(state.disableStateProvider.notifier).state = true;
              // TODO(julia): Locale dependent on keyboard? -> can be changed in settings?
              // FIXME: hide mic on keyboard -> Mail / Password
              // FIXME: Notes: Add mic button to keyboard (as a separate button)
              await ref.read(keyboardSpeechToTextProvider.notifier).listen(locale: 'de-DE', controller: state.controller);
            } else {
              ref.read(state.disableStateProvider.notifier).state = false;
              await ref.read(keyboardSpeechToTextProvider.notifier).stop();
            }
          },
        );
      },
      // FIXME: Loading State auf gaze Button setzen
      loading: () => _MicrophoneButton(route: state.route, isLoading: true),
      error: (err, _) {
        debugPrint(err.toString());
        return _MicrophoneButton(route: state.route, icon: Icons.mic_off, disabled: true, disabledColor: disabledColor);
      },
    );
  }
}

class _MicrophoneButton extends StatelessWidget {
  const _MicrophoneButton({
    required this.route,
    this.onTap,
    this.highlightColor,
    this.icon = Icons.mic,
    this.disabled = false,
    this.isLoading = false,
    this.isListening = false,
    this.disabledColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final String route;
  final void Function()? onTap;
  final Color? highlightColor;
  final IconData icon;
  final bool disabled;
  final bool isLoading;
  final bool isListening;
  final Color disabledColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    const _loading = SizedBox(
      width: 80,
      child: Center(child: SizedBox.square(dimension: 40, child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2)))),
    );
    final _icon = isListening
        ? PulseIcon(icon: icon, pulseColor: highlightColor ?? Theme.of(context).primaryColor, iconSize: 30, innerSize: 40, pulseSize: 80)
        : SizedBox(width: 80, child: Icon(icon, size: 30, color: disabled ? disabledColor : null));
    return SizedBox(
      height: double.infinity,
      child: GazeButton(
        properties: GazeButtonProperties(route: route, direction: Axis.horizontal, borderRadius: borderRadius),
        onTap: disabled ? null : onTap,
        child: Center(child: isLoading ? _loading : _icon),
      ),
    );
  }
}
