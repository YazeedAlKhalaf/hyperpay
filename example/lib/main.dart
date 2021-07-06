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
      await HyperpayService.getHyperpayResponse(arguments: {
        "checkoutId": "4A432B30357AFBA4C6F68B9443E83350.uat01-vm-tx04",
        "shopperResultURL": "dev.alkhalaf.hyperpayExample://result",
      });
    } on PlatformException {
      print("platform exception");
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
