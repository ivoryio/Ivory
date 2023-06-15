import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/splitpay_cubit/splitpay_cubit.dart';
import '../../models/transaction_model.dart';
import 'splitpay_confirmation_screen.dart';
import 'splitpay_selection_screen.dart';

class SplitpayScreen extends StatelessWidget {
  final Transaction transaction;

  const SplitpayScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplitpayCubit(
        transaction: transaction,
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
