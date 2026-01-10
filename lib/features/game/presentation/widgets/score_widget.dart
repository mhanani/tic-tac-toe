import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

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
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(color: color),
          ),
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
class ScoreBoard extends StatelessWidget {
  final int xWins;
  final int oWins;
  final int draws;

  const ScoreBoard({
    super.key,
    required this.xWins,
    required this.oWins,
    required this.draws,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScoreWidget(
          label: 'X Wins',
          score: xWins,
          color: AppTheme.playerXColor,
        ),
        ScoreWidget(
          label: 'Draws',
          score: draws,
          color: AppTheme.drawColor,
        ),
        ScoreWidget(
          label: 'O Wins',
          score: oWins,
          color: AppTheme.playerOColor,
        ),
      ],
    );
  }
}
