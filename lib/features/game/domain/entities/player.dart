/// Represents a player in the Tic Tac Toe game
enum Player {
  x,
  o,
  none;

  /// Returns the opponent of the current player
  Player get opponent {
    switch (this) {
      case Player.x:
        return Player.o;
      case Player.o:
        return Player.x;
      case Player.none:
        return Player.none;
    }
  }

  /// Returns the display symbol for the player
  String get symbol {
    switch (this) {
      case Player.x:
        return 'X';
      case Player.o:
        return 'O';
      case Player.none:
        return '';
    }
  }
}
