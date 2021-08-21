import 'package:flutter/material.dart';
import 'package:hyperpay/hyperpay.dart';
import 'package:hyperpay_example/app/services/hyperpay_api_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HyperpayApiService _hyperpayApiService = HyperpayApiService();

  bool isBusy = false;
  String? checkoutId;

  Future<String?> getCheckoutId() async {
    return await _hyperpayApiService.getCheckoutId();
  }

  Future<void> doCheckout() async {
    setState(() {
      isBusy = true;
    });
    checkoutId = await getCheckoutId();

    if (checkoutId == null) {
      setState(() {
        isBusy = false;
      });
      return;
    }

    await HyperpayService.getHyperpayResponse(
      arguments: {
        "mode": "TEST",
        "checkoutId": checkoutId,
        "paymentBrand": "",
        "holder": "TEST HUMAN",
        "number": "4200000000000000",
        "expiryMonth": "06",
        "expiryYear": "2030",
        "cvv": "123",
      },
    );
    setState(() {
      isBusy = false;
    });
  }

  Future<void> getPaymentStatus() async {
    setState(() {
      isBusy = true;
    });

    await _hyperpayApiService.getPaymentStatus(
      checkoutId: checkoutId!,
    );

    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hyperpay example app'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (checkoutId != null)
                Center(
                  child: SelectableText(
                    "CheckoutId: $checkoutId",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              if (checkoutId == null)
                Center(
                  child: Text(
                    "CheckoutId is null!",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ElevatedButton(
                child: Text("Do Checkout"),
                onPressed: () async {
                  await doCheckout();
                },
              ),
              ElevatedButton(
                child: Text("Get Payment Status"),
                onPressed: checkoutId != null
                    ? () async {
                        await getPaymentStatus();
                      }
                    : null,
              ),
              if (isBusy) Center(child: const CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
