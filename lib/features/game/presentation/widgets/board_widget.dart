import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/cell_widget.dart';

/// The 3x3 game board widget
class BoardWidget extends StatelessWidget {
  final Board board;
  final GameStatus status;
  final void Function(int index) onCellTap;

  const BoardWidget({
    super.key,
    required this.board,
    required this.status,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final winningCells = _getWinningCells();

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppTheme.spacingSm,
            crossAxisSpacing: AppTheme.spacingSm,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return CellWidget(
              player: board.getCell(index),
              isWinningCell: winningCells.contains(index),
              onTap: board.isCellEmpty(index) && !status.isGameOver
                  ? () => onCellTap(index)
                  : null,
            );
          },
        ),
      ),
    );
  }

  Set<int> _getWinningCells() {
    if (!status.hasWinner) return {};

    for (final combo in Board.winningCombinations) {
      final a = board.getCell(combo[0]);
      final b = board.getCell(combo[1]);
      final c = board.getCell(combo[2]);

      if (a != Player.none && a == b && b == c) {
        return combo.toSet();
      }
    }
    return {};
  }
}
