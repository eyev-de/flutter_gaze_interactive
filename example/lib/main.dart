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
  const MyApp({super.key});

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

final debugRRectsProvider = NotifierProvider<SimpleNotifier<DebugRRects?>, DebugRRects?>(() => SimpleNotifier(null));
final debugButtonRadiusProvider = NotifierProvider<SimpleNotifier<BorderRadius>, BorderRadius>(() => SimpleNotifier(BorderRadius.zero));
final debugGazePointerTypeProvider = NotifierProvider<SimpleNotifier<GazePointerType>, GazePointerType>(() => SimpleNotifier(GazePointerType.passive));

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
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 20,
                  children: [
                    _PointerTypeButton(route: '/', type: type),
                    const _PointerSizeButton(route: '/'),
                    const _KeyboardSizeControls(),
                    DebugExampleButton(),
                    const SizedBox(height: 20),
                    _SearchTextField(focusNode: _focusNode, controller: _controller, undoController: _undoHistoryController),
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
          ),
          GazePointerView(state: GazePointerState(type: type)),
          const RRectIntersect(),
        ],
      ),
    );
  }

  PredicateReturnState gazeInteractionPredicate(GazeShape element, GazeShape gazePointer, GazeShape snapPointer, String itemRoute, String currentRoute) {
    // Route check
    if (itemRoute != currentRoute) return PredicateReturnState.none;
    // Debug: Check overlap with gaze pointer, using inner factor for more precise detection
    final factor = GazePointerUtil.computeFactor(size: gazePointer.rect.width);
    final innerRect = Rect.fromCircle(center: gazePointer.rect.center, radius: gazePointer.rect.width / 2 * factor);
    final innerRadius = Radius.circular(gazePointer.rect.width / 2 * factor);
    // Gaze if element intersects the inner area of the gaze pointer, which represents 30%–60% of the pointer size
    if (element.overlaps(gazePointer, factor: factor)) {
      ref.read(debugRRectsProvider.notifier).set(DebugRRects(element: element.toRRect, gaze: RRect.fromRectAndRadius(innerRect, innerRadius)));
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
  const RRectIntersectionPainter({required this.element, required this.gaze});

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
              ref.read(debugButtonRadiusProvider.notifier).set(borderRadius);
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
        return BorderRadius.horizontal(left: Radius.circular(r()), right: Radius.circular(r()));
      case 3:
        return BorderRadius.vertical(top: Radius.circular(r()), bottom: Radius.circular(r()));
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
            properties: GazeButtonProperties(route: route, borderRadius: BorderRadius.circular(buttonSize), gazeInteractive: s != size),
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

/// The keyboard sizing controls: four independent, persisted size settings on
/// [GazeInteractiveState] — the key font, the key icon, the utility-button font
/// and the utility-button icon — each with its own slider.
///
/// Every setting defaults to "auto" (a stored value of
/// [gazeInteractiveKeyboardSizeAuto]): the keyboard then sizes that content to
/// each box (see [GazeKeyboardKeySizing]). Dragging a slider switches just that
/// setting to a fixed size; its own "Auto" button resets only that setting. A
/// live preview at the bottom reflects all four current values.
class _KeyboardSizeControls extends ConsumerWidget {
  const _KeyboardSizeControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = gazeInteractiveState;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Keyboard sizing', style: Theme.of(context).textTheme.titleLarge),
        Text(
          'Each control defaults to Auto (sized per key). Drag a slider to fix a size, or tap its Auto to reset.',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        _KeyboardSizeSlider(
          title: 'Key font',
          value: ref.watch(state.keyboardFontSize),
          min: gazeInteractiveMinKeyboardFontSize,
          max: gazeInteractiveMaxKeyboardFontSize,
          autoPreviewValue: GazeKeyboardKeySizing.optimalFontSize(const BoxConstraints(maxWidth: 64, maxHeight: 64)),
          onChanged: (value) => ref.read(state.keyboardFontSize.notifier).update(value),
          onAuto: () => ref.read(state.keyboardFontSize.notifier).update(gazeInteractiveKeyboardSizeAuto),
        ),
        _KeyboardSizeSlider(
          title: 'Key icon',
          value: ref.watch(state.keyboardIconSize),
          min: gazeInteractiveMinKeyboardIconSize,
          max: gazeInteractiveMaxKeyboardIconSize,
          autoPreviewValue: GazeKeyboardKeySizing.optimalIconSize(const BoxConstraints(maxWidth: 64, maxHeight: 64)),
          onChanged: (value) => ref.read(state.keyboardIconSize.notifier).update(value),
          onAuto: () => ref.read(state.keyboardIconSize.notifier).update(gazeInteractiveKeyboardSizeAuto),
        ),
        _KeyboardSizeSlider(
          title: 'Utility font',
          value: ref.watch(state.keyboardUtilityFontSize),
          min: gazeInteractiveMinKeyboardUtilityFontSize,
          max: gazeInteractiveMaxKeyboardUtilityFontSize,
          autoPreviewValue: GazeKeyboardKeySizing.optimalUtilityFontSize(const BoxConstraints(maxWidth: 90, maxHeight: 64)),
          onChanged: (value) => ref.read(state.keyboardUtilityFontSize.notifier).update(value),
          onAuto: () => ref.read(state.keyboardUtilityFontSize.notifier).update(gazeInteractiveKeyboardSizeAuto),
        ),
        _KeyboardSizeSlider(
          title: 'Utility icon',
          value: ref.watch(state.keyboardUtilityIconSize),
          min: gazeInteractiveMinKeyboardUtilityIconSize,
          max: gazeInteractiveMaxKeyboardUtilityIconSize,
          autoPreviewValue: GazeKeyboardKeySizing.optimalUtilityIconSize(const BoxConstraints(maxWidth: 90, maxHeight: 64)),
          onChanged: (value) => ref.read(state.keyboardUtilityIconSize.notifier).update(value),
          onAuto: () => ref.read(state.keyboardUtilityIconSize.notifier).update(gazeInteractiveKeyboardSizeAuto),
        ),
        const SizedBox(height: 12),
        const _KeyboardSizePreview(),
        const SizedBox(height: 12),
        const _ShowKeyboardButton(),
      ],
    );
  }
}

/// Opens the real gaze keyboard so the current sizing settings can be tried out
/// live. Owns its own text controllers (and disposes them) so the sizing group
/// stays self-contained.
class _ShowKeyboardButton extends StatefulWidget {
  const _ShowKeyboardButton();

  @override
  State<_ShowKeyboardButton> createState() => _ShowKeyboardButtonState();
}

class _ShowKeyboardButtonState extends State<_ShowKeyboardButton> {
  final TextEditingController _controller = TextEditingController();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _undoHistoryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showKeyboard() {
    if (GazeKeyboard().isShown) return;
    GazeKeyboard().show(
      context,
      GazeKeyboardState(
        node: _focusNode,
        route: '/dialog',
        placeholder: 'Type to preview the keyboard sizing',
        language: Language.english,
        type: KeyboardType.extended,
        controller: _controller,
        undoHistoryController: _undoHistoryController,
        selectedKeyboardPlatformType: KeyboardPlatformType.mobile,
      ),
      () => gazeInteractiveState.currentRoute = '/dialog',
      (ctx) => Navigator.of(ctx).pop(),
      (ctx) => gazeInteractiveState.currentRoute = '/',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: GazeButton(
        color: tealColor,
        onTap: _showKeyboard,
        properties: GazeButtonProperties(
          route: '/',
          direction: Axis.horizontal,
          innerPadding: const EdgeInsets.symmetric(horizontal: 16),
          icon: const Icon(Icons.keyboard, color: surfaceColor),
          text: const Text(
            'Show keyboard',
            style: TextStyle(color: surfaceColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

/// One labelled slider bound to a single persisted size setting. When the stored
/// [value] is "auto" the thumb parks at [autoPreviewValue] (a representative
/// optimal) and the "Auto" button is disabled; dragging fixes a size and
/// re-enables it.
class _KeyboardSizeSlider extends StatelessWidget {
  const _KeyboardSizeSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.autoPreviewValue,
    required this.onChanged,
    required this.onAuto,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final double autoPreviewValue;
  final ValueChanged<double> onChanged;
  final VoidCallback onAuto;

  @override
  Widget build(BuildContext context) {
    final isAuto = value <= gazeInteractiveKeyboardSizeAuto;
    final sliderValue = (isAuto ? autoPreviewValue : value).clamp(min, max).toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(isAuto ? '$title — Auto' : '$title — ${value.round()}', style: Theme.of(context).textTheme.titleMedium)),
              TextButton(onPressed: isAuto ? null : onAuto, child: const Text('Auto')),
            ],
          ),
          Slider(
            value: sliderValue,
            min: min,
            max: max,
            divisions: (max - min).round(),
            label: isAuto ? 'Auto' : value.round().toString(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Live preview of all four size settings: a letter key + an icon key (driven by
/// the key font / icon sizes) and a utility button (driven by the utility font /
/// icon sizes). Each element resolves "auto" with the same [GazeKeyboardKeySizing]
/// helpers the real keyboard uses.
class _KeyboardSizePreview extends ConsumerWidget {
  const _KeyboardSizePreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = gazeInteractiveState;
    final keyFont = ref.watch(state.keyboardFontSize);
    final keyIcon = ref.watch(state.keyboardIconSize);
    final utilFont = ref.watch(state.keyboardUtilityFontSize);
    final utilIcon = ref.watch(state.keyboardUtilityIconSize);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preview', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          children: [
            _PreviewKey(
              builder: (c) => Text(
                'A',
                style: TextStyle(color: Colors.black, fontSize: keyFont > 0 ? keyFont : GazeKeyboardKeySizing.optimalFontSize(c)),
              ),
            ),
            const SizedBox(width: 12),
            _PreviewKey(
              builder: (c) => Icon(Icons.backspace_outlined, color: Colors.black, size: keyIcon > 0 ? keyIcon : GazeKeyboardKeySizing.optimalIconSize(c)),
            ),
            const SizedBox(width: 24),
            _PreviewUtilityButton(fontSize: utilFont, iconSize: utilIcon),
          ],
        ),
      ],
    );
  }
}

/// A utility-button-shaped preview (icon stacked over a label) that mirrors how
/// [GazeKeyboardUtilityBaseButton] resolves its auto sizes.
class _PreviewUtilityButton extends StatelessWidget {
  const _PreviewUtilityButton({required this.fontSize, required this.iconSize});

  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 72,
      decoration: BoxDecoration(color: tealColor, borderRadius: BorderRadius.circular(20)),
      child: LayoutBuilder(
        builder: (context, c) {
          final resolvedIcon = iconSize > 0 ? iconSize : GazeKeyboardKeySizing.optimalUtilityIconSize(c);
          final resolvedFont = fontSize > 0 ? fontSize : GazeKeyboardKeySizing.optimalUtilityFontSize(c);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.content_copy, color: Colors.black, size: resolvedIcon),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Copy',
                    style: TextStyle(color: Colors.black, fontSize: resolvedFont),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A small key-shaped box that reports its constraints to [builder], so the
/// preview content can be auto-sized exactly like a real keyboard key.
class _PreviewKey extends StatelessWidget {
  const _PreviewKey({required this.builder});

  final Widget Function(BoxConstraints constraints) builder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
      child: LayoutBuilder(builder: (context, constraints) => Center(child: builder(constraints))),
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
            onTap: () => ref.read(debugGazePointerTypeProvider.notifier).set(GazePointerType.passive),
          ),
          GazeToggleButton(
            active: type == GazePointerType.active,
            label: const Text('Active', style: TextStyle(color: Colors.white)),
            onTap: () => ref.read(debugGazePointerTypeProvider.notifier).set(GazePointerType.active),
          ),
          GazeToggleButton(
            active: type == GazePointerType.history,
            label: const Text('History', style: TextStyle(color: Colors.white)),
            onTap: () => ref.read(debugGazePointerTypeProvider.notifier).set(GazePointerType.history),
          ),
        ],
      ),
    );
  }
}
