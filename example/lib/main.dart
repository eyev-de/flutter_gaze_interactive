import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaze_interactive/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  gazeInteractiveState = GazeInteractiveState(sharedPreferences: prefs);
  runApp(GazeContext(state: gazeInteractiveState, child: const MyApp()));
}

late final GazeInteractiveState gazeInteractiveState;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const App(),
      title: 'Gaze Keyboard Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        primaryTextTheme: const TextTheme(displayLarge: TextStyle(fontSize: 30, color: Colors.white)),
        inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
              filled: true,
              fillColor: Colors.black,
              contentPadding: const EdgeInsets.all(20),
              border: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(20.0))),
            ),
      ),
    );
  }
}

final debugRRectsProvider = StateProvider<DebugRRects?>((_) => null);
final debugButtonRadiusProvider = StateProvider<BorderRadius>((_) => BorderRadius.zero);
final debugGazePointerTypeProvider = StateProvider<GazePointerType>((_) => GazePointerType.passive);

class DebugRRects {
  final RRect element;
  final RRect gaze;

  DebugRRects({required this.element, required this.gaze});
}

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final TextEditingController _controller = TextEditingController();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  final FocusNode _focusNode = FocusNode();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    gazeInteractiveState.predicate = gazeInteractionPredicate;
    gazeInteractiveState.currentRoute = '/';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 1.8;
    final type = ref.watch(debugGazePointerTypeProvider);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  _PointerTypeButton(route: '/', type: type),
                  const _PointerSizeButton(route: '/'),
                  DebugExampleButton(),
                  const SizedBox(height: 20),
                  _SearchTextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    undoController: _undoHistoryController,
                  ),
                  ContentRow(
                    subtitle: 'Date',
                    title: _dateTime.toString(),
                    child: _DateButton(selected: ({required DateTime value}) => setState(() => _dateTime = value)),
                  ),
                  ContentRow(
                    title: 'Example Switch Button',
                    subtitle: 'Clickable without value change',
                    child: GazeSwitchButton(
                      route: '/',
                      value: true,
                      onChanged: (_) {},
                      properties: GazeSwitchButtonProperties(gazeInteractive: true, labelTextStyle: const TextStyle(fontSize: 10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GazePointerView(state: GazePointerState(type: type)),
          const RRectIntersect(),
        ],
      ),
    );
  }

  PredicateReturnState gazeInteractionPredicate(
    GazeShape element,
    GazeShape gazePointer,
    GazeShape snapPointer,
    String itemRoute,
    String currentRoute,
  ) {
    // Route check
    if (itemRoute != currentRoute) return PredicateReturnState.none;
    // Debug: Check overlap with gaze pointer, using inner factor for more precise detection
    final factor = GazePointerUtil.computeFactor(size: gazePointer.rect.width);
    final innerRect = Rect.fromCircle(center: gazePointer.rect.center, radius: gazePointer.rect.width / 2 * factor);
    final innerRadius = Radius.circular(gazePointer.rect.width / 2 * factor);
    // Gaze if element intersects the inner area of the gaze pointer, which represents 30%–60% of the pointer size
    if (element.overlaps(gazePointer, factor: factor)) {
      ref.read(debugRRectsProvider.notifier).state = DebugRRects(element: element.toRRect, gaze: RRect.fromRectAndRadius(innerRect, innerRadius));
      return PredicateReturnState.gaze;
    }
    return PredicateReturnState.none;
  }
}

class RRectIntersect extends ConsumerWidget {
  const RRectIntersect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debug = ref.watch(debugRRectsProvider);
    if (debug == null) return const IgnorePointer(child: SizedBox.shrink());
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: RRectIntersectionPainter(element: debug.element, gaze: debug.gaze),
        ),
      ),
    );
  }
}

class RRectIntersectionPainter extends CustomPainter {
  const RRectIntersectionPainter({
    required this.element,
    required this.gaze,
  });

  final RRect? element;
  final RRect? gaze;

  @override
  void paint(Canvas canvas, Size size) {
    if (element == null || gaze == null) return;
    final pathA = Path()..addRRect(element!);
    final pathB = Path()..addRRect(gaze!);
    final intersection = Path.combine(PathOperation.intersect, pathA, pathB);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.pinkAccent;
    if (intersection.computeMetrics().isNotEmpty) {
      canvas.drawPath(intersection, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RRectIntersectionPainter oldDelegate) => false;
}

class DebugExampleButton extends ConsumerWidget {
  DebugExampleButton({super.key});

  final _rnd = Random();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = ref.watch(debugButtonRadiusProvider);
    // random width with min 100 and max 400
    final width = Random().nextInt(300) + 100;
    // random height with min 100 and max 200
    final height = Random().nextInt(100) + 100;
    return SizedBox(
      width: 400,
      height: 200,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width.toDouble(),
          height: height.toDouble(),
          child: GazeButton(
            color: Colors.black,
            properties: GazeButtonProperties(route: '/', borderRadius: borderRadius, icon: const Icon(Icons.refresh)),
            onTap: () {
              final borderRadius = randomBorderRadius(maxRadius: 200);
              ref.read(debugButtonRadiusProvider.notifier).state = borderRadius;
            },
          ),
        ),
      ),
    );
  }

  BorderRadius randomBorderRadius({double maxRadius = 120.0}) {
    r() => _rnd.nextDouble() * maxRadius;
    switch (_rnd.nextInt(6)) {
      case 0:
        return BorderRadius.zero;
      case 1:
        final radius = r();
        return BorderRadius.all(Radius.circular(radius));
      case 2:
        return BorderRadius.horizontal(
          left: Radius.circular(r()),
          right: Radius.circular(r()),
        );
      case 3:
        return BorderRadius.vertical(
          top: Radius.circular(r()),
          bottom: Radius.circular(r()),
        );
      case 4:
        return BorderRadius.only(
          topLeft: _rnd.nextBool() ? Radius.circular(r()) : Radius.zero,
          topRight: _rnd.nextBool() ? Radius.circular(r()) : Radius.zero,
          bottomLeft: _rnd.nextBool() ? Radius.circular(r()) : Radius.zero,
          bottomRight: _rnd.nextBool() ? Radius.circular(r()) : Radius.zero,
        );
      default:
        return BorderRadius.only(
          topLeft: Radius.circular(r()),
          topRight: Radius.circular(r()),
          bottomLeft: Radius.circular(r()),
          bottomRight: Radius.circular(r()),
        );
    }
  }
}

class ContentRow extends StatelessWidget {
  const ContentRow({super.key, required this.title, this.subtitle = '', required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({required this.focusNode, required this.controller, required this.undoController});

  final FocusNode focusNode;
  final TextEditingController controller;
  final UndoHistoryController undoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.8,
      child: GazeTextField(
        route: '/',
        focusNode: focusNode,
        controller: controller,
        onChanged: (value) {},
        properties: GazeTextFieldProperties(
          obscureText: true,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          inputDecoration: const InputDecoration(hintText: 'Search', prefixIcon: Icon(Icons.search_sharp)),
        ),
        onFocus: () {
          GazeKeyboard().show(
            context,
            GazeKeyboardState(
              node: focusNode,
              route: '/dialog',
              placeholder: 'Search',
              language: Language.english,
              type: KeyboardType.extended,
              controller: controller,
              undoHistoryController: undoController,
              selectedKeyboardPlatformType: KeyboardPlatformType.mobile,
            ),
            () => gazeInteractiveState.currentRoute = '/dialog',
            (ctx) => Navigator.of(ctx).pop(),
            (ctx) => gazeInteractiveState.currentRoute = '/',
          );
        },
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.selected});

  final void Function({required DateTime value}) selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 80,
      child: GazeButton(
        color: Colors.pink,
        properties: GazeButtonProperties(text: const Text('Select'), route: '/'),
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return GazeDatePicker(
                route: '/',
                initialDate: DateTime.now(),
                firstDate: DateTime.parse('2012-12-12'),
                lastDate: DateTime.parse('2025-12-12'),
                cancelled: (context) => Navigator.of(context).pop(),
                selected: (value, context) {
                  Navigator.of(context).pop();
                  selected(value: value);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PointerSizeButton extends ConsumerWidget {
  const _PointerSizeButton({required this.route});

  final String route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const length = 5;
    const minSize = gazeInteractiveMinPointerSize; // 10
    const maxSize = gazeInteractiveMaxPointerSize; // 70
    const step = (maxSize - minSize) / (length - 1);
    final sizes = List.generate(length, (i) => double.parse((minSize + i * step).toStringAsFixed(1)).toDouble());
    final labels = ['XS', 'S', 'M', 'L', 'XL'];
    final size = ref.watch(gazeInteractiveState.pointerSize);
    const buttonSize = 55.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sizes.map((s) {
        final index = sizes.indexOf(s);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GazeButton(
            onTap: () => ref.read(gazeInteractiveState.pointerSize.notifier).update(s),
            properties: GazeButtonProperties(
              route: route,
              borderRadius: BorderRadius.circular(buttonSize),
              gazeInteractive: s != size,
            ),
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: s == size ? Colors.amber : Colors.amber.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(buttonSize),
                border: s == size ? Border.all(color: Colors.white, width: 3) : null,
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(color: Colors.black, fontWeight: s == size ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PointerTypeButton extends ConsumerWidget {
  const _PointerTypeButton({required this.route, required this.type});

  final GazePointerType type;
  final String route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.8,
      child: GazeToggleButtons(
        route: route,
        buttons: [
          GazeToggleButton(
            active: type == GazePointerType.passive,
            label: const Text('Passive', style: TextStyle(color: Colors.white)),
            onTap: () => ref.read(debugGazePointerTypeProvider.notifier).state = GazePointerType.passive,
          ),
          GazeToggleButton(
            active: type == GazePointerType.active,
            label: const Text('Active', style: TextStyle(color: Colors.white)),
            onTap: () => ref.read(debugGazePointerTypeProvider.notifier).state = GazePointerType.active,
          ),
          GazeToggleButton(
            active: type == GazePointerType.history,
            label: const Text('History', style: TextStyle(color: Colors.white)),
            onTap: () => ref.read(debugGazePointerTypeProvider.notifier).state = GazePointerType.history,
          ),
        ],
      ),
    );
  }
}
