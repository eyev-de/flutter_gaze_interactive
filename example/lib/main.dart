import 'package:flutter/material.dart';
import 'package:gaze_interactive/gaze_interactive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaze Interactive Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
                SizedBox(
                  width: 200,
                  height: 80,
                  child: GazeTextField(
                    properties: GazeTextFieldProperties(
                      maxLength: 30,
                      placeholder: 'Name',
                      placeholderStyle: const TextStyle(fontSize: 20, color: Colors.white),
                      padding: const EdgeInsets.all(20),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    gazeInteractiveKey: GlobalKey(),
                    controller: _controller,
                    onChanged: (value) {},
                    onFocus: () {},
                    focusNode: _focusNode,
                    route: '/',
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 80,
                  child: GazeButton(
                    properties: GazeButtonProperties(
                      key: GlobalKey(),
                      route: '/',
                      text: 'Hallo Was machst du da?',
                      textColor: Colors.black,
                    ),
                    onTap: () {
                      print('LOL');
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
  final intersectionArea = intersection.width * intersection.height;
  final gazePointerArea = gazePointerRect.width * gazePointerRect.height;
  // itemRect.overlaps(gazePointerRect)
  // Check in case of Dialog
  // && intersectionArea >= gazePointerArea / 2
  if (itemRoute == currentRoute && itemRect.contains(gazePointerRect.center)) {
    return true;
  } else {
    return false;
  }
}
