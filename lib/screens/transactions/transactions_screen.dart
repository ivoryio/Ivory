import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/screen.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/pill_button.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import 'transactions_filtering_screen.dart';
import '../../router/routing_constants.dart';
import '../../widgets/transaction_list.dart';
import '../../services/transaction_service.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';

class TransactionsScreen extends StatefulWidget {
  final TransactionListFilter? transactionListFilter;

  const TransactionsScreen({
    super.key,
    this.transactionListFilter,
  });

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  TransactionListFilter? transactionListFilter;

  @override
  void initState() {
    transactionListFilter = widget.transactionListFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFilterActive = transactionListFilter?.bookingDateMax != null ||
        transactionListFilter?.bookingDateMin != null;

    return Screen(
      title: "Transactions",
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          children: [
            SpacedColumn(
              space: 16,
              children: [
                const TransactionListTitle(
                  displayShowAllButton: false,
                ),
                SearchBar(
                  showButtonIndicator: isFilterActive,
                  onPressedFilterButton: () {
                    context.push(
                      transactionsFilteringRoute.path,
                      extra: transactionListFilter,
                    );
                  },
                ),
                if (isFilterActive)
                  Row(
                    children: [
                      PillButton(
                        buttonText:
                            '${getFormattedDate(date: transactionListFilter?.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: transactionListFilter?.bookingDateMax, text: "End date")}',
                        buttonCallback: () {
                          setState(() {
                            transactionListFilter = null;
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                TransactionList(
                  groupedByMonths: true,
                  filter: transactionListFilter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
