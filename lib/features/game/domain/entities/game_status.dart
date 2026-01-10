/// Represents the current status of the game
enum GameStatus {
  notStarted,
  inProgress,
  xWins,
  oWins,
  draw;

  bool get isGameOver {
    return this == GameStatus.xWins ||
        this == GameStatus.oWins ||
        this == GameStatus.draw;
  }

  bool get hasWinner {
    return this == GameStatus.xWins || this == GameStatus.oWins;
  }
}
