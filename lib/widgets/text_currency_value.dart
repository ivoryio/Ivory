import 'package:flutter/material.dart';
import 'package:solarisdemo/utilities/format.dart';

class TextCurrencyValue extends StatelessWidget {
  final num value;
  final TextStyle style;

  const TextCurrencyValue({
    super.key,
    required this.value,
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    String output = Format.euro(value);

    return Text(output, style: style);
  }
}
