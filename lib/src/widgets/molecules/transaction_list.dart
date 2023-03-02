import 'package:flutter/material.dart';

import 'transaction_listing_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TransactionListItem(
            vendor: "Amazon", date: "Yesterday", amount: -35.2555),
        TransactionListItem(vendor: "Orange", date: "Yesterday", amount: 25),
      ],
    );
  }
}
