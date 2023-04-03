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
              Widget _buildTransactionListview() {
                if (groupedByMonths) {
                  return _buildGroupedByMonthsList(
                    context,
                    transactions,
                    displayShowAllButton: displayShowAllButton,
                    searchEnabled: searchEnabled,
                  );
                } else {
                  return _buildList(context, transactions);
                }
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
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          left: 4.0,
                          right: 4.0,
                        ),
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
                                width: 45,
                                height: 45,
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
                    _buildTransactionListview(),
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
  var month = parts[0];
  switch (month) {
    case '1':
      return 'January $year';
    case '2':
      return 'February $year';
    case '3':
      return 'March $year';
    case '4':
      return 'April $year';
    case '5':
      return 'May $year';
    case '6':
      return 'June $year';
    case '7':
      return 'July $year';
    case '8':
      return 'August $year';
    case '9':
      return 'September $year';
    case '10':
      return 'October $year';
    case '11':
      return 'November $year';
    case '12':
      return 'December $year';
    default:
      return '';
  }
}

Widget _buildList(
  BuildContext context,
  List<Transaction> transactions,
) {
  return ListView.builder(
      itemCount: transactions.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return TransactionListItem(
          transaction: transactions[index],
        );
      });
}

Widget _buildGroupedByMonthsList(
    BuildContext context, List<Transaction> transactions,
    {bool displayShowAllButton = true, bool searchEnabled = false}) {
  var groupedTransactions = Map<String, List<Transaction>>();
  transactions.forEach((transaction) {
    var transactionDate = DateTime.parse(transaction.bookingDate!);
    var monthAndYear = '${transactionDate.month}/${transactionDate.year}';
    if (groupedTransactions.containsKey(monthAndYear)) {
      groupedTransactions[monthAndYear]!.add(transaction);
    } else {
      groupedTransactions[monthAndYear] = [transaction];
    }
  });

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
      return monthA.compareTo(monthB);
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
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              formattedMonthAndYear,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) => TransactionListItem(
              transaction: transactions[index],
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    },
  );
}
