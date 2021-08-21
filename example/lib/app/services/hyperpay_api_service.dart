import 'dart:convert';

import 'package:http/http.dart' as http;

class HyperpayApiService {
  Future<String?> getCheckoutId() async {
    try {
      final http.Response response = await http.post(
        Uri.parse("http://dev.hyperpay.com/hyperpay-demo/getcheckoutid.php"),
        headers: <String, String>{
          'Accept': 'application/json',
        },
      );

      final Map<String, dynamic> responseDecoded = jsonDecode(response.body);

      switch (responseDecoded['result']['code']) {
        case "000.200.100":
          print("HyperpayApiService > getCheckoutId > success");
          return responseDecoded['id'];
        default:
          return null;
      }
    } catch (exception) {
      print("HyperpayApiService > getCheckoutId > Exception: $exception");

      return null;
    }
  }

  Future getPaymentStatus({
    required String checkoutId,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(
          "http://dev.hyperpay.com/hyperpay-demo/getpaymentstatus.php?id=$checkoutId",
        ),
        headers: <String, String>{
          'Accept': 'application/json',
        },
      );

      final Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      print(responseDecoded);

      switch (responseDecoded['result']['code']) {
        case "000.100.110":
          print("HyperpayApiService > getPaymentStatus > success");
          return;
        case "100.396.101":
          print("HyperpayApiService > getPaymentStatus > cancelled by user");
          return;
        case "200.300.404":
          print(
            "HyperpayApiService > getPaymentStatus > invalid or missing paramter",
          );
          return null;
        case "800.120.100":
          print(
            "HyperpayApiService > getPaymentStatus > too many requests",
          );
          return null;
        default:
          return null;
      }
    } catch (exception) {
      print("HyperpayApiService > getPaymentStatus > Exception: $exception");

      return null;
    }
  }
}
