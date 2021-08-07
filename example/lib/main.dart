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
        "checkoutId": "C24A5E796703B6666278CBB4D749EB08.uat01-vm-tx04",
        "shopperResultURL": "dev.alkhalaf.hyperpayExample://result",
      });
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
