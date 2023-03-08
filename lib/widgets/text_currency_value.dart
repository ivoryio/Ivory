import 'package:flutter/material.dart';

class TextCurrencyValue extends StatelessWidget {
  final double value;
  final String currency;
  final TextStyle style;

  const TextCurrencyValue(
      {super.key,
      required this.value,
      this.currency = "\$",
      this.style = const TextStyle()});

  @override
  Widget build(BuildContext context) {
    String output = value < 0
        ? "-$currency${(value * -1).toStringAsFixed(2)}"
        : "$currency${value.toStringAsFixed(2)}";

    return Text(output, style: style);
  }
}
