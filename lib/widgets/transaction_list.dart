import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

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

  const TransactionList({
    super.key,
    this.displayShowAllButton = true,
    this.searchEnabled = false,
    this.filter,
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
                              child: Expanded(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.black,
                                  ),
                                  child: PlatformIconButton(
                                    icon: const Icon(Icons.filter_alt,
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
