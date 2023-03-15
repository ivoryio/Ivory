import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'text_currency_value.dart';

class TransactionListItem extends StatelessWidget {
  final String description;
  final String date;
  final double amount;

  const TransactionListItem(
      {super.key,
      required this.description,
      required this.date,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        shadowColor: Color.fromRGBO(0, 0, 0, 0.40),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_card, size: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              )),
                          Text(
                            date,
                            style: TextStyle(
                              color: Color(0xFF667085),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              TextCurrencyValue(value: amount),
            ],
          ),
        ),
      ),
    );
  }
}
