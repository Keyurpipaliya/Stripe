import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stripe Payment",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            var items = [
              {
                "productPrice": 4,
                "productName": "Apple",
                "qty": 5,
              },
              {
                "productPrice": 5,
                "productName": "Pinapple",
                "qty": 10,
              },
            ];

            await StripeService.stripePaymentCheckout(
              items,
              500,
              context,
              mounted,
              onSuccess: () {
                print("SUCCESS");
          },
              onCancel: () {
                print("Cancel");
          },
              onError: (e) {
              print("Error" +e.toString());
              },
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.white,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          child: Text("Checkout"),
        );
        ),
      );
  }
}
