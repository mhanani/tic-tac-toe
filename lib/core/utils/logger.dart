import 'dart:developer' as developer;

/// Log levels for the app logger
enum LogLevel { debug, info, warning, error }

/// Logger utility for the app
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
