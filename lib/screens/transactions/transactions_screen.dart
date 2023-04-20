import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/screen.dart';
import '../../themes/default_theme.dart';
import '../../widgets/transaction_list.dart';
import '../../cubits/transactions_filtering/transactions_filtering_cubit.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TransactionsFilteringCubit(),
      child:
          BlocBuilder<TransactionsFilteringCubit, TransactionsFilteringState>(
        builder: (context, state) {
          if (state is TransactionsSetupFilters) {
            return Screen(
              title: "Filter",
              customBackButtonCallback: () {
                context.read<TransactionsFilteringCubit>().closeFiltersScreen();
              },
              child: const Center(
                child: Text("Filtering screen"),
              ),
            );
          }

          return Screen(
            title: "Transactions",
            child: Padding(
              padding: defaultScreenPadding,
              child: Column(
                children: [
                  TransactionList(
                    displayShowAllButton: false,
                    searchEnabled: true,
                    groupedByMonths: true,
                    onPressedFilterButton: () {
                      context.read<TransactionsFilteringCubit>().setupFilters();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
