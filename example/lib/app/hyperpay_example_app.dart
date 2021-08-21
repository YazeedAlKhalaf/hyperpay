import 'package:flutter/material.dart';
import 'package:hyperpay_example/ui/views/home_view.dart';

class HyperpayExampleApp extends StatelessWidget {
  const HyperpayExampleApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(),
    );
  }
}
