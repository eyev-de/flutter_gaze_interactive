import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state.dart';

class GazeContext extends StatelessWidget {
  const GazeContext({super.key, required this.child, required this.state});
  final Widget child;
  final GazeInteractiveState state;

  @override
  Widget build(BuildContext context) => ProviderScope(overrides: [
        gazeInteractiveProvider.overrideWithValue(state),
      ], child: _GazeContext(state: state, child: child));
}

class _GazeContext extends ConsumerStatefulWidget {
  const _GazeContext({required this.child, required this.state});
  final Widget child;
  final GazeInteractiveState state;

  @override
  _GazeContextState createState() => _GazeContextState();
}

class _GazeContextState extends ConsumerState<_GazeContext> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state.ref = ref;
    ref
      ..listen(widget.state.activeStateProvider, (prev, next) {
        widget.state.leaveAllGazeViews();
      })
      ..listen(widget.state.currentRouteStateProvider, (prev, next) {
        widget.state.leaveAllGazeViews();
      });
    return widget.child;
  }
}
