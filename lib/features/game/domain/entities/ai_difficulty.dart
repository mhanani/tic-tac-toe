/// Represents the AI difficulty level
enum AiDifficulty {
  chill,
  expert;

  String get displayName {
    switch (this) {
      case AiDifficulty.chill:
        return 'Chill';
      case AiDifficulty.expert:
        return 'Expert';
    }
  }
}
