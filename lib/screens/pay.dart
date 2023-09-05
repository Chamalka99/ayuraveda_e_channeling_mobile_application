import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Gateway',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map paymentObject = {
    "sandbox": true, // true if using Sandbox Merchant ID
    "merchant_id": "1223679", // Replace your Merchant ID
    "merchant_secret":
    "MTkwODg0MDI5NTI4ODAxMjk2NzczNjcwMTIyNzIwMTY0NTMwMjQ1MA", // See step 4e
    "notify_url": "http://sample.com/notify",
    "order_id": "ItemNo12345",
    "items": "Test item roba",
    "amount": "50.00",
    "currency": "LKR",
    "first_name": "Saman",
    "last_name": "Perera",
    "email": "samanp@gmail.com",
    "phone": "0771234567",
    "address": "No.1, Galle Road",
    "city": "Colombo",
    "country": "Sri Lanka",
    "delivery_address": "No. 46, Galle road, Kalutara South",
    "delivery_city": "Kalutara",
    "delivery_country": "Sri Lanka",
    "custom_1": "",
    "custom_2": ""
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        PayHere.startPayment(paymentObject, (paymentId) {
          print("One Time Payment Success. Payment Id: $paymentId");
        }, (error) {
          print("One Time Payment Failed. Error: $error");
        }, () {
          print("One Time Payment Dismissed");
        });
      }),
    );
  }
}
