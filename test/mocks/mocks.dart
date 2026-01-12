import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tic_tac_toe/features/game/data/datasources/game_local_datasource.dart';
import 'package:tic_tac_toe/features/game/data/models/game_model.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/domain/repositories/game_repository.dart';
import 'package:tic_tac_toe/features/settings/data/datasources/settings_local_datasource.dart';

// Repository Mocks
class MockGameRepository extends Mock implements GameRepository {}

// Data Source Mocks
class MockGameLocalDataSource extends Mock implements GameLocalDataSource {}

class MockSettingsLocalDataSource extends Mock
    implements SettingsLocalDataSource {}

// SharedPreferences Mock
class MockSharedPreferences extends Mock implements SharedPreferences {}

// Fallback Values for use with mocktail
class FakeGame extends Fake implements Game {}

class FakeGameModel extends Fake implements GameModel {}

/// Register all fallback values for mocktail
void registerFallbackValues() {
  registerFallbackValue(FakeGame());
  registerFallbackValue(FakeGameModel());
}
