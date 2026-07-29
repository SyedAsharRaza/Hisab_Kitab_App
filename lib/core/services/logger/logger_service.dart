import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

// centralize kar dia
// debug me console par show hoga and release mode me swallow kar lega
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
      debugPrint('   Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('   StackTrace: $stackTrace');
    }
  }

  static void _log(LogLevel level, String message, String tag) {
    if (!kDebugMode && level != LogLevel.warning && level != LogLevel.error) {
      return;
    }
    debugPrint('[${level.name.toUpperCase()}] [$tag] $message');
  }
}