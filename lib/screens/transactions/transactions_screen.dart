import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/screen.dart';
import '../../themes/default_theme.dart';
import '../../router/routing_constants.dart';
import '../../widgets/transaction_list.dart';
import '../../services/transaction_service.dart';

class TransactionsScreen extends StatelessWidget {
  final TransactionListFilter? transactionListFilter;

  const TransactionsScreen({
    super.key,
    this.transactionListFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Transactions",
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          children: [
            TransactionList(
              displayShowAllButton: false,
              searchEnabled: true,
              groupedByMonths: true,
              filter: transactionListFilter,
              onPressedFilterButton: () {
                context.push(transactionsFilteringRoute.path);
              },
            ),
          ],
        ),
      ),
    );
  }
}
