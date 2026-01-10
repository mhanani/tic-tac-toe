import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'game_model.freezed.dart';
part 'game_model.g.dart';

/// Data model for serializing game state to/from JSON
@freezed
abstract class GameModel with _$GameModel {
  const factory GameModel({
    required List<int> board,
    required int currentPlayer,
    required int status,
    required int mode,
    @Default(0) int xWins,
    @Default(0) int oWins,
    @Default(0) int draws,
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);
}

/// Extension to convert between domain and data models
extension GameModelX on GameModel {
  /// Converts the data model to a domain entity
  Game toEntity() {
    return Game(
      board: Board.fromCells(
        board.map((i) => Player.values[i]).toList(),
      ),
      currentPlayer: Player.values[currentPlayer],
      status: GameStatus.values[status],
      mode: GameMode.values[mode],
      xWins: xWins,
      oWins: oWins,
      draws: draws,
    );
  }
}

extension GameX on Game {
  /// Converts the domain entity to a data model
  GameModel toModel() {
    return GameModel(
      board: board.cells.map((p) => p.index).toList(),
      currentPlayer: currentPlayer.index,
      status: status.index,
      mode: mode.index,
      xWins: xWins,
      oWins: oWins,
      draws: draws,
    );
  }
}
