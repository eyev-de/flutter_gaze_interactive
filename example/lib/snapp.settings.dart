import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaze_interactive/api.dart';

class Snapping extends ConsumerWidget {
  final String route;
  Snapping({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsRow(
      title: 'Snapping',
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 40, 10),
        child: GazeSwitchButton(
          key: GlobalKey(),
          properties: GazeSwitchButtonProperties(
            route: route,
            state: GazeSwitchButtonState(toggled: ref.read(snapActiveStateProvider), gazeInteractive: true),
            toggledColor: Colors.green,
            unToggledColor: Colors.pink,
            margin: const EdgeInsets.fromLTRB(15, 35, 15, 35),
            size: const Size(80, 80),
          ),
          onToggled: (toggled) async {
            print('toggle: $toggled');
            ref.read(snapActiveStateProvider.notifier).update(active: toggled);
            return true;
          },
        ),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  SettingsRow({Key? key, required this.title, required this.child}) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(40, 20, 0, 20),
            child: Text(
              title,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
