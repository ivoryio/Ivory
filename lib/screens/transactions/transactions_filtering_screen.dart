import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../cubits/transactions_filtering/transactions_filtering_cubit.dart';
import '../../services/transaction_service.dart';
import '../../utilities/format.dart';
import '../../widgets/button.dart';
import '../../widgets/modal.dart';
import '../../widgets/pill_button.dart';
import 'modals/transaction_date_picker_popup.dart';

class TransactionsFilteringScreen extends StatelessWidget {
  static const routeName = "/transactionsFilteringScreen";

  final TransactionListFilter? transactionListFilter;

  const TransactionsFilteringScreen({
    super.key,
    this.transactionListFilter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TransactionsFilteringCubit(
        transactionListFilter:
            transactionListFilter ?? const TransactionListFilter(),
      ),
      child:
          BlocBuilder<TransactionsFilteringCubit, TransactionsFilteringState>(
        builder: (context, state) {
          final isFilterSelected =
              state.transactionListFilter.bookingDateMin != null ||
                  state.transactionListFilter.bookingDateMax != null;

          return ScreenScaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppToolbar(
                    title: "Filter",
                    backIcon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context
                              .read<TransactionsFilteringCubit>()
                              .resetFilters();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            TransactionsScreen.routeName,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Reset filters",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text("By date"),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.today,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      PillButton(
                        active: state.transactionListFilter.bookingDateMin !=
                                null ||
                            state.transactionListFilter.bookingDateMax != null,
                        buttonText:
                            '${getFormattedDate(date: state.transactionListFilter.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: state.transactionListFilter.bookingDateMax, text: "End date")}',
                        buttonCallback: () {
                          showBottomModal(
                            context: context,
                            showCloseButton: false,
                            content: TransactionDatePickerPopup(
                              initialSelectedRange: isFilterSelected
                                  ? DateTimeRange(
                                      start: state.transactionListFilter
                                          .bookingDateMin!,
                                      end: state.transactionListFilter
                                          .bookingDateMax!)
                                  : null,
                              onDateRangeSelected: (DateTimeRange range) {
                                context
                                    .read<TransactionsFilteringCubit>()
                                    .setDateRange(range);
                              },
                            ),
                          );
                        },
                        icon: (state.transactionListFilter.bookingDateMin !=
                                    null ||
                                state.transactionListFilter.bookingDateMax !=
                                    null)
                            ? const Icon(
                                Icons.close,
                                size: 16,
                              )
                            : null,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                            text: "Apply filters",
                            onPressed: () {
                              // TODO: Apply filters
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                TransactionsScreen.routeName,
                                (route) => false,
                                arguments: state.transactionListFilter,
                              );
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String getFormattedDate({
  DateTime? date,
  String text = "Date not set",
}) {
  if (date == null) {
    return text;
  }

  return Format.date(date, pattern: "dd MMM yyyy");
}
