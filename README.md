# Tic Tac Toe

A Flutter Tic Tac Toe game built with Clean Architecture and Riverpod.

## Features

- **Two Game Modes**: Player vs Player and Player vs AI
- **Smart AI**: Uses strategic move selection (win/block/center/corner strategy)
- **Score Tracking**: Persistent win/loss/draw statistics
- **Game Persistence**: Save and resume games using SharedPreferences
- **Modern UI**: Dark theme with smooth animations

## Architecture

This project follows **Clean Architecture** with a feature-based folder structure:

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # App widget with ProviderScope
├── core/
│   ├── router/                        # GoRouter configuration
│   ├── theme/                         # Design system
│   ├── ui/
│   │   ├── widgets/                   # Shared UI components (loading, error)
│   │   └── animations/                # Shared animations
│   └── utils/                         # Logger and utilities
└── features/
    └── game/
        ├── data/                      # Data layer (models, repositories, datasources)
        ├── domain/                    # Domain layer (entities, use cases, repository interfaces)
        └── presentation/              # Presentation layer (pages, widgets, providers)
```

### Key Architectural Decisions

- **Riverpod** for state management with `@riverpod` annotations
- **GoRouter** for navigation with redirect-based navigation logic
- **Freezed** for immutable data models with JSON serialization
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

# Run the app
fvm flutter run
```

## Dependencies

- `flutter_riverpod` - State management
- `riverpod_annotation` - Code generation for Riverpod
- `go_router` - Declarative routing
- `freezed_annotation` - Immutable classes
- `json_annotation` - JSON serialization
- `shared_preferences` - Local storage

## Project Structure Details

### Domain Layer

- **Entities**: `Player`, `Board`, `Game`, `GameMode`, `GameStatus`
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
