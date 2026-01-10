/// Represents the game mode
enum GameMode {
  playerVsPlayer,
  playerVsAi;

  String get displayName {
    switch (this) {
      case GameMode.playerVsPlayer:
        return 'Player vs Player';
      case GameMode.playerVsAi:
        return 'Player vs AI';
    }
  }
}
