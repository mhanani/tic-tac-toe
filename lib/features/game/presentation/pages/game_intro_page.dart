import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/game_mode.dart';
import '../providers/game_provider.dart';
import '../widgets/score_widget.dart';

/// Game intro page with mode selection
class GameIntroPage extends ConsumerStatefulWidget {
  const GameIntroPage({super.key});

  @override
  ConsumerState<GameIntroPage> createState() => _GameIntroPageState();
}

class _GameIntroPageState extends ConsumerState<GameIntroPage> {
  @override
  void initState() {
    super.initState();
    // Load saved scores on init
    Future.microtask(() {
      ref.read(gameNotifierProvider.notifier).loadScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            children: [
              const Spacer(),
              // Title
              const Text(
                'Tic Tac Toe',
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                'Choose your game mode',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingXxl),

              // Score board
              ScoreBoard(
                xWins: game.xWins,
                oWins: game.oWins,
                draws: game.draws,
              ),
              const SizedBox(height: AppTheme.spacingXxl),

              // Game mode buttons
              _GameModeButton(
                icon: Icons.people,
                title: 'Player vs Player',
                subtitle: 'Play with a friend locally',
                onTap: () => _startGame(GameMode.playerVsPlayer),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _GameModeButton(
                icon: Icons.smart_toy,
                title: 'Player vs AI',
                subtitle: 'Challenge the computer',
                onTap: () => _startGame(GameMode.playerVsAi),
              ),
              const Spacer(flex: 2),

              // Reset scores button
              if (game.xWins > 0 || game.oWins > 0 || game.draws > 0)
                TextButton.icon(
                  onPressed: () => _showResetDialog(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Scores'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(GameMode mode) {
    ref.read(gameNotifierProvider.notifier).startGame(mode);
    context.go(AppRoutes.game);
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Reset Scores?'),
        content: const Text('This will reset all win/loss/draw statistics.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(gameNotifierProvider.notifier).resetAll();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _GameModeButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _GameModeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.cardColor,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.headingSmall,
                    ),
                    Text(
                      subtitle,
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
