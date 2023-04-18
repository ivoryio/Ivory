import 'package:flutter/material.dart';
import 'package:solarisdemo/themes/default_theme.dart';
import '../../widgets/transaction_list.dart';

import '../../widgets/screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
        title: "Transactions",
        child: Padding(
          padding: defaultScreenPadding,
          child: Column(
            children: const [
              TransactionList(
                displayShowAllButton: false,
                searchEnabled: true,
                groupedByMonths: true,
              ),
            ],
          ),
        ));
  }
}
