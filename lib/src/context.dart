import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state.dart';

class GazeContext extends StatelessWidget {
  const GazeContext({super.key, required this.child, required this.state});
  final Widget child;
  final GazeInteractiveState state;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [gazeInteractiveProvider.overrideWithValue(state)],
    child: _GazeContext(state: state, child: child),
  );
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
    widget.state.bindRef(() => ref);
  }

  @override
  void dispose() {
    widget.state.unbindRef();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(widget.state.activeStateProvider, (prev, next) {
        if (!next) {
          // When becoming inactive, call leave callbacks but don't clear the list -> allows views to be re-entered automatically when active again
          for (final view in widget.state.currentGazeViews) {
            view.onGazeLeave?.call();
          }
        } else if (prev != null && !prev && next) {
          // When becoming active again, trigger re-entry for views that were active -> next onGaze event will re-populate _currentGazeViews via onPointerMove
        }
      })
      ..listen(widget.state.currentRouteStateProvider, (prev, next) {
        // Only clear if route really changes and is not empty
        if (prev != null && next.isNotEmpty && prev != next) widget.state.leaveAllGazeViews();
      });
    return widget.child;
  }
}
