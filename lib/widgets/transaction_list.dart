import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../models/transaction_model.dart';
import '../models/user.dart';
import 'transaction_listing_item.dart';
import '../router/routing_constants.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../services/transaction_service.dart';
import '../cubits/transaction_list_cubit/transaction_list_cubit.dart';
import '../../widgets/platform_text_input.dart';

class TransactionList extends StatelessWidget {
  final bool displayShowAllButton;
  final TransactionListFilter? filter;
  final bool searchEnabled;
  final bool groupedByMonths;

  const TransactionList({
    super.key,
    this.displayShowAllButton = true,
    this.searchEnabled = false,
    this.filter,
    this.groupedByMonths = false,
  });

  @override
  Widget build(BuildContext context) {
    User user = context.read<AuthCubit>().state.user!;

    return BlocProvider<TransactionListCubit>.value(
      value: TransactionListCubit(
        transactionService: TransactionService(user: user),
      )..getTransactions(filter: filter),
      child: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case TransactionListInitial:
              return const Text("No transactions found");
            case TransactionListLoading:
              return const Center(child: CircularProgressIndicator());
            case TransactionListError:
              return const Text("Transactions could not be loaded");
            case TransactionListLoaded:
              var transactions = state.transactions;

              if (transactions.isEmpty) {
                return const Text("Transaction list is empty");
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transactions",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (displayShowAllButton)
                          PlatformTextButton(
                            padding: EdgeInsets.zero,
                            child: const Text(
                              "See all",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              context.push(transactionsRoute.path);
                            },
                          )
                      ],
                    ),
                    if (searchEnabled)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: PlatformTextInput(
                                textLabel: "",
                                hintText: "Search here...",
                                icon: Icons.search,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a search term';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.black,
                                ),
                                child: PlatformIconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.filter_alt,
                                      color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    groupedByMonths
                        ? _buildGroupedByMonthsList(transactions)
                        : _buildList(context, transactions)
                  ],
                ),
              );

            default:
              return const Text("Transactions could not be loaded");
          }
        },
      ),
    );
  }
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

Widget _buildList(
  BuildContext context,
  List<Transaction> transactions,
) {
  return ListView.separated(
      itemCount: transactions.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      separatorBuilder: (context, index) {
        return const Divider(
          height: 10,
          color: Colors.transparent,
        );
      },
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return TransactionListItem(
          transaction: transactions[index],
        );
      });
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

  return ListView.builder(
    itemCount: monthAndYearList.length,
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
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
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
