import 'package:flutter/widgets.dart';

import 'spaced_column.dart';
import 'text_currency_value.dart';

class TransferDetails extends StatelessWidget {
  final String iban;
  final String name;
  final double amount;
  const TransferDetails(
      {super.key,
      required this.iban,
      required this.name,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      space: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Transfer details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payee",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              iban,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            TextCurrencyValue(
              value: amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Fee",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            TextCurrencyValue(
              value: 0,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }
}
