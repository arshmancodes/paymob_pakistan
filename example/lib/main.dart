// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:paymob_pakistan/paymob_payment.dart';

void main() {
  // Testing info do not use in your app
  PaymobPakistan.instance.initialize(
    apiKey: "{YOUR API KEY HERE}",
    integrationID: 123456,
    iFrameID: 123456,
    jazzcashIntegrationId: 123456,
    easypaisaIntegrationID: 123456,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF007aec),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF007aec)),
        )),
      ),
      debugShowCheckedModeBanner: false,
      home: const PaymentView(),
    );
  }
}

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  PaymobResponse? response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymob'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network('https://paymob.pk/images/paymobLogo.png'),
            const SizedBox(height: 24),
            if (response != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Success ==> ${response?.success}"),
                  const SizedBox(height: 8),
                  Text("Transaction ID ==> ${response?.transactionID}"),
                  const SizedBox(height: 8),
                  Text("Message ==> ${response?.message}"),
                  const SizedBox(height: 8),
                  Text("Response Code ==> ${response?.responseCode}"),
                  const SizedBox(height: 16),
                ],
              ),
            Column(
              children: [
                // ElevatedButton(
                //   child: const Text('Pay with Jazzcash'),
                //   onPressed: () => PaymobPakistan.instance.pay(
                //     context: context,
                //     currency: "PKR",
                //     amountInCents: "100",
                //     paymentType: PaymentType.jazzcash,
                //     onPayment: (response) => setState(() => this.response = response),
                //   ),
                // ),
                ElevatedButton(
                    child: const Text('Pay with Jazzcash'),
                    onPressed: () async {
                      try {
                        PaymentInitializationResult response = await PaymobPakistan.instance.initializePayment(
                          currency: "PKR",
                          amountInCents: "100",
                        );

                        String authToken = response.authToken;
                        int orderID = response.orderID;

                        PaymobPakistan.instance.makePayment(context,
                            currency: "PKR",
                            amountInCents: "100",
                            paymentType: PaymentType.jazzcash,
                            authToken: authToken,
                            orderID: orderID,
                            onPayment: (response) => setState(() => this.response = response));
                      } catch (err) {
                        rethrow;
                      }
                    }),
                // ElevatedButton(
                //   child: const Text('Pay with Easypaisa'),
                //   onPressed: () => PaymobPakistan.instance.pay(
                //     context: context,
                //     currency: "PKR",
                //     amountInCents: "100",
                //     billingData: PaymobBillingData(
                //         email: "test@test.com",
                //         firstName: "Arshman",
                //         lastName: "Afzal",
                //         phoneNumber: "+921234567890",
                //         apartment: "NA",
                //         building: "NA",
                //         city: "NA",
                //         country: "Pakistan",
                //         floor: "NA",
                //         postalCode: "NA",
                //         shippingMethod: "Online",
                //         state: "NA",
                //         street: "NA"),
                //     paymentType: PaymentType.easypaisa,
                //     onPayment: (response) =>
                //         setState(() => this.response = response),
                //   ),
                // ),
                // ElevatedButton(
                //   child: const Text('Pay with Card'),
                //   onPressed: () => PaymobPakistan.instance.pay(
                //     context: context,
                //     currency: "PKR",
                //     amountInCents: "100",
                //     paymentType: PaymentType.card,
                //     onPayment: (response) =>
                //         setState(() => this.response = response),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
