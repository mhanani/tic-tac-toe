import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/entities.dart';
import '../providers/game_provider.dart';
import '../widgets/widgets.dart';

/// Main game page with the board
class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text(game.mode.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(gameNotifierProvider.notifier).resetGame(),
            tooltip: 'New Game',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              // Score board
              ScoreBoard(
                xWins: game.xWins,
                oWins: game.oWins,
                draws: game.draws,
              ),
              const Spacer(),

              // Current player indicator
              _CurrentPlayerIndicator(
                currentPlayer: game.currentPlayer,
                mode: game.mode,
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Game board
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: BoardWidget(
                  board: game.board,
                  status: game.status,
                  onCellTap: (index) =>
                      ref.read(gameNotifierProvider.notifier).playMove(index),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentPlayerIndicator extends StatelessWidget {
  final Player currentPlayer;
  final GameMode mode;

  const _CurrentPlayerIndicator({
    required this.currentPlayer,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final isAiTurn = mode == GameMode.playerVsAi && currentPlayer == Player.o;
    final color = currentPlayer == Player.x
        ? AppTheme.playerXColor
        : AppTheme.playerOColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentPlayer.symbol,
            style: AppTheme.headingMedium.copyWith(color: color),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Text(
            isAiTurn ? "AI's Turn" : "'s Turn",
            style: AppTheme.bodyLarge.copyWith(color: color),
          ),
          if (isAiTurn) ...[
            const SizedBox(width: AppTheme.spacingSm),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
