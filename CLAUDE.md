# CLAUDE.md - gaze_interactive

## Project Overview
Flutter package (`gaze_interactive`) by eyeV GmbH that provides gaze-interactive widgets for eye-tracker and pointer device integration. Used to build accessible UIs controllable via eye gaze.

## Tech Stack
- **Flutter** 3.41.4 (managed via FVM, see `.fvmrc`)
- **Dart SDK** >=3.8.0 <4.0.0
- **State management**: Riverpod (flutter_riverpod + riverpod_annotation)
- **Code generation**: freezed, riverpod_generator, json_serializable, build_runner
- **Other key deps**: audioplayers, speech_to_text, shared_preferences, clipboard_watcher

## Project Structure
```
lib/
  api.dart              # Public API barrel file (library gaze_interactive)
  src/
    state.dart          # Core GazeInteractiveState + Riverpod providers
    context.dart        # GazeContext widget
    core/               # Core utilities, models, extensions, constants
    widgets/
      button/           # GazeButton with selection animation
      keyboard/         # Full gaze keyboard with utility buttons, layouts, speech-to-text
      pointer/          # Gaze pointer view and state
      scrollable/       # Gaze-controlled scrolling
      switch_button/    # Toggle switch
      toggle_buttons/   # Toggle button group
      date_picker/      # Date picker
      view.dart         # GazeView base widget
      text_field.dart   # GazeTextField
      radio_button.dart # GazeRadioButton
example/                # Example app
test/                   # Tests
```

## Key Architecture
- `GazeInteractiveState` (in `lib/src/state.dart`) is the central state object. It manages gaze view registration/unregistration, pointer movement, fixation, and snapping.
- Provided via `gazeInteractiveProvider` (Riverpod Provider), initialized with SharedPreferences.
- User settings (duration, pointer color, sound, scroll factor, etc.) are persisted via SharedPreferences through local store notifiers in `lib/src/core/local_store_notifiers.dart`.
- Generated files (`*.g.dart`, `*.freezed.dart`) are created by `build_runner`.

## Common Commands
```bash
# Run code generation (after changing Riverpod providers, freezed models, etc.)
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Code Conventions
- Strict linting via extensive rule set in `analysis_options.yaml` (strict-casts, strict-raw-types enabled)
- `custom_lint` analyzer plugin is active
- Prefer single quotes
- Prefer relative imports within `lib/`
- Prefer `const` constructors
- All public APIs are exported through `lib/api.dart` with explicit `show` clauses
- File naming: snake_case with `.dart` extension; enums use `.enum.dart`, models use `.model.dart`, providers use `.provider.dart`
- Widget files sometimes use dot-notation: e.g., `copy.button.dart`, `pointer_view.provider.dart`
- Copyright header: `//  Gaze Interactive` / `//  Created by the eyeV app dev team.` / `//  Copyright eyeV GmbH. All rights reserved.`
- Generated files are committed to the repo

## Git Workflow
- Main branch: `main`
- Development branch: `dev`
- Feature branches typically named: `feature/*`, `fix/*`, or ticket-based like `SKYLEX-*`
- Commit style: lowercase, descriptive (e.g., `fix(gaze_interactive): use dispose instead of deactivate`)

## Important Notes
- `test/` is excluded from static analysis (see `analysis_options.yaml`)
- `example/` is excluded from build_runner targets (see `build.yaml`)
- The package supports macOS desktop (non-activating panel mode for eye tracker overlay)
- Audio assets are in `lib/assets/` (click.mp3, space_click.m4a)
