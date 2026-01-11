import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/features/game/domain/entities/player.dart';

/// A single cell on the game board
class CellWidget extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;
  final bool isWinningCell;

  const CellWidget({
    super.key,
    required this.player,
    this.onTap,
    this.isWinningCell = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isWinningCell
              ? AppTheme.primaryColor.withOpacity(0.3)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color:
                isWinningCell ? AppTheme.primaryColor : AppTheme.surfaceColor,
            width: 2,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: player == Player.none
                ? const SizedBox.shrink()
                : Text(
                    player.symbol,
                    key: ValueKey(player),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: player == Player.x
                          ? AppTheme.playerXColor
                          : AppTheme.playerOColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
