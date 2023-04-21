import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';
import 'empty_list_message.dart';
import 'transaction_listing_item.dart';
import '../models/transaction_model.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../services/transaction_service.dart';
import '../cubits/transaction_list_cubit/transaction_list_cubit.dart';

class TransactionList extends StatelessWidget {
  final bool groupedByMonths;
  final TransactionListFilter? filter;

  const TransactionList({
    super.key,
    this.filter,
    this.groupedByMonths = false,
  });

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return BlocProvider<TransactionListCubit>.value(
      value: TransactionListCubit(
        transactionService: TransactionService(user: user.cognito),
      )..getTransactions(filter: filter),
      child: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          Widget emptyListWidget = const EmptyListMessage(
            title: "No transactions yet",
            message:
                "There are no transactions yet. Your future transactions will be displayed here.",
          );

          switch (state.runtimeType) {
            case TransactionListInitial:
              return emptyListWidget;
            case TransactionListLoading:
              return const Center(child: CircularProgressIndicator());
            case TransactionListError:
              return const Text("Transactions could not be loaded");
            case TransactionListLoaded:
              var transactions = state.transactions;

              if (transactions.isEmpty) {
                return emptyListWidget;
              }

              return Column(
                children: [
                  groupedByMonths
                      ? _buildGroupedByMonthsList(transactions)
                      : _buildList(context, transactions)
                ],
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
