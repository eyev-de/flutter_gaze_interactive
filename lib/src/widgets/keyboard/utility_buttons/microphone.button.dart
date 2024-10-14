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
    this.disabledColor = textDisabledColor,
    this.highlightColor,
    this.iconColor,
    this.height,
  });

  final BorderRadius borderRadius;
  final Color disabledColor;
  final Color? highlightColor;
  final Color? iconColor;
  final double? height;
  late final controllerProvider = StateNotifierProvider((ref) => TextEditingControllerTextNotifier(controller: state.controller));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(keyboardSpeechToTextStatusProvider);
    final selecting = ref.watch(state.selectingStateProvider);
    final isListening = ref.watch(keyboardSpeechToTextIsListeningProvider);
    final disabled = selecting || (!isListening && ref.watch(state.disableStateProvider));
    final textIsEmpty = ref.watch(controllerProvider) == '';

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
        if (data == null || data == false) {
          return _MicrophoneButton(route: state.route, icon: Icons.mic_off, disabledColor: disabledColor, disabled: true, height: height);
        }
        return _MicrophoneButton(
          route: state.route,
          isListening: isListening,
          disabled: disabled,
          borderRadius: borderRadius,
          disabledColor: disabledColor,
          highlightColor: highlightColor,
          iconColor: iconColor,
          height: height,
          onTap: () async {
            node.requestFocus();
            if (isListening == false) {
              final selection = state.controller.value.selection;
              final status = textIsEmpty
                  ? KeyboardTextFieldStatus(cursor: 0)
                  : KeyboardTextFieldStatus(
                      before: selection.textBefore(state.controller.text),
                      after: selection.textAfter(state.controller.text),
                      cursor: state.controller.selection.baseOffset,
                    );
              ref.read(keyboardSpeechToTextStatusProvider.notifier).status(status: status);
              ref.read(keyboardSpeechToTextIsListeningProvider.notifier).listen();
              ref.read(state.disableStateProvider.notifier).state = true;
              await ref.read(keyboardSpeechToTextProvider.notifier).listen(controller: state.controller);
            } else {
              ref.read(state.disableStateProvider.notifier).state = false;
              await ref.read(keyboardSpeechToTextProvider.notifier).stop();
            }
          },
        );
      },
      loading: () => _MicrophoneButton(route: state.route, isLoading: true, height: height),
      error: (err, _) {
        debugPrint(err.toString());
        return _MicrophoneButton(route: state.route, icon: Icons.mic_off, disabled: true, disabledColor: disabledColor, height: height);
      },
    );
  }
}

class _MicrophoneButton extends StatelessWidget {
  const _MicrophoneButton({
    required this.route,
    this.onTap,
    this.height,
    this.iconColor,
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
  final double? height;
  final Color? iconColor;
  final Color? highlightColor;
  final IconData icon;
  final bool disabled;
  final bool isLoading;
  final bool isListening;
  final Color disabledColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final color = highlightColor ?? Theme.of(context).primaryColor;
    const _loading = Center(child: SizedBox.square(dimension: 30, child: CircularProgressIndicator(strokeWidth: 2)));
    final _icon = isListening
        ? PulseIcon(icon: icon, pulseColor: color, iconColor: iconColor ?? Colors.white, iconSize: 30, innerSize: 40, pulseSize: 80)
        : SizedBox(width: 80, child: Icon(icon, size: 30, color: disabled ? disabledColor : null));
    return SizedBox(
      width: 80,
      child: GazeButton(
        properties: GazeButtonProperties(route: route, direction: Axis.horizontal, borderRadius: borderRadius),
        onTap: disabled ? null : onTap,
        child: Align(alignment: Alignment.bottomRight, child: SizedBox(height: height ?? double.infinity, child: isLoading ? _loading : _icon)),
      ),
    );
  }
}
