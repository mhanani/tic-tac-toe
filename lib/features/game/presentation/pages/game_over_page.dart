import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/entities.dart';
import '../providers/game_provider.dart';
import '../widgets/widgets.dart';

/// Game over page showing the result
class GameOverPage extends ConsumerWidget {
  const GameOverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - AppTheme.spacingLg * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),

                    // Main content
                    Column(
                      children: [
                        // Result
                        _GameResult(status: game.status),
                        const SizedBox(height: AppTheme.spacingXxl),

                        // Final board state
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: BoardWidget(
                            board: game.board,
                            status: game.status,
                            onCellTap: (_) {},
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXxl),

                        // Updated scores
                        ScoreBoard(
                          xWins: game.xWins,
                          oWins: game.oWins,
                          draws: game.draws,
                        ),
                      ],
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.only(top: AppTheme.spacingLg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => context.go(AppRoutes.home),
                            icon: const Icon(Icons.home),
                            label: const Text('Home'),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(gameNotifierProvider.notifier)
                                  .resetGame();
                              context.go(AppRoutes.game);
                            },
                            icon: const Icon(Icons.replay),
                            label: const Text('Play Again'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GameResult extends StatelessWidget {
  final GameStatus status;

  const _GameResult({required this.status});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle, color) = switch (status) {
      GameStatus.xWins => (
        Icons.emoji_events,
        'X Wins!',
        'Congratulations!',
        AppTheme.playerXColor,
      ),
      GameStatus.oWins => (
        Icons.emoji_events,
        'O Wins!',
        'Congratulations!',
        AppTheme.playerOColor,
      ),
      GameStatus.draw => (
        Icons.handshake,
        "It's a Draw!",
        'Well played, both!',
        AppTheme.drawColor,
      ),
      _ => (Icons.help, 'Game Over', '', AppTheme.textSecondary),
    };

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 3),
          ),
          child: Icon(icon, size: 64, color: color),
        ),
        const SizedBox(height: AppTheme.spacingLg),
        Text(title, style: AppTheme.headingLarge.copyWith(color: color)),
        if (subtitle.isNotEmpty) Text(subtitle, style: AppTheme.bodyMedium),
      ],
    );
  }
}
