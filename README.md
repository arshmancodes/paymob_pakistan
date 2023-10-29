# paymob_pakistan

Easily accept Jazzcash/Easypaisa/Card Payments through [Paymob Pakistan](https://paymob.pk) in your Flutter app.

<!-- ![Example](https://github.com/AhmedAbogameel/paymob_payment/blob/master/example.gif) -->

## :rocket: Installation

Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
paymob_pakistan : ^1.1.0
```

## :hammer: Initialization

```dart
PaymobPakistan.instance.initialize(
  apiKey: "", // from dashboard Select Settings -> Account Info -> API Key 
  jazzcashIntegrationId: 123123, // From Dashboard select Developers -> Payment Integrations -> JazzCash Integration ID
  easypaisaIntegrationID: 123123,  // From Dashboard select Developers -> Payment Integrations -> EasyPaisa Integration ID
  integrationID: 123456, // from dashboard Select Developers -> Payment Integrations -> Online Card ID 
  iFrameID: 123456, // from paymob Select Developers -> iframes 
);
```

## :bookmark: Usage

```dart
final PaymobResponse? response = await PaymobPakistan.instance.pay(
  context: context,
  currency: "PKR",
  paymentType: PaymentType.card, // or you can User paymentType: PaymentType.jazzcash OR PaymentType.easypaisa
  amountInCents: "50000", // 500 PKR
  onPayment: (response) => setState(() => this.response = response), // Optional
)
```

## :incoming_envelope: PaymobResponse

| Variable      | Type    | Description          |
| ------------- |---------| -------------------- |
| success       | bool    | Indicates if the transaction was successful or not |
| transactionID | String? | The ID of the transaction |
| responseCode  | String? | The response code for the transaction |
| message       | String? | A brief message describing the transaction |


## :test_tube: Testing Cards

#### :white_check_mark: Successful payment

| Variable     | Description      |
|--------------|------------------|
| Card Number  | 5123456789012346 |
| Expiry Month | 12               |
| Expiry Year  | 25               |
| CVV          | 123              |
| Name         | Test Account     |


#### :negative_squared_cross_mark: Declined payment

Change cvv to 111 or expiry year to 20

##  Credits

> All API Credits goes to [Paymob Pakistan](https://paymob.pk)

> :pushpin: Note :
> 
> Visit [Paymob Pakistan](https://paymob.pk) to get your PayMob account for accepting Digital Payments on your Flutter Application.
> May be you have to contact paymob support to activate your test card 
