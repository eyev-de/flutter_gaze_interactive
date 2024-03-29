import 'package:example/snapp.settings.dart';
import 'package:flutter/material.dart';
import 'package:gaze_interactive/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(GazeContext(sharedPreferences: prefs, child: const MyApp()));
}

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
    GazeInteractive().currentRoute = '/';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: GazeTextField(
                    controller: _controller,
                    onChanged: (value) {},
                    properties: GazeTextFieldProperties(
                      obscureText: true,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      inputDecoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search_sharp),
                      ),
                    ),
                    onFocus: () {
                      GazeKeyboard().show(
                        context,
                        GazeKeyboardState(
                          node: _focusNode,
                          placeholder: 'Search',
                          controller: _controller,
                          undoHistoryController: _undoHistoryController,
                          route: '/dialog',
                          type: KeyboardType.extended,
                          language: Language.english,
                          selectedKeyboardPlatformType: KeyboardPlatformType.mobile,
                        ),
                        () => GazeInteractive().currentRoute = '/dialog',
                        (ctx) => Navigator.of(ctx).pop(),
                        (ctx) => GazeInteractive().currentRoute = '/',
                      );
                    },
                    focusNode: _focusNode,
                    route: '/',
                  ),
                ),
                const SizedBox(height: 20),
                Text(_dateTime.toIso8601String()),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 80,
                  child: GazeButton(
                    properties: GazeButtonProperties(text: 'Button', textColor: Colors.white, route: '/', backgroundColor: Colors.pink),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return GazeDatePicker(
                            firstDate: DateTime.parse('2012-12-12'),
                            initialDate: DateTime.now(),
                            route: '/',
                            lastDate: DateTime.parse('2025-12-12'),
                            selected: (value, context) {
                              Navigator.of(context).pop();
                              setState(() {
                                _dateTime = value;
                              });
                            },
                            cancelled: (context) {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                GazeSwitchButton(
                  properties: GazeSwitchButtonProperties(
                    route: '/',
                    enabled: true,
                    labelTextStyle: const TextStyle(fontSize: 10),
                    state: GazeSwitchButtonState(toggled: true, gazeInteractive: true),
                  ),
                  onToggled: (toggled) async {
                    return true;
                  },
                ),
                const Snapping(route: '/'),
              ],
            ),
          ),
          GazePointerView(),
        ],
      ),
    );
  }
}

PredicateReturnState gazeInteractionPredicate(Rect itemRect, Rect gazePointerRect, Rect snapPointerRect, String itemRoute, String currentRoute) {
  // Check in case of Dialog (maybe todo but only example here so no dialog yet)

  // Check in case of Regular Route
  if (itemRoute == currentRoute && itemRect.contains(gazePointerRect.center)) {
    return PredicateReturnState.gaze;
  }

  final intersectionSnap = itemRect.intersect(snapPointerRect);

  if (intersectionSnap.width.isNegative || intersectionSnap.height.isNegative) return PredicateReturnState.none;

  if (itemRoute == currentRoute) {
    return PredicateReturnState.snap;
  }

  return PredicateReturnState.none;
}
