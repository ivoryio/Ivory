import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_action.dart';

import '../../config.dart';
import '../../models/transaction_model.dart';
import '../../widgets/empty_list_message.dart';
import '../../widgets/search_bar.dart';
import '../../models/user.dart';
import '../../widgets/screen.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/transaction_listing_item.dart';
import 'transactions_filtering_screen.dart';
import '../../router/routing_constants.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';

class TransactionsScreen extends StatefulWidget {

  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return StoreConnector<AppState, TransactionsViewModel>(
      onInit: (store) {
        store.dispatch(GetTransactionsCommandAction(filter: null, user: user.cognito));
      },
      converter: (store) => TransactionPresenter.presentTransactions(transactionsState: store.state.transactionsState),
      builder: (context , viewModel) {
        bool isFilterActive = viewModel.transactionListFilter?.bookingDateMax != null ||
            viewModel.transactionListFilter?.bookingDateMin != null;

        return Screen(
        onRefresh: () async {
          StoreProvider.of<AppState>(context).dispatch(GetTransactionsCommandAction(filter: viewModel.transactionListFilter, user: user.cognito));
        },
        title: "Transactions",
        child: Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
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
                    textLabel: viewModel.transactionListFilter?.searchString,
                    showButtonIndicator: isFilterActive,
                    onPressedFilterButton: () {
                      context.push(
                        transactionsFilteringRoute.path,
                        extra: viewModel.transactionListFilter,
                      );
                    },
                    onSubmitSearch: (value) {
                      TransactionListFilter filter;
                      if (value.isEmpty) {
                        filter = TransactionListFilter(
                          bookingDateMax: viewModel.transactionListFilter?.bookingDateMax,
                          bookingDateMin: viewModel.transactionListFilter?.bookingDateMin,
                          size: viewModel.transactionListFilter?.size,
                          searchString: null,
                        );
                      } else {
                        filter = TransactionListFilter(
                          bookingDateMax: viewModel.transactionListFilter?.bookingDateMax,
                          bookingDateMin: viewModel.transactionListFilter?.bookingDateMin,
                          size: viewModel.transactionListFilter?.size,
                          searchString: value,
                        );
                      }
                      StoreProvider.of<AppState>(context).dispatch(GetTransactionsCommandAction(filter: filter, user: user.cognito));
                    },
                    onChangedSearch: (String value) { return; },
                  ),
                  if (isFilterActive)
                    Row(
                      children: [
                        PillButton(
                          buttonText:
                              '${getFormattedDate(date: viewModel.transactionListFilter?.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: viewModel.transactionListFilter?.bookingDateMax, text: "End date")}',
                          buttonCallback: () {
                            StoreProvider.of<AppState>(context).dispatch(GetTransactionsCommandAction(filter: null, user: user.cognito));
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
              _buildTransactionsList(viewModel),
            ],
          ),
        ),
      );}
    );
  }

  Widget _buildTransactionsList(TransactionsViewModel viewModel) {
    const emptyListWidget = TextMessageWithCircularImage(
      title: "No transactions yet",
      message:
      "There are no transactions yet. Your future transactions will be displayed here.",
    );

    if(viewModel is TransactionsLoadingViewModel) {
      return const Center(child: CircularProgressIndicator());
    }

    if(viewModel is TransactionsErrorViewModel) {
      return const Text("Transactions could not be loaded");
    }

    if(viewModel is TransactionsFetchedViewModel) {
      bool isFilteringActive = (viewModel.transactionListFilter?.bookingDateMin != null ||
          viewModel.transactionListFilter?.bookingDateMax != null);

      List<Transaction> transactions = [];

      transactions.addAll(viewModel.transactions as Iterable<Transaction>);

      if (transactions.isEmpty && !isFilteringActive) {
        return emptyListWidget;
      }

      if (transactions.isEmpty && isFilteringActive) {
        return const Text(
          "We couldn't find any results. Please try again by searching for other transactions.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff667085),
          ),
        );
      }

      return Column(
        children: [
              _buildGroupedByMonthsList(transactions)
        ],
      );
    }

    return emptyListWidget;
  }

  String _formatMonthYear(String monthAndYear) {
    var parts = monthAndYear.split('/');
    var year = DateTime.now().year == int.parse(parts[1]) ? '' : parts[1];
    String months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ][int.parse(parts[0]) - 1];

    return '$months $year';
  }

  Widget _buildGroupedByMonthsList(List<Transaction> transactions) {
    var groupedTransactions = <String, List<Transaction>>{};

    for (var transaction in transactions) {
      var transactionDate = DateTime.parse(transaction.bookingDate!);
      var monthAndYear = '${transactionDate.month}/${transactionDate.year}';
      if (groupedTransactions.containsKey(monthAndYear)) {
        groupedTransactions[monthAndYear]!.add(transaction);
      } else {
        groupedTransactions[monthAndYear] = [transaction];
      }
    }

    var monthAndYearList = groupedTransactions.keys.toList();
    monthAndYearList.sort((a, b) {
      var partsA = a.split('/');
      var partsB = b.split('/');
      var yearA = int.parse(partsA[1]);
      var yearB = int.parse(partsB[1]);
      var monthA = int.parse(partsA[0]);
      var monthB = int.parse(partsB[0]);

      if (yearA > yearB) {
        return -1;
      } else if (yearA < yearB) {
        return 1;
      } else {
        return monthB.compareTo(monthA);
      }
    });

    return ListView.separated(
      itemCount: monthAndYearList.length,
      separatorBuilder: (context, index) => const Divider(
        height: 10,
        color: Colors.transparent,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        var monthAndYear = monthAndYearList[index];
        var transactions = groupedTransactions[monthAndYear]!;
        var formattedMonthAndYear = _formatMonthYear(monthAndYear);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                formattedMonthAndYear,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xff414D63),
                ),
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const Divider(
                height: 10,
                color: Colors.transparent,
              ),
              itemBuilder: (context, index) => TransactionListItem(
                transaction: transactions[index],
              ),
            ),
          ],
        );
      },
    );
  }
}
