import 'board.dart';
import 'game_mode.dart';
import 'game_status.dart';
import 'player.dart';

/// Represents the complete game state
class Game {
  final Board board;
  final Player currentPlayer;
  final GameStatus status;
  final GameMode mode;
  final int xWins;
  final int oWins;
  final int draws;

  const Game({
    required this.board,
    required this.currentPlayer,
    required this.status,
    required this.mode,
    this.xWins = 0,
    this.oWins = 0,
    this.draws = 0,
  });

  /// Creates a new game with default settings
  factory Game.initial({GameMode mode = GameMode.playerVsPlayer}) {
    return Game(
      board: Board.empty(),
      currentPlayer: Player.x,
      status: GameStatus.inProgress,
      mode: mode,
    );
  }

  /// Creates a new game with preserved scores
  Game newRound() {
    return Game(
      board: Board.empty(),
      currentPlayer: Player.x,
      status: GameStatus.inProgress,
      mode: mode,
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
    int? xWins,
    int? oWins,
    int? draws,
  }) {
    return Game(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      mode: mode ?? this.mode,
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
          xWins == other.xWins &&
          oWins == other.oWins &&
          draws == other.draws;

  @override
  int get hashCode =>
      board.hashCode ^
      currentPlayer.hashCode ^
      status.hashCode ^
      mode.hashCode ^
      xWins.hashCode ^
      oWins.hashCode ^
      draws.hashCode;
}
