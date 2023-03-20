import 'package:flutter/material.dart';

import '../utilities/format.dart';

class AccountBalanceText extends StatelessWidget {
  final TextStyle? numberStyle;
  final TextStyle? centsStyle;

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
  const AccountBalanceText({super.key, this.numberStyle, this.centsStyle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: Format.euroFromCents(245800),
            style: defaultNumberStyle.merge(numberStyle),
          ),
          TextSpan(
            text: ".${Format.cents(245800)}",
            style: defaultCentsStyle.merge(centsStyle),
          ),
        ],
      ),
    );
  }
}
