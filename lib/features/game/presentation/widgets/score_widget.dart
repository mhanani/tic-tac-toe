import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/features/game/presentation/providers/game_provider.dart';

/// Displays the score for a player or draws
class ScoreWidget extends StatelessWidget {
  final String label;
  final int score;
  final Color color;

  const ScoreWidget({
    super.key,
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTheme.bodyMedium.copyWith(color: color)),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            score.toString(),
            style: AppTheme.headingMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Row of all scores
class ScoreBoard extends ConsumerWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameNotifierProvider);
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScoreWidget(
          label: l10n.xWinsLabel,
          score: game.xWins,
          color: AppTheme.playerXColor,
        ),
        ScoreWidget(
          label: l10n.drawsLabel,
          score: game.draws,
          color: AppTheme.drawColor,
        ),
        ScoreWidget(
          label: l10n.oWinsLabel,
          score: game.oWins,
          color: AppTheme.playerOColor,
        ),
      ],
    );
  }
}
