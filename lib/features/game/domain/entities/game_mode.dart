import 'package:flutter/widgets.dart';

import 'package:tic_tac_toe/core/extensions/extensions.dart';

/// Represents the game mode
enum GameMode {
  playerVsPlayer,
  playerVsAi;

  /// Get the localized display name for this game mode
  String localizedName(BuildContext context) {
    switch (this) {
      case GameMode.playerVsPlayer:
        return context.l10n.playerVsPlayer;
      case GameMode.playerVsAi:
        return context.l10n.playerVsAi;
    }
  }
}
