import 'package:tic_tac_toe/constants/app_constants.dart';
import 'package:tic_tac_toe/features/game/domain/entities/player.dart';

/// Represents the 3x3 game board
class Board {
  /// The cells of the board (indices 0 to kBoardSize*kBoardSize-1, row-major order)
  final List<Player> cells;

  const Board({required this.cells});

  /// Creates an empty board
  factory Board.empty() {
    return Board(cells: List.filled(kBoardSize * kBoardSize, Player.none));
  }

  /// Creates a board from a list of cells
  factory Board.fromCells(List<Player> cells) {
    assert(
      cells.length == kBoardSize * kBoardSize,
      'Board must have exactly ${kBoardSize * kBoardSize} cells',
    );
    return Board(cells: List.unmodifiable(cells));
  }

  /// Returns a new board with the move applied
  Board makeMove(int index, Player player) {
    final maxIndex = kBoardSize * kBoardSize - 1;
    if (index < 0 || index > maxIndex) {
      throw ArgumentError('Index must be between 0 and $maxIndex');
    }
    if (cells[index] != Player.none) {
      throw StateError('Cell $index is already occupied');
    }

    final newCells = List<Player>.from(cells);
    newCells[index] = player;
    return Board.fromCells(newCells);
  }

  /// Returns true if the cell at the given index is empty
  bool isCellEmpty(int index) => cells[index] == Player.none;

  /// Returns all empty cell indices
  List<int> get emptyCells {
    final empty = <int>[];
    final totalCells = kBoardSize * kBoardSize;
    for (var i = 0; i < totalCells; i++) {
      if (cells[i] == Player.none) {
        empty.add(i);
      }
    }
    return empty;
  }

  /// Returns true if the board is full
  bool get isFull => emptyCells.isEmpty;

  /// Gets the player at a specific cell
  Player getCell(int index) => cells[index];

  /// Winning combinations (indices)
  static const List<List<int>> winningCombinations = [
    [0, 1, 2], // Top row
    [3, 4, 5], // Middle row
    [6, 7, 8], // Bottom row
    [0, 3, 6], // Left column
    [1, 4, 7], // Middle column
    [2, 5, 8], // Right column
    [0, 4, 8], // Diagonal top-left to bottom-right
    [2, 4, 6], // Diagonal top-right to bottom-left
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Board &&
          runtimeType == other.runtimeType &&
          _listEquals(cells, other.cells);

  @override
  int get hashCode => Object.hashAll(cells);

  bool _listEquals(List<Player> a, List<Player> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
