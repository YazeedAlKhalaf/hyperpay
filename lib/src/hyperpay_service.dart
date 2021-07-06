import 'package:flutter/services.dart';

class HyperpayService {
  static final MethodChannel _hyperpayMethodChannel = MethodChannel(
    "hyperpay",
  );

  static Future<dynamic> getHyperpayResponse({
    required dynamic arguments,
  }) async {
    try {
      final dynamic response = await _hyperpayMethodChannel.invokeMethod(
        "getHyperpayResponse",
        arguments,
      );

      print("getHyperpayResponse(): $response");
    } catch (e) {
      print("getHyperpayResponse(): exception: $e");
    }
  }
}
