# Gaze Interactive

A Flutter package for gaze interactive widgets, designed for eye-trackers like Skyle for iPad or Skyle for Windows, but compatible with any pointing device.

## Features

### Widgets

- **GazeButton** - Button with gaze selection animation
- **GazeSwitchButton** - Toggle switch controlled by gaze
- **GazeRadioButton** - Radio button for gaze selection
- **GazeToggleButtons** - Group of toggle buttons
- **GazeTextField** - Text input field with on-screen keyboard support
- **GazeKeyboard** - Full on-screen keyboard with multiple layouts, languages, and utility buttons (copy, paste, undo, redo, cursor movement, delete, speech-to-text)
- **GazeDatePicker** - Date picker dialog
- **GazeScrollable** - Scroll view with directional gaze indicators (look up/down to scroll)
- **GazePointerView** - Visual feedback of gaze position with multiple pointer types (passive, active, history)
- **GazeView** - Base view for gaze interaction

### Core

- Configurable gaze pointer size and type
- Route-based gaze interaction predicate system
- Shape overlap detection with configurable inner factor
- Shared preferences integration for persistent settings
- Sound feedback support

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  gaze_interactive:
    git:
      url: https://github.com/eyev-de/flutter_gaze_interactive.git
```

## Usage

### Setup

```dart
import 'package:gaze_interactive/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final state = GazeInteractiveState(sharedPreferences: prefs);
  runApp(GazeContext(state: state, child: const MyApp()));
}
```

### GazeButton

```dart
GazeButton(
  color: Colors.blue,
  properties: GazeButtonProperties(
    text: const Text('Tap me'),
    route: '/',
  ),
  onTap: () => print('tapped'),
)
```

### GazeTextField with Keyboard

```dart
GazeTextField(
  route: '/',
  focusNode: focusNode,
  controller: controller,
  onChanged: (value) {},
  properties: GazeTextFieldProperties(
    style: const TextStyle(fontSize: 20),
    inputDecoration: const InputDecoration(hintText: 'Search'),
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
      ),
      () => state.currentRoute = '/dialog',
      (ctx) => Navigator.of(ctx).pop(),
      (ctx) => state.currentRoute = '/',
    );
  },
)
```

### GazeSwitchButton

```dart
GazeSwitchButton(
  route: '/',
  value: true,
  onChanged: (value) {},
  properties: GazeSwitchButtonProperties(gazeInteractive: true),
)
```

### GazeScrollable

```dart
GazeScrollable(
  route: '/',
  child: ListView(
    children: [...],
  ),
)
```

### GazePointerView

```dart
GazePointerView(
  state: GazePointerState(type: GazePointerType.passive),
)
```

## Requirements

- Flutter >= 3.38.0
- Dart SDK >= 3.8.0

## Dependencies

This package uses [Riverpod](https://riverpod.dev/) for state management.

For Linux audio support, see [audioplayers Linux requirements](https://github.com/bluefireteam/audioplayers/blob/main/packages/audioplayers_linux/requirements.md).
