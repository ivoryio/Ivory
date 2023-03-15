import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TextCurrencyValue extends StatelessWidget {
  final double value;
  final String currency;
  final TextStyle style;

  const TextCurrencyValue({
    super.key,
    required this.value,
    this.currency = "\u20AC", // euro symbol
    this.style = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  });

  @override
  Widget build(BuildContext context) {
    String output = value < 0
        ? "-$currency${((value * -1) / 1000).toStringAsFixed(0)}"
        : "+$currency${(value / 1000).toStringAsFixed(0)}";

    return PlatformText(output, style: style);
  }
}
