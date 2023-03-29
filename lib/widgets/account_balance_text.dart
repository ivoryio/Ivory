import 'package:flutter/material.dart';

import '../utilities/format.dart';

class AccountBalanceText extends StatelessWidget {
  final TextStyle? numberStyle;
  final TextStyle? centsStyle;

  final num value;

  final TextStyle defaultNumberStyle = const TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  final TextStyle defaultCentsStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  const AccountBalanceText({
    super.key,
    required this.value,
    this.numberStyle,
    this.centsStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: Format.euro(value, digits: 0),
            style: defaultNumberStyle.merge(numberStyle),
          ),
          TextSpan(
            text: ".${Format.cents(value)}",
            style: defaultCentsStyle.merge(centsStyle),
          ),
        ],
      ),
    );
  }
}