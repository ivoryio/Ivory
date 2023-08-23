import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/splitpay_cubit/splitpay_cubit.dart';
import '../../models/transactions/transaction_model.dart';
import 'splitpay_confirmation_screen.dart';
import 'splitpay_selection_screen.dart';

class SplitpayScreenParams {
  final Transaction transaction;

  const SplitpayScreenParams({
    required this.transaction,
  });
}

class SplitpayScreen extends StatelessWidget {
  static const routeName = '/splitpayScreen';

  final SplitpayScreenParams params;

  const SplitpayScreen({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplitpayCubit(
        transaction: params.transaction,
      ),
      child: BlocBuilder<SplitpayCubit, SplitpayState>(
        builder: (context, state) {
          if (state is SplitpayInitialState) {
            return SplitpaySelectionScreen(
              transaction: state.transaction,
            );
          }

          if (state is SplitpaySelectedState) {
            return SplitpayConfirmationScreen(
              transaction: state.transaction,
            );
          }

          return const Text('Unknown state');
        },
      ),
    );
  }
}
