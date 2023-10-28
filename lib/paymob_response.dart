part of 'paymob_payment.dart';

class PaymobResponse {
  bool success;
  String? message;
  String? responseCode;
  String? transactionID;

  PaymobResponse({
    this.message,
    this.responseCode,
    this.transactionID,
    required this.success,
  });

  factory PaymobResponse.fromJson(Map<String, dynamic> json) {
    return PaymobResponse(
      transactionID: json['id'],
      message: json['message'],
      success: json['success'] == 'true',
      responseCode: json['txn_response_code'],
    );
  }
}
