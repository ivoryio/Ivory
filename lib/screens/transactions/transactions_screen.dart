import 'package:flutter/material.dart';
import 'package:solaris_structure_1/widgets/transaction_list.dart';

import '../../widgets/screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
        title: "Transactions",
        child: Column(
          children: const [
            TransactionList(
              displayShowAllButton: false,
            ),
          ],
        ));
  }
}
