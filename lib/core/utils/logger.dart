import 'dart:developer' as developer;

/// Log levels for the app logger
enum LogLevel { debug, info, warning, error }

/// Simple logger utility for the app
class AppLogger {
  static LogLevel _minLevel = LogLevel.debug;

  /// Sets the minimum log level to display
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Logs a debug message
  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Logs an info message
  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Logs a warning message
  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Logs an error message with optional error and stack trace
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;

    final prefix = '[${level.name.toUpperCase()}]';
    final tagStr = tag != null ? '[$tag]' : '';
    final fullMessage = '$prefix$tagStr $message';

    developer.log(
      fullMessage,
      name: 'TicTacToe',
      error: error,
      stackTrace: stackTrace,
      level: _levelToInt(level),
    );
  }

  static int _levelToInt(LogLevel level) {
    return switch (level) {
      LogLevel.debug => 500,
      LogLevel.info => 800,
      LogLevel.warning => 900,
      LogLevel.error => 1000,
    };
  }
}
