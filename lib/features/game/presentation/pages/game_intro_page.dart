import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:tic_tac_toe/core/router/app_router.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_dialog.dart';
import 'package:tic_tac_toe/features/game/domain/entities/ai_difficulty.dart';
import 'package:tic_tac_toe/features/game/domain/entities/game.dart';
import 'package:tic_tac_toe/features/game/domain/entities/game_mode.dart';
import 'package:tic_tac_toe/features/game/presentation/providers/game_provider.dart';
import 'package:tic_tac_toe/features/game/presentation/widgets/score_widget.dart';

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
    // Load saved scores and check for ongoing game on init
    Future.microtask(() async {
      final notifier = ref.read(gameNotifierProvider.notifier);
      await notifier.loadScores();

      // Check if there's an ongoing game
      final savedGame = await notifier.checkForSavedGameInProgress();
      if (savedGame != null && mounted) {
        _showResumeGameDialog(savedGame);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: context.l10n.settings,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          child: Column(
            children: [
              const Spacer(),
              // Title
              Text(context.l10n.appTitle, style: AppTheme.headingLarge),
              const SizedBox(height: AppTheme.spacingSm),
              Text(context.l10n.chooseGameMode, style: AppTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingXxl),

              // Score board
              const ScoreBoard(),
              const SizedBox(height: AppTheme.spacingXxl),

              // Game mode buttons
              _GameModeButton(
                icon: Icons.people,
                title: context.l10n.playerVsPlayer,
                subtitle: context.l10n.playerVsPlayerSubtitle,
                onTap: _startPlayerVsPlayer,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              _GameModeButton(
                icon: Icons.smart_toy,
                title: context.l10n.playerVsAi,
                subtitle: context.l10n.playerVsAiSubtitle,
                onTap: _showDifficultyDialog,
              ),
              const Spacer(flex: 2),

              // Reset scores button
              if (game.xWins > 0 || game.oWins > 0 || game.draws > 0)
                TextButton.icon(
                  onPressed: () => _showResetDialog(),
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.resetScores),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPlayerVsPlayer() {
    ref.read(gameNotifierProvider.notifier).startGame(GameMode.playerVsPlayer);
    context.go(AppRoutes.game);
  }

  void _startPlayerVsAi(AiDifficulty difficulty) {
    ref
        .read(gameNotifierProvider.notifier)
        .startGame(GameMode.playerVsAi, difficulty: difficulty);
    context.go(AppRoutes.game);
  }

  void _showDifficultyDialog() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: l10n.selectDifficulty,
        children: [
          _DifficultyOption(
            title: l10n.difficultyChill,
            subtitle: l10n.difficultyChillSubtitle,
            onTap: () {
              Navigator.pop(context);
              _startPlayerVsAi(AiDifficulty.chill);
            },
          ),
          const SizedBox(height: AppTheme.spacingSm),
          _DifficultyOption(
            title: l10n.difficultyExpert,
            subtitle: l10n.difficultyExpertSubtitle,
            onTap: () {
              Navigator.pop(context);
              _startPlayerVsAi(AiDifficulty.expert);
            },
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(l10n.resetScoresTitle),
        content: Text(l10n.resetScoresMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(gameNotifierProvider.notifier).resetAll();
              Navigator.pop(context);
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }

  void _showResumeGameDialog(Game savedGame) {
    final l10n = context.l10n;
    final modeName = savedGame.mode.localizedName(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: l10n.resumeGameTitle,
        children: [
          Text(
            l10n.resumeGameMessage(modeName),
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    ref.read(gameNotifierProvider.notifier).clearSavedGame();
                    Navigator.pop(context);
                  },
                  child: Text(l10n.delete),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await ref
                        .read(gameNotifierProvider.notifier)
                        .loadSavedGame();
                    if (mounted) {
                      context.go(AppRoutes.game);
                    }
                  },
                  child: Text(l10n.resume),
                ),
              ),
            ],
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
                child: Icon(icon, color: AppTheme.primaryColor, size: 28),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.headingSmall),
                    Text(subtitle, style: AppTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.cardColor,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.bodyLarge),
                    Text(subtitle, style: AppTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
