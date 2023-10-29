part of 'paymob_payment.dart';

/// [PaymobApiException] describes the exception information when a Paymob API request fails.
class PaymobApiException implements Exception {
  PaymobApiException({
    this.error,
    this.message,
    this.function,
    this.statusCode,
  });

  /// The status code of the request.
  final int? statusCode;

  /// The error detail sent by the API.
  final String? message;

  /// The function that throws the error.
  final String? function;

  /// The error message that triggers a [PaymobApiException].
  final String? error;

  @override
  String toString() {
    final details = message != null
        ? 'with status code [$statusCode]: "$message"'
        : 'error "$error"';
    return 'PaymobApiException thrown by "$function" function with $details';
  }
}
