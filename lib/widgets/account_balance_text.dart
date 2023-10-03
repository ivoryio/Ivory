import 'package:flutter/material.dart';

import '../config.dart';
import '../utilities/format.dart';

class AccountBalanceText extends StatelessWidget {
  final TextStyle? numberStyle;
  final TextStyle? centsStyle;

  final num value;

  final TextStyle defaultNumberStyle =  ClientConfig.getTextStyleScheme().heading4;
  final TextStyle defaultCentsStyle = ClientConfig.getTextStyleScheme().heading4;

  AccountBalanceText({
    super.key,
    required this.value,
    this.numberStyle,
    this.centsStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: Format.euro(value, digits: 0, maxDigits: 0),
            style: numberStyle ?? defaultNumberStyle,
          ),
          TextSpan(
            text: ".${Format.cents(value)}",
            style: centsStyle ?? defaultCentsStyle,
          ),
        ],
      ),
    );
  }
}
