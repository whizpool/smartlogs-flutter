part of smart_logs;

class NotInitializationException implements Exception {
  String message;
  NotInitializationException(
      [this.message = 'Initialize Slog before using it']);
  @override
  String toString() {
    String result = 'NotInitializationException';
    return '$result: $message';
  }
}
