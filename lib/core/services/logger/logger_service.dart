import 'package:flutter/foundation.dart';

/// log ke levels.
enum LogLevel { debug, info, warning, error }

// debug mode me console par print karega and release mode me swallow kar lega
class AppLogger {
  AppLogger._();
  static void debug(String message, [String tag = 'DEBUG']) {
    _log(LogLevel.debug, message, tag);
  }
  static void info(String message, [String tag = 'INFO']) {
    _log(LogLevel.info, message, tag);
  }
  static void warning(String message, [String tag = 'WARNING']) {
    _log(LogLevel.warning, message, tag);
  }
  static void error(
      String message, [
        String tag = 'ERROR',
        Object? error,
        StackTrace? stackTrace,
      ]) {
    _log(LogLevel.error, message, tag);
    if (error != null && kDebugMode) {
      debugPrint('   └─ Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('   └─ StackTrace: $stackTrace');
    }
  }
  static void _log(LogLevel level, String message, String tag) {
    if (!kDebugMode && level != LogLevel.warning && level != LogLevel.error) {
      return;
    }
    final emoji = _emojiFor(level);
    debugPrint('$emoji [$tag] $message');
  }

  // doing this for no reason
  static String _emojiFor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '🔴';
    }
  }
}