import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:tic_tac_toe/features/game/data/models/game_model.dart';

/// Local data source for game persistence using SharedPreferences
abstract class GameLocalDataSource {
  Future<void> saveGame(GameModel game);
  Future<GameModel?> loadGame();
  Future<void> clearGame();
  Future<void> saveScores(int xWins, int oWins, int draws);
  Future<({int xWins, int oWins, int draws})> loadScores();
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  final SharedPreferences _prefs;

  static const _gameKey = 'saved_game';
  static const _xWinsKey = 'x_wins';
  static const _oWinsKey = 'o_wins';
  static const _drawsKey = 'draws';

  GameLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveGame(GameModel game) async {
    final json = jsonEncode(game.toJson());
    await _prefs.setString(_gameKey, json);
  }

  @override
  Future<GameModel?> loadGame() async {
    final json = _prefs.getString(_gameKey);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return GameModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearGame() async {
    await _prefs.remove(_gameKey);
  }

  @override
  Future<void> saveScores(int xWins, int oWins, int draws) async {
    await Future.wait([
      _prefs.setInt(_xWinsKey, xWins),
      _prefs.setInt(_oWinsKey, oWins),
      _prefs.setInt(_drawsKey, draws),
    ]);
  }

  @override
  Future<({int xWins, int oWins, int draws})> loadScores() async {
    return (
      xWins: _prefs.getInt(_xWinsKey) ?? 0,
      oWins: _prefs.getInt(_oWinsKey) ?? 0,
      draws: _prefs.getInt(_drawsKey) ?? 0,
    );
  }
}
