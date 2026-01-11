# Tic Tac Toe

A Flutter Tic Tac Toe game built with Clean Architecture and Riverpod.

## Features

- **Two Game Modes**: Player vs Player and Player vs AI
- **Smart AI**: Uses strategic move selection (win/block/center/corner strategy)
- **Score Tracking**: Persistent win/loss/draw statistics
- **Game Persistence**: Save and resume games using SharedPreferences
- **Internationalization**: English and French language support
- **Modern UI**: Dark theme with smooth animations

## Architecture

This project follows **Clean Architecture** with a feature-based folder structure:

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── extensions/                    # BuildContext extensions (l10n)
│   ├── l10n/                          # Localization (ARB files + generated)
│   ├── observer/                      # Riverpod & Navigator observers
│   ├── router/                        # GoRouter configuration
│   ├── theme/                         # Design system
│   ├── ui/
│   │   ├── widgets/                   # Shared UI components (loading, error)
│   │   └── animations/                # Shared animations
│   └── utils/                         # Logger and utilities
└── features/
    └── game/
        ├── data/                      # Models, repositories, datasources
        ├── domain/                    # Entities, use cases, repository interfaces
        └── presentation/              # Pages, widgets, providers
```

### Key Architectural Decisions

- **Riverpod** for state management with `@riverpod` annotations
- **GoRouter** for navigation with redirect-based navigation logic
- **Freezed** for immutable data models with JSON serialization
- **Flutter Localizations** for i18n with ARB files
- **Use Cases** for encapsulating business logic
- **Repository Pattern** with abstraction for testability

## Getting Started

### Prerequisites

- [FVM](https://fvm.app/) (Flutter Version Management)
- Flutter 3.38.6 (managed by FVM)

### Installation

```bash
# Install the correct Flutter version
fvm install

# Get dependencies
fvm flutter pub get

# Generate code (freezed, json_serializable, riverpod_generator)
fvm dart run build_runner build --delete-conflicting-outputs

# Generate localization files
fvm flutter gen-l10n

# Run the app
fvm flutter run
```

### Development Commands

```bash
# Watch for code changes and regenerate
fvm dart run build_runner watch --delete-conflicting-outputs

# Regenerate localizations after editing ARB files
fvm flutter gen-l10n

# Analyze code
fvm flutter analyze

# Run tests
fvm flutter test
```

## Localization

Translations are stored in `lib/core/l10n/` as ARB files:

- `app_en.arb` - English (template)
- `app_fr.arb` - French

To add a new language, create `app_xx.arb` and run `flutter gen-l10n`.

Usage in widgets:

```dart
import 'package:tic_tac_toe/core/extensions/extensions.dart';

Text(context.l10n.appTitle)
```

## Dependencies

- `flutter_riverpod` - State management
- `riverpod_annotation` - Code generation for Riverpod
- `go_router` - Declarative routing
- `freezed_annotation` - Immutable classes
- `json_annotation` - JSON serialization
- `shared_preferences` - Local storage
- `flutter_localizations` - Internationalization

## Project Structure Details

### Domain Layer

- **Entities**: `Player`, `Board`, `Game`, `GameMode`, `GameStatus`, `AiDifficulty`
- **Use Cases**: `PlayMove`, `CheckWinner`, `GetAiMove`, `SaveGame`, `LoadGame`
- **Repository Interface**: `GameRepository`

### Data Layer

- **Models**: `GameModel` (Freezed with JSON serialization)
- **Data Sources**: `GameLocalDataSource` (SharedPreferences wrapper)
- **Repository Implementation**: `GameRepositoryImpl`

### Presentation Layer

- **Pages**: `GameIntroPage`, `GamePage`, `GameOverPage`
- **Widgets**: `BoardWidget`, `CellWidget`, `ScoreWidget`
- **Providers**: `GameNotifier` for game state management
