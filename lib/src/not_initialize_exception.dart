part of '../smart_logs.dart';

/// When instance of smart logs call before initializing it. Then is error will be thrown
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
