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
      if (responseDecoded['result']['code'] == "000.200.100") {
        return responseDecoded['id'];
      }

      return null;
    } catch (exception) {
      print("HyperpayApiService > getCheckoutId > Exception: $exception");

      return null;
    }
  }
}
