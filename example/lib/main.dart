import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> doCheckout() async {
    try {
      await HyperpayService.getHyperpayResponse(
        arguments: {
          "checkoutId": "C983B64E8AEDDC9FC769E244DB8ECA19.uat01-vm-tx01",
          "shopperResultURL": "dev.alkhalaf.hyperpayExample://result",
          "paymentBrand": "",
          "holder": "TEST HUMAN",
          "number": "4200000000000000",
          "expiryMonth": "06",
          "expiryYear": "2030",
          "cvv": "123",
        },
      );
    } on PlatformException catch (exception) {
      print("platform exception: $exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hyperpay example app'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text("Do Checkout"),
            onPressed: () async {
              await doCheckout();
            },
          ),
        ),
      ),
    );
  }
}
