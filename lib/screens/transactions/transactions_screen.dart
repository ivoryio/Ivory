import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/search_bar.dart';
import '../../models/user.dart';
import '../../widgets/screen.dart';
import '../../widgets/pill_button.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import 'transactions_filtering_screen.dart';
import '../../router/routing_constants.dart';
import '../../widgets/transaction_list.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../services/transaction_service.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import '../../cubits/transaction_list_cubit/transaction_list_cubit.dart';

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
  TransactionListCubit? transactionListCubit;

  @override
  void initState() {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    transactionListFilter = widget.transactionListFilter;
    transactionListCubit = TransactionListCubit(
      transactionService: TransactionService(user: user.cognito),
    )..getTransactions(filter: transactionListFilter);
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
        child: SpacedColumn(
          space: 36,
          children: [
            SpacedColumn(
              space: 16,
              children: [
                const TransactionListTitle(
                  displayShowAllButton: false,
                ),
                CustomSearchBar(
                  showButtonIndicator: isFilterActive,
                  onPressedFilterButton: () {
                    context.push(
                      transactionsFilteringRoute.path,
                      extra: transactionListFilter,
                    );
                  },
                  onChangedSearch: (value) {
                    if (value.isEmpty) {
                      transactionListCubit!.clearFilters();
                    }

                    transactionListCubit!.searchTransactions(value);
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
                            transactionListCubit!.getTransactions(
                              filter: transactionListFilter,
                            );
                          });
                          transactionListCubit!.getTransactions(
                            filter: transactionListFilter,
                          );
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            TransactionList(
              groupedByMonths: true,
              filter: transactionListFilter,
              transactionListCubit: transactionListCubit!,
            ),
          ],
        ),
      ),
    );
  }
}
