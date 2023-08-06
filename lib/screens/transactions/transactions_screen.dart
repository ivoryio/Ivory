import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/transaction_list_cubit/transaction_list_cubit.dart';
import '../../models/user.dart';
import '../../services/transaction_service.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/transaction_list.dart';
import 'transactions_filtering_screen.dart';

class TransactionsScreen extends StatefulWidget {
  static const routeName = '/transactionsScreen';

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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenPadding
              .left,
        ),
        child: Column(
          children: [
            const AppToolbar(title: "Transactions"),
            SpacedColumn(
              space: 16,
              children: [
                const TransactionListTitle(
                  displayShowAllButton: false,
                ),
                CustomSearchBar(
                  showButtonIndicator: isFilterActive,
                  onPressedFilterButton: () {
                    Navigator.pushNamed(
                        context, TransactionsFilteringScreen.routeName,
                        arguments: transactionListFilter);
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
            const SizedBox(height: 32),
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
