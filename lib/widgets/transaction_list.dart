import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import '../router/routing_constants.dart';

import '../models/oauth_model.dart';
import 'transaction_listing_item.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../services/transaction_service.dart';
import '../cubits/transaction_list_cubit/transaction_list_cubit.dart';

class TransactionList extends StatelessWidget {
  final bool displayShowAllButton;
  const TransactionList({super.key, this.displayShowAllButton = true});

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
                    ListView.builder(
                        itemCount: transactions.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return TransactionListItem(
                            transaction: transactions[index],
                          );
                        }),
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
