import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaze_interactive/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  gazeInteractiveState = GazeInteractiveState(sharedPreferences: prefs);
  runApp(GazeContext(child: const MyApp(), state: gazeInteractiveState));
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

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController _controller = TextEditingController();
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  final FocusNode _focusNode = FocusNode();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    //GazeInteractive().predicate = gazeInteractionPredicate;
    gazeInteractiveState.currentRoute = '/';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 1.8;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _SearchTextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    undoController: _undoHistoryController,
                  ),
                  const SizedBox(height: 20),
                  ContentRow(
                    subtitle: 'Date',
                    title: _dateTime.toString(),
                    child: _DateButton(selected: ({required DateTime value}) => setState(() => _dateTime = value)),
                  ),
                  const SizedBox(height: 25),
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
                  const SizedBox(height: 20),
                  const ContentRow(
                    title: 'Snapping',
                    subtitle: 'Toggles between snapping mode',
                    child: _SnapSwitchButton(route: '/'),
                  ),
                ],
              ),
            ),
          ),
          GazePointerView(),
        ],
      ),
    );
  }
}

// Check in case of Dialog (maybe todo but only example here so no dialog yet)
PredicateReturnState gazeInteractionPredicate(Rect itemRect, Rect gazePointerRect, Rect snapPointerRect, String itemRoute, String currentRoute) {
  // Check in case of Regular Route
  if (itemRoute == currentRoute && itemRect.contains(gazePointerRect.center)) return PredicateReturnState.gaze;
  final intersectionSnap = itemRect.intersect(snapPointerRect);
  if (intersectionSnap.width.isNegative || intersectionSnap.height.isNegative) return PredicateReturnState.none;
  if (itemRoute == currentRoute) return PredicateReturnState.snap;
  return PredicateReturnState.none;
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

class _SnapSwitchButton extends ConsumerWidget {
  const _SnapSwitchButton({required this.route});

  final String route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GazeSwitchButton(
      route: route,
      value: ref.watch(snapActiveStateProvider),
      onChanged: (value) => ref.read(snapActiveStateProvider.notifier).update(active: value),
      properties: GazeSwitchButtonProperties(
        gazeInteractive: true,
        activeColor: Colors.green,
        inactiveColor: Colors.pink,
        size: const Size(80, 80),
      ),
    );
  }
}
