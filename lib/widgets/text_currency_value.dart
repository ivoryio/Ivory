import 'package:flutter/material.dart';

class TextCurrencyValue extends StatelessWidget {
  final double value;
  final String currency;
  final TextStyle style;

  const TextCurrencyValue({
    super.key,
    required this.value,
    this.currency = "\u20AC", // euro symbol
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    String output = value < 0
        ? "- $currency ${((value * -1) / 100).toStringAsFixed(0)}"
        : "+ $currency ${(value / 100).toStringAsFixed(0)}";

    return Text(output, style: style);
  }
}
