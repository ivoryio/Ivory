import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/modal.dart';
import '../../widgets/screen.dart';
import '../../router/routing_constants.dart';
import '../../services/transaction_service.dart';
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
          return Screen(
            title: transactionsFilteringRoute.title,
            hideBottomNavbar: true,
            backButtonIcon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
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
                      PlatformTextButton(
                        padding: EdgeInsets.zero,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.calendar_today),
                              Text("Start date"),
                              Text("-"),
                              Text("End date"),
                            ]),
                        onPressed: () {
                          showBottomModal(
                            context: context,
                            child: const TransactionDatePickerPopup(),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                            text: "Apply filters",
                            onPressed: () {
                              TransactionListFilter filter =
                                  TransactionListFilter(
                                bookingDateMin: "2022-01-01",
                              );

                              context.push(transactionsRoute.path,
                                  extra: filter);
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
