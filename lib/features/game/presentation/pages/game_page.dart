import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:tic_tac_toe/core/router/app_router.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_icon.dart';
import 'package:tic_tac_toe/core/ui/widgets/loading.dart';
import 'package:tic_tac_toe/features/game/domain/entities/entities.dart';
import 'package:tic_tac_toe/features/game/presentation/providers/game_provider.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/widgets.dart';

/// Main game page with the board
class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        leading: CustomIcon.icon(
          Icons.arrow_back,
          onTap: () => context.go(AppRoutes.home),
        ),
        title: Text(game.mode.localizedName(context)),
        actions: [
          CustomIcon.icon(
            Icons.refresh,
            tooltip: context.l10n.newGame,
            onTap: () => ref.read(gameProvider.notifier).resetGame(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              // Score board
              const ScoreBoard(),
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
                      ref.read(gameProvider.notifier).playMove(index),
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
    final color = currentPlayer.color ?? AppTheme.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
            isAiTurn ? context.l10n.aiTurn : context.l10n.playerTurn,
            style: AppTheme.bodyLarge.copyWith(color: color),
          ),
          if (isAiTurn) ...[
            const SizedBox(width: AppTheme.spacingSm),
            Loading(inline: true, size: 16.0, strokeWidth: 2.0, color: color),
          ],
        ],
      ),
    );
  }
}
