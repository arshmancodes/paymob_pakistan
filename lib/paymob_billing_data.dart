part of 'paymob_payment.dart';

/// [PaymobBillingData] represent user's billing details
class PaymobBillingData {
  /// user info
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;

  /// user address
  String? floor;
  String? street;
  String? building;
  String? apartment;
  
  /// user location
  String? city;
  String? state;
  String? country;
  String? postalCode;

  /// [shippingMethod]
  String? shippingMethod;

  PaymobBillingData({
    this.city,
    this.floor,
    this.email,
    this.state,
    this.street,
    this.country,
    this.firstName,
    this.lastName,
    this.building,
    this.apartment,
    this.postalCode,
    this.phoneNumber,
    this.shippingMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city ?? 'NA',
      'floor': floor ?? 'NA',
      'state': state ?? 'NA',
      'street': street ?? 'NA',
      'country': country ?? 'NA',
      'email': email ?? 'Unknown',
      'building': building ?? 'NA',
      'apartment': apartment ?? 'NA',
      'postal_code': postalCode ?? 'NA',
      'first_name': firstName ?? 'Unknown',
      'last_name': lastName ?? 'Unknown',
      'phone_number': phoneNumber ?? 'Unknown',
      'shipping_method': shippingMethod ?? 'NA',
    };
  }
}
