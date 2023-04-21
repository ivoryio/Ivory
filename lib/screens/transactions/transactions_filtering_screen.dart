import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../themes/default_theme.dart';
import '../../utilities/format.dart';
import '../../widgets/button.dart';
import '../../widgets/modal.dart';
import '../../widgets/screen.dart';
import '../../router/routing_constants.dart';
import '../../cubits/transactions_filtering/transactions_filtering_cubit.dart';
import 'modals/transaction_date_picker_popup.dart';

class TransactionsFilteringScreen extends StatelessWidget {
  const TransactionsFilteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TransactionsFilteringCubit(),
      child:
          BlocBuilder<TransactionsFilteringCubit, TransactionsFilteringState>(
        builder: (context, state) {
          print("render");
          return Screen(
            title: transactionsFilteringRoute.title,
            hideBottomNavbar: true,
            backButtonIcon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            trailingActions: [
              PlatformTextButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.read<TransactionsFilteringCubit>().resetFilters();
                    context.pop();
                  },
                  child: const Text(
                    "Reset filters",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ))
            ],
            child: Padding(
              padding: defaultScreenPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("By date"),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          SizedBox(
                            // height: 25,
                            child: PlatformTextButton(
                              padding: EdgeInsets.zero,
                              color: Colors.grey,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _getFormattedDate(
                                          date: state.transactionListFilter
                                              .bookingDateMin,
                                          text: "Start date"),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(" - "),
                                    Text(
                                        _getFormattedDate(
                                            date: state.transactionListFilter
                                                .bookingDateMax,
                                            text: "End date"),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    const Icon(Icons.close, size: 14),
                                  ]),
                              onPressed: () {
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                            text: "Apply filters",
                            onPressed: () {
                              context.push(transactionsRoute.path,
                                  extra: state.transactionListFilter);
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String _getFormattedDate({
  DateTime? date,
  String text = "Date not set",
}) {
  if (date == null) {
    return text;
  }

  return Format.date(date, pattern: "dd MMM yyyy");
}
