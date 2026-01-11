import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Log levels for the app logger
enum LogLevel { debug, info, warning, error }

/// ANSI color codes for terminal output
class _AnsiColors {
  static const String reset = '\x1B[0m';
  static const String cyan = '\x1B[36m';
  static const String blue = '\x1B[34m';
  static const String yellow = '\x1B[33m';
  static const String red = '\x1B[31m';
}

/// Logger utility for the app in debug mode

class Logger {
  LogLevel _minLevel = LogLevel.debug;

  /// Sets the minimum log level to display
  void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Logs a debug message
  void d(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Logs an info message
  void i(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Logs a warning message
  void w(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Logs an error message with optional error and stack trace
  void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Only log in debug mode
    if (!kDebugMode) return;
    if (level.index < _minLevel.index) return;

    final emoji = _emojiForLevel(level);
    final color = _colorForLevel(level);
    final tagStr = tag != null ? '[$tag] ' : '';
    final fullMessage =
        '$color$emoji ${level.name.toUpperCase()} $tagStr$message${_AnsiColors.reset}';

    developer.log(
      fullMessage,
      name: 'TicTacToe',
      error: error,
      stackTrace: stackTrace,
      level: _levelToInt(level),
    );
  }

  String _emojiForLevel(LogLevel level) {
    return switch (level) {
      LogLevel.debug => '🐛',
      LogLevel.info => '💡',
      LogLevel.warning => '⚠️',
      LogLevel.error => '❌',
    };
  }

  String _colorForLevel(LogLevel level) {
    return switch (level) {
      LogLevel.debug => _AnsiColors.cyan,
      LogLevel.info => _AnsiColors.blue,
      LogLevel.warning => _AnsiColors.yellow,
      LogLevel.error => _AnsiColors.red,
    };
  }

  int _levelToInt(LogLevel level) {
    return switch (level) {
      LogLevel.debug => 500,
      LogLevel.info => 800,
      LogLevel.warning => 900,
      LogLevel.error => 1000,
    };
  }
}

/// Global logger instance
final logger = Logger();
