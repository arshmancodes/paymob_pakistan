part of 'paymob_payment.dart';

/// [PaymobResponse] handles paymob api response
class PaymobResponse {
  /// [success] indicates whether the transaction was successful or not.
  bool success;

  /// [message] brief description of the transaction.
  String? message;

  /// [responseCode] response code for the transaction.
  String? responseCode;

  /// [responseCode] ID of the transaction.
  String? transactionID;

  PaymobResponse({
    this.message,
    this.responseCode,
    this.transactionID,
    required this.success,
  });

  /// factory constructor to build [PaymobResponse] from json
  factory PaymobResponse.fromJson(Map<String, dynamic> json) {
    return PaymobResponse(
      transactionID: json['id'],
      message: json['message'],
      success: json['success'] == 'true',
      responseCode: json['txn_response_code'],
    );
  }
}
