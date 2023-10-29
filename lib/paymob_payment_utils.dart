part of 'paymob_payment.dart';

/// [PaymentType] currently support Jazzcash/Easypaisa/Card
///
/// [card] - card payment
///
/// [jazzcash] - jazzcash mobile wallet
///
/// [easypaisa] - easypaisa mobile wallet
enum PaymentType {
  /// [card] - card payment
  card,

  /// [jazzcash] - jazzcash mobile wallet
  jazzcash,

  /// [easypaisa] - easypaisa mobile wallet
  easypaisa,
}

/// [PaymobPakistan] accept Jazzcash/Easypaisa/Card Payments.
class PaymobPakistan {
  /// [PaymobPakistan] private constructor
  PaymobPakistan._();

  /// Singleton class [PaymobPakistan] get [instance]
  static final PaymobPakistan instance = PaymobPakistan._();

  /// Whether [instance] of [PaymobPakistan] initialized or not
  bool _isInitialized = false;

  /// [Dio] class instance
  final _dio = Dio(
    BaseOptions(
      /// [baseUrl] - for all api calls
      baseUrl: 'https://accept.paymobsolutions.com/api/',

      /// [headers] - for all api calls
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// [_iFrameID] - ID obtained from Paymob Developers iframes.
  late int _iFrameID;

  /// [_apiKey] - Unique merchant identifier obtained from the Paymob dashboard.
  late String _apiKey;

  /// [_iFrameURL] - Url for card payment.
  late String _iFrameURL;

  /// [_cardIntegrationID] - Card Integration ID.
  late int _cardIntegrationID;

  /// [userTokenExpiration] - Expiration time of the payment token in seconds (default is 3600 seconds).
  late int _userTokenExpiration;
  
  /// [_jazzcashIntegrationID] - JazzCash Integration ID.
  late int _jazzcashIntegrationID;
  
  /// [_easypaisaIntegrationID] - JazzCash Integration ID.
  late int _easypaisaIntegrationID;

  /// [_mobileAccountiFrame] - Url for mobile wallet jazzcash/easypaisa payment.
  late String _mobileAccountiFrame;

  /// Initialize the [PaymobPakistan] instance.
  ///
  /// Call this method to set up required parameters of [PaymobPakistan].
  ///
  /// [apiKey] - Unique merchant identifier obtained from the Paymob dashboard.
  ///
  /// [integrationID] - Online Card ID obtained from Paymob Developers section.
  ///
  /// [iFrameID] - ID obtained from Paymob Developers iframes.
  ///
  /// [jazzcashIntegrationID] - JazzCash Integration ID.
  ///
  /// [easypaisaIntegrationID] - EasyPaisa Integration ID.
  ///
  /// [userTokenExpiration] - Expiration time of the payment token in seconds (default is 3600 seconds).
  Future<bool> initialize({
    /// It is a unique identifier for the merchant which used to authenticate your requests calling any of Accept's API.
    /// from dashboard Select Settings -> Account Info -> API Key
    required String apiKey,

    /// from dashboard Select Developers -> Payment Integrations -> Online Card ID
    required int integrationID,

    /// from paymob Select Developers -> iframes
    required int iFrameID,
    required int jazzcashIntegrationId,
    required int easypaisaIntegrationID,

    /// The expiration time of this payment token in seconds.
    /// (The maximum is 3600 seconds which is an hour)
    int userTokenExpiration = 3600,
  }) async {
    if (_isInitialized) return true;

    _apiKey = apiKey;
    _iFrameID = iFrameID;
    _cardIntegrationID = integrationID;
    _userTokenExpiration = userTokenExpiration;
    _jazzcashIntegrationID = jazzcashIntegrationId;
    _easypaisaIntegrationID = easypaisaIntegrationID;
    _mobileAccountiFrame = 'https://pakistan.paymob.com/iframe/';
    _iFrameURL =
        'https://pakistan.paymob.com/api/acceptance/iframe/$_iFrameID?token=';

    /// _dio.options.validateStatus = (status) => true;

    _isInitialized = true;
    return _isInitialized;
  }

  /// Get authentication token,
  /// which is valid for one hour from the creation time.
  Future<String> _getAuthToken() async {
    try {
      final response = await _dio.post(
        'auth/tokens',
        data: {
          'api_key': _apiKey,
        },
      );
      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  /// At this step,
  /// you will register an order to Accept's database,
  /// so that you can pay for it later using a transaction.
  Future<int> _addOrder({
    required List items,
    required String amount,
    required String currency,
    required String authToken,
  }) async {
    try {
      final response = await _dio.post(
        'ecommerce/orders',
        data: {
          'items': items,
          'currency': currency,
          'amount_cents': amount,
          'auth_token': authToken,
          'delivery_needed': 'false',
        },
      );
      return response.data['id'];
    } catch (e) {
      rethrow;
    }
  }

  /// At this step, you will obtain a payment_key token.
  /// This key will be used to authenticate your payment request.
  /// It will be also used for verifying your transaction request metadata.
  Future<String> _getPurchaseToken({
    required int orderID,
    required String amount,
    required String currency,
    required String authToken,
    required PaymentType paymentType,
    required PaymobBillingData billingData,
  }) async {
    final response = await _dio.post(
      'acceptance/payment_keys',
      data: {
        'currency': currency,
        'auth_token': authToken,
        'order_id': orderID.toString(),
        'lock_order_when_paid': 'false',
        'amount_cents': int.parse(amount),
        'expiration': _userTokenExpiration,
        'billing_data': billingData.toJson(),
        'integration_id': _getIntegrationId(paymentType),
      },
    );
    final message = response.data['message'];
    if (message != null) {
      throw Exception(message);
    }
    return response.data['token'];
  }

  /// Get payment integration id using [PaymentType]
  int? _getIntegrationId(PaymentType paymentType){
    return (paymentType == PaymentType.card)
            ? _cardIntegrationID
            : (paymentType == PaymentType.easypaisa)
                ? _easypaisaIntegrationID
                : (paymentType == PaymentType.jazzcash)
                    ? _jazzcashIntegrationID
                    : null;
  }

  /// Pay for an order with the specified payment type.
  ///
  /// Opens a WebView at Paymob redirectedURL to accept user payment info.
  ///
  /// [context] - BuildContext for navigation to WebView.
  ///
  /// [currency] - Currency for payment.
  ///
  /// [amountInCents] - Payment amount in cents.
  ///
  /// [onPayment] - Optional callback for handling payment response.
  ///
  /// [paymentType] - Payment type (card, easypaisa, jazzcash).
  ///
  /// [items] - List of JSON objects containing purchase contents.
  ///
  /// [billingData] - Billing data related to the customer.
  Future<PaymobResponse?> pay({
    /// [context] - BuildContext for navigation to WebView
    required BuildContext context,

    /// [currency] - Currency for payment.
    required String currency,

    /// [amountInCents] - Payment amount in cents.
    /// EX: 20000 is an 200 PKR
    required String amountInCents,

    /// [onPayment] - Optional callback for handling payment response.
    void Function(PaymobResponse response)? onPayment,

    /// [paymentType] - Payment type (card, easypaisa, jazzcash).
    required PaymentType paymentType,

    /// [items] - List of JSON objects containing purchase contents.
    List? items,

    /// [billingData] - Billing data related to the customer.
    PaymobBillingData? billingData,
  }) async {
    if (!_isInitialized) {
      throw Exception(
          'PaymobPayment is not initialized call:`PaymobPayment.instance.initialize`');
    }

    /// [authToken] - get auth token
    final authToken = await _getAuthToken();

    /// [orderID] - get order id
    final orderID = await _addOrder(
      currency: currency,
      authToken: authToken,
      amount: amountInCents,
      items: items ?? [],
    );

    /// [purchaseToken] - get purchase token
    final purchaseToken = await _getPurchaseToken(
      orderID: orderID,
      currency: currency,
      authToken: authToken,
      amount: amountInCents,
      paymentType: paymentType,
      billingData: billingData ?? PaymobBillingData(),
    );
    if (context.mounted) {
      if (paymentType == PaymentType.card) {
        final response = await PaymobIFrame.show(
          context: context,
          onPayment: onPayment,
          redirectURL: _iFrameURL + purchaseToken,
        );
        return response;
      } else {
        final response = await PaymobIFrame.show(
          context: context,
          onPayment: onPayment,
          redirectURL: _mobileAccountiFrame + purchaseToken,
        );
        return response;
      }
    }
    return null;
  }
}
