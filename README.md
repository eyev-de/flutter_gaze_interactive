# Gaze Interactive

A Flutter UI component library purpose-built for eye tracking. It provides a complete set of interface elements - buttons, text fields, keyboards, scroll views, and more - that people can operate entirely with their eyes using a remote eye tracker like [Skyle](https://eyev.de).

## How It Works

Eye trackers send a stream of gaze coordinates - where on screen the user is looking. This library takes those coordinates and turns them into meaningful interactions: selecting buttons, typing text, scrolling through content, and navigating between screens.

The core challenge is that eye gaze is inherently imprecise compared to a finger tap or mouse click. Eyes jitter, trackers have noise, and "looking at something" is a fuzzy concept. Every design decision in this library addresses that reality.

### The Gaze Pointer

A visible circle follows the user's gaze on screen. This gives the user direct feedback about where the system thinks they're looking - essential because, unlike a mouse cursor, you can't feel where your eyes are pointing.

The pointer comes in three modes:
- **Passive**: A simple circle that follows gaze position, useful during browsing.
- **Active**: Shows a progress ring animation when the user fixates on an interactive element (see "Dwell Time Selection" below).
- **History**: Leaves a fading trail of past positions, helpful for calibration and debugging.

The pointer automatically fades out after a brief period of no movement to avoid cluttering the view.

### Dwell Time Selection

Since you can't "click" with your eyes, this library uses **dwell time** - looking at an element long enough triggers selection. When a user's gaze lands on a button, a visual animation begins (a filling progress bar, a rising bar, or a color fade). If the user keeps looking until the animation completes, the button activates. If they look away, the animation smoothly reverses.

This is the fundamental interaction pattern that replaces tapping or clicking. The animation serves two purposes: it tells the user "the system sees you looking here" and it gives them time to look away if they landed on the wrong element.

**Reselection acceleration** makes repeated selections faster. For example, when typing on the keyboard, each consecutive letter selection requires slightly less dwell time than the last. This dramatically improves typing speed for experienced users.

### Snapping

Eye trackers aren't pixel-precise. To compensate, interactive elements have an invisible extended radius around them. When the gaze pointer enters this radius, it can "snap" to the element's center, making selection easier even when gaze aim is slightly off. This reduces the frustration of trying to precisely target small elements.

### Routes

In any app with multiple screens, you don't want gaze accidentally activating buttons on a screen that's hidden behind a dialog or another page. Every interactive element registers with a **route** identifier (a simple string like `"home"` or `"settings"`). The system only considers elements whose route matches the currently active route. When the route changes - say, a keyboard dialog opens on top of the main screen - elements on the main screen become inert until the user navigates back.

This keeps the interaction model clean without requiring complex visibility tracking.

## Components

### Button

A button that responds to gaze with a selection animation. The user looks at it, sees the animation fill, and the action triggers on completion. Supports configurable animation styles, border radius, icons, text labels, and sound feedback.

### Keyboard

A full on-screen keyboard designed for eye gaze input. It opens as an overlay when a text field receives focus.

Key design choices for gaze usability:
- **Large key targets** with generous spacing to reduce mis-selections.
- **Reselectable keys** with acceleration - typing gets faster the more you type in a session.
- **Utility buttons** for common text operations: delete word, move cursor, select, copy, cut, paste, undo, redo.
- **Multiple layouts** supporting different languages (e.g., German, English) and modes (standard, email, symbols).
- **Speech-to-text** as an alternative input method for longer text.

### Text Field

A text input field that integrates with the gaze keyboard. When the user selects it, the keyboard opens automatically.

### Scroll View

Scrolling by gaze works through edge detection. The scroll area is divided into zones - looking at the top zone scrolls up, looking at the bottom scrolls down. The further toward the edge the user looks, the faster the scroll. Visual indicators (arrows) appear at the top and bottom to show when scrolling is possible and in which direction.

### Switch Button

A toggle switch operable by gaze. Look at it to flip between on and off states.

### Radio Button and Toggle Buttons

Selection controls for choosing between options, each fully operable through gaze dwell time.

### Date Picker

A calendar-style date picker with large, gaze-friendly touch targets.

### Gaze Pointer View

The pointer visualization itself, added as an overlay to the app. Configurable in size, color, opacity, and pointer type.

## Sound Feedback

Auditory feedback is important for gaze interaction because the user's eyes are already occupied with looking at targets - they can't simultaneously watch for visual confirmation elsewhere. A click sound plays on each successful selection (configurable between typewriter and keyboard sounds, with adjustable volume or mute).

## Architecture

```
GazeContext                        <- Wraps the entire app, provides gaze state
  |
  +-- GazeInteractiveState         <- Central coordinator
  |     |
  |     +-- Registered elements    <- All interactive widgets register here
  |     +-- Active elements        <- Currently gazed-at widgets
  |     +-- Settings               <- Dwell time, pointer size, sounds, etc.
  |     +-- Predicate function     <- Determines if gaze overlaps an element
  |
  +-- GazePointerView              <- Renders the pointer circle
  |     |
  |     +-- Receives gaze data from eye tracker
  |     +-- Updates pointer position
  |     +-- Detects fixation and snapping
  |
  +-- Interactive Widgets           <- Buttons, keyboard keys, switches, etc.
        |
        +-- GazeSelectionAnimation  <- Wraps each widget with dwell-time animation
        +-- Register/unregister with GazeInteractiveState on lifecycle
        +-- Receive onGazeEnter / onGazeLeave callbacks
```

The eye tracker feeds gaze coordinates into `GazeInteractiveState`. On every update, the system checks which registered elements overlap with the gaze pointer (accounting for shape, border radius, and the configurable overlap factor). Elements that match receive `onGazeEnter`; elements the gaze has left receive `onGazeLeave`. The selection animation listens to these events and manages the dwell-time countdown independently per element.

All settings - dwell time duration, pointer size, colors, sound volume, scroll speed, snapping radius - are persisted to device storage so users keep their preferences across sessions.

## Getting Started

Wrap your app with `GazeContext`, then use the provided widgets (`GazeButton`, `GazeTextField`, `GazeScrollable`, etc.) in place of standard Flutter widgets. Set `state.currentRoute` when navigating between screens. Add a `GazePointerView` overlay to visualize the pointer.

Feed gaze data from your eye tracker by calling `state.onGaze(Offset)` with screen coordinates.

## Usage Examples

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

Uses [Riverpod](https://riverpod.dev/) for state management. For Linux audio support, see [audioplayers Linux requirements](https://github.com/bluefireteam/audioplayers/blob/main/packages/audioplayers_linux/requirements.md).
