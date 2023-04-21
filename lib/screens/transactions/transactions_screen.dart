import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/pill_button.dart';
import 'package:solarisdemo/widgets/search_bar.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/transactions_filtering/transactions_filtering_cubit.dart';
import '../../router/routing_constants.dart';
import '../../widgets/modal.dart';
import '../../widgets/screen.dart';
import '../../themes/default_theme.dart';
import '../../widgets/transaction_list.dart';
import '../../services/transaction_service.dart';
import 'modals/transaction_date_picker_popup.dart';
import 'transactions_filtering_screen.dart';

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
            SpacedColumn(
              space: 16,
              children: [
                const TransactionListTitle(
                  displayShowAllButton: false,
                ),
                SearchBar(onPressedFilterButton: () {
                  context.go(transactionsFilteringRoute.path);
                }),
                if (transactionListFilter?.bookingDateMax != null ||
                    transactionListFilter?.bookingDateMin != null)
                  Row(
                    children: [
                      PillButton(
                        buttonText:
                            '${getFormattedDate(date: transactionListFilter?.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: transactionListFilter?.bookingDateMax, text: "End date")}',
                        buttonCallback: () {
                          showBottomModal(
                            context: context,
                            child: TransactionDatePickerPopup(
                              onDateRangeSelected: (DateTimeRange range) {
                                context
                                    .read<TransactionsFilteringCubit>()
                                    .setDateRange(range);
                              },
                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
