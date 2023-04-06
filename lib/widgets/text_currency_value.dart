import 'package:flutter/material.dart';
import 'package:solarisdemo/utilities/format.dart';

class TextCurrencyValue extends StatelessWidget {
  final num value;
  final int digits;
  final TextStyle style;
  final int maxDigits;

  const TextCurrencyValue({
    super.key,
    required this.value,
    this.digits = 2,
    this.maxDigits = 2,
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    String output = Format.euroFromCents(
      value,
      digits: digits,
      maxDigits: maxDigits,
    );

    return Text(output, style: style);
  }
}
