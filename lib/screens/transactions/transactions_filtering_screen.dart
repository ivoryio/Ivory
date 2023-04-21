import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/widgets/pill_button.dart';

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
                          PillButton(
                            buttonText:
                                '${getFormattedDate(date: state.transactionListFilter.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: state.transactionListFilter.bookingDateMax, text: "End date")}',
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
                            icon: (state.transactionListFilter.bookingDateMin !=
                                        null ||
                                    state.transactionListFilter
                                            .bookingDateMax !=
                                        null)
                                ? const Icon(
                                    Icons.close,
                                    size: 16,
                                  )
                                : null,
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

String getFormattedDate({
  DateTime? date,
  String text = "Date not set",
}) {
  if (date == null) {
    return text;
  }

  return Format.date(date, pattern: "dd MMM yyyy");
}
