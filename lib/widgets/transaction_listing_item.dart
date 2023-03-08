import 'package:flutter/material.dart';

import 'text_currency_value.dart';

class TransactionListItem extends StatelessWidget {
  final String vendor;
  final String date;
  final double amount;

  const TransactionListItem(
      {super.key,
      required this.vendor,
      required this.date,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(Icons.article, size: 40),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Amazon",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Yesterday, 22:30"),
                ]),
          ],
        ),
        TextCurrencyValue(value: amount)
      ]),
    );
  }
}
