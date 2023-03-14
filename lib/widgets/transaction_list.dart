import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/oauth_model.dart';
import 'transaction_listing_item.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../services/transaction_service.dart';
import '../cubits/transaction_list_cubit/transaction_list_cubit.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    OauthModel oauthModel = context.read<AuthCubit>().state.oauthModel!;

    return BlocProvider(
      create: (context) => TransactionListCubit(
        transactionService: TransactionService(oauthModel: oauthModel),
      )..getTransactions(),
      child: BlocBuilder<TransactionListCubit, TransactionListState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case TransactionListInitial:
              return const Text("No transactions found");
            case TransactionListLoading:
              return const CircularProgressIndicator();
            case TransactionListError:
              return const Text("Transactions could not be loaded");
            case TransactionListLoaded:
              var transactions = state.transactions;

              if (transactions.isEmpty) {
                return const Text("Transaction list is empty");
              }

              return ListView.builder(
                  itemCount: transactions.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return TransactionListItem(
                      vendor:
                          transactions[index].recipientName ?? "Unknown Vendor",
                      date: transactions[index].bookingDate ?? "Unknown Date",
                      amount: transactions[index].amount?.value ?? 0.0,
                    );
                  });
            default:
              return const Text("Transactions could not be loaded");
          }
        },
      ),
    );
  }
}
