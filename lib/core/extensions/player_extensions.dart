import 'package:flutter/material.dart';

import 'package:tic_tac_toe/core/theme/app_theme.dart';
import 'package:tic_tac_toe/features/game/domain/entities/player.dart';

extension PlayerColorExtension on Player {
  Color? get color => switch (this) {
    Player.x => AppTheme.playerXColor,
    Player.o => AppTheme.playerOColor,
    Player.none => null,
  };
}
