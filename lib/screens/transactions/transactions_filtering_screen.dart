import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/transaction_model.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../redux/transactions/transactions_action.dart';
import '../../widgets/modal.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../utilities/format.dart';
import '../../widgets/pill_button.dart';
import '../../router/routing_constants.dart';
import '../../widgets/spaced_column.dart';
import 'modals/transaction_date_picker_popup.dart';
import '../../cubits/transactions_filtering/transactions_filtering_cubit.dart';

class TransactionsFilteringScreen extends StatefulWidget {
  final TransactionListFilter? transactionListFilter;

  const TransactionsFilteringScreen({
    super.key,
    this.transactionListFilter,
  });

  @override
  State<TransactionsFilteringScreen> createState() => _TransactionsFilteringScreenState();
}

class _TransactionsFilteringScreenState extends State<TransactionsFilteringScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionListFilter? transactionListFilter = widget.transactionListFilter;

    return BlocProvider.value(
      value: TransactionsFilteringCubit(
        transactionListFilter:
            transactionListFilter ?? const TransactionListFilter(),
      ),
      child:
          BlocBuilder<TransactionsFilteringCubit, TransactionsFilteringState>(
        builder: (context, state) {
          final isFilterSelected =
              transactionListFilter?.bookingDateMin != null ||
                  transactionListFilter?.bookingDateMax != null;

          AuthenticatedUser user = context.read<AuthCubit>().state.user!;
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
                  context.push(transactionsRoute.path);
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
            child: Padding(
              padding:
                  ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacedColumn(
                    space: 16.5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("By date"),
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
                            active:transactionListFilter?.bookingDateMin !=
                                    null ||
                                transactionListFilter?.bookingDateMax !=
                                    null,
                            buttonText:
                                '${getFormattedDate(date: transactionListFilter?.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: transactionListFilter?.bookingDateMax, text: "End date")}',
                            buttonCallback: () {
                              showBottomModal(
                                context: context,
                                child: TransactionDatePickerPopup(
                                  initialSelectedRange: isFilterSelected
                                      ? DateTimeRange(
                                          start: transactionListFilter!.bookingDateMin!,
                                          end:transactionListFilter!.bookingDateMax!)
                                      : null,
                                  onDateRangeSelected: (DateTimeRange range) {
                                    transactionListFilter = TransactionListFilter(
                                      bookingDateMin: range.start,
                                      bookingDateMax: range.end,
                                    );
                                    print(transactionListFilter);
                                  },
                                ),
                              );
                            },
                            icon: (transactionListFilter?.bookingDateMin !=
                                        null ||
                                    transactionListFilter?.bookingDateMax !=
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
                              print(transactionListFilter);
                              StoreProvider.of<AppState>(context).dispatch(GetTransactionsCommandAction(filter: transactionListFilter, user: user.cognito));
                              context.pop();
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
