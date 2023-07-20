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
      title: 'Gaze Keyboard Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        primaryTextTheme: const TextTheme(displayLarge: TextStyle(fontSize: 30, color: Colors.white)),
      ),
      home: const App(),
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
  final FocusNode _focusNode = FocusNode();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    GazeInteractive().predicate = gazeInteractionPredicate;
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 200,
                    height: 120,
                    child: GazeTextField(
                      controller: _controller,
                      onChanged: (value) {},
                      properties: GazeTextFieldProperties(
                        maxLength: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey.shade700,
                          border: Border.all(color: Colors.pink),
                        ),
                        inputDecoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        padding: const EdgeInsets.all(20),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onFocus: () {
                        GazeKeyboard().show(
                          context,
                          GazeKeyboardState(node: _focusNode, placeholder: 'Search', controller: _controller, route: '/dialog'),
                          () => GazeInteractive().currentRoute = '/dialog',
                          (ctx) => Navigator.of(ctx).pop(),
                          (ctx) => GazeInteractive().currentRoute = '/',
                        );
                      },
                      focusNode: _focusNode,
                      route: '/',
                    ),
                  ),
                ),
                Text(_dateTime.toIso8601String()),
                SizedBox(
                  width: 200,
                  height: 80,
                  child: GazeButton(
                    properties: GazeButtonProperties(
                      text: 'Hallo Was machst du da?',
                      textColor: Colors.white,
                      route: '/',
                    ),
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GazeSwitchButton(
                    properties: GazeSwitchButtonProperties(
                      route: '/',
                      state: GazeSwitchButtonState(toggled: false),
                    ),
                    onToggled: (toggled) async {
                      return true;
                    },
                  ),
                ),
              ],
            ),
          ),
          GazePointerView(),
        ],
      ),
    );
  }
}

bool gazeInteractionPredicate(Rect itemRect, Rect gazePointerRect, String itemRoute, String currentRoute) {
  // gazePointerRect.center
  final intersection = itemRect.intersect(gazePointerRect);
  if (intersection.width.isNegative || intersection.height.isNegative) return false;
  // final intersectionArea = intersection.width * intersection.height;
  // final gazePointerArea = gazePointerRect.width * gazePointerRect.height;
  // itemRect.overlaps(gazePointerRect)
  // Check in case of Dialog
  // && intersectionArea >= gazePointerArea / 2
  if (itemRoute == currentRoute && itemRect.contains(gazePointerRect.center)) {
    return true;
  } else {
    return false;
  }
}
