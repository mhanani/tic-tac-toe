import 'package:tic_tac_toe/features/game/domain/entities/ai_difficulty.dart';
import 'package:tic_tac_toe/features/game/domain/entities/board.dart';
import 'package:tic_tac_toe/features/game/domain/entities/game_mode.dart';
import 'package:tic_tac_toe/features/game/domain/entities/game_status.dart';
import 'package:tic_tac_toe/features/game/domain/entities/player.dart';

/// Represents the complete game state
class Game {
  final Board board;
  final Player currentPlayer;
  final GameStatus status;
  final GameMode mode;
  final AiDifficulty? difficulty;
  final int xWins;
  final int oWins;
  final int draws;

  const Game({
    required this.board,
    required this.currentPlayer,
    required this.status,
    required this.mode,
    this.difficulty,
    this.xWins = 0,
    this.oWins = 0,
    this.draws = 0,
  });

  /// Creates a new game with default settings
  factory Game.initial({
    GameMode mode = GameMode.playerVsPlayer,
    AiDifficulty? difficulty,
  }) {
    return Game(
      board: Board.empty(),
      currentPlayer: Player.x,
      status: GameStatus.inProgress,
      mode: mode,
      difficulty: difficulty,
    );
  }

  /// Creates a new game with preserved scores
  Game newRound() {
    return Game(
      board: Board.empty(),
      currentPlayer: Player.x,
      status: GameStatus.inProgress,
      mode: mode,
      difficulty: difficulty,
      xWins: xWins,
      oWins: oWins,
      draws: draws,
    );
  }

  /// Returns a copy with updated values
  Game copyWith({
    Board? board,
    Player? currentPlayer,
    GameStatus? status,
    GameMode? mode,
    AiDifficulty? difficulty,
    int? xWins,
    int? oWins,
    int? draws,
  }) {
    return Game(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
      xWins: xWins ?? this.xWins,
      oWins: oWins ?? this.oWins,
      draws: draws ?? this.draws,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Game &&
          runtimeType == other.runtimeType &&
          board == other.board &&
          currentPlayer == other.currentPlayer &&
          status == other.status &&
          mode == other.mode &&
          difficulty == other.difficulty &&
          xWins == other.xWins &&
          oWins == other.oWins &&
          draws == other.draws;

  @override
  int get hashCode =>
      board.hashCode ^
      currentPlayer.hashCode ^
      status.hashCode ^
      mode.hashCode ^
      difficulty.hashCode ^
      xWins.hashCode ^
      oWins.hashCode ^
      draws.hashCode;
}
