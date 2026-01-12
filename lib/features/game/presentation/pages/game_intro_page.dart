import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';
import 'package:tic_tac_toe/core/router/app_router.dart';
import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_button.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_dialog.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_icon.dart';
import 'package:tic_tac_toe/core/ui/widgets/custom_tile.dart';
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
      final notifier = ref.read(gameProvider.notifier);
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
    final game = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.transparent,
        actions: [
          CustomIcon.icon(
            Icons.settings,
            tooltip: context.l10n.settings,
            onTap: () => context.push(AppRoutes.settings),
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
              Text(
                context.l10n.appTitle,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamilyMarker,
                  fontSize: 52,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(context.l10n.chooseGameMode, style: AppTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingXxl),

              // Score board
              const ScoreBoard(),
              const SizedBox(height: AppTheme.spacingXxl),

              // Game mode buttons
              CustomTile(
                iconData: Icons.people,
                label: context.l10n.playerVsPlayer,
                subtitle: context.l10n.playerVsPlayerSubtitle,
                showChevron: true,
                onTap: _startPlayerVsPlayer,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              CustomTile(
                iconData: Icons.smart_toy,
                label: context.l10n.playerVsAi,
                subtitle: context.l10n.playerVsAiSubtitle,
                showChevron: true,
                onTap: _showDifficultyDialog,
              ),
              const Spacer(flex: 2),

              // Reset scores button
              if (game.xWins > 0 || game.oWins > 0 || game.draws > 0)
                CustomButton.text(
                  label: context.l10n.resetScores,
                  iconData: Icons.refresh,
                  onPressed: () => _showResetDialog(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPlayerVsPlayer() {
    ref.read(gameProvider.notifier).startGame(GameMode.playerVsPlayer);
    context.go(AppRoutes.game);
  }

  void _startPlayerVsAi(AiDifficulty difficulty) {
    ref
        .read(gameProvider.notifier)
        .startGame(GameMode.playerVsAi, difficulty: difficulty);
    context.go(AppRoutes.game);
  }

  void _showDifficultyDialog() {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (context) => CustomDialog(
        title: l10n.selectDifficulty,
        children: [
          CustomTile(
            label: l10n.difficultyChill,
            subtitle: l10n.difficultyChillSubtitle,
            showChevron: true,
            onTap: () {
              Navigator.pop(context);
              _startPlayerVsAi(AiDifficulty.chill);
            },
          ),
          const SizedBox(height: AppTheme.spacingSm),
          CustomTile(
            label: l10n.difficultyExpert,
            subtitle: l10n.difficultyExpertSubtitle,
            showChevron: true,
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
    showDialog<void>(
      context: context,
      builder: (context) => CustomDialog(
        title: l10n.resetScoresTitle,
        children: [
          Text(l10n.resetScoresMessage, style: AppTheme.bodyMedium),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: CustomButton.text(
                  label: l10n.cancel,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: CustomButton.primary(
                  label: l10n.reset,
                  onPressed: () {
                    ref.read(gameProvider.notifier).resetAll();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResumeGameDialog(Game savedGame) {
    final l10n = context.l10n;
    final modeName = savedGame.mode.localizedName(context);
    final router = GoRouter.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => CustomDialog(
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
                child: CustomButton.text(
                  label: l10n.delete,
                  onPressed: () {
                    ref.read(gameProvider.notifier).clearSavedGame();
                    Navigator.pop(dialogContext);
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: CustomButton.primary(
                  label: l10n.resume,
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await ref.read(gameProvider.notifier).loadSavedGame();
                    if (mounted) {
                      router.go(AppRoutes.game);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
