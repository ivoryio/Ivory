import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class CardListItem extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;

  const CardListItem({super.key, required this.cardNumber, required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.credit_card, color: ClientConfig.getColorScheme().secondary),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cardNumber, style: ClientConfig.getTextStyleScheme().heading4),
            Text(
              "Expiry date: $expiryDate",
              style: ClientConfig.getTextStyleScheme().bodySmallRegular,
            ),
          ],
        ),
      ],
    );
  }
}
