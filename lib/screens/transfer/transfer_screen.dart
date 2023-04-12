import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/screens/transfer/transfer_confirm_screen.dart';

import '../../widgets/screen.dart';
import '../../cubits/transfer/transfer_cubit.dart';
import 'transfer_confirmed_screen.dart';
import 'transfer_confirmtan_screen.dart';
import 'transfer_initial_screen.dart';
import 'transfer_setamount_screen.dart';

class TransferScreen extends StatelessWidget {
  final TransferScreenParams transferScreenParams;
  final GlobalKey<PayeeInformationState> payeeInformationKey = GlobalKey();

  TransferScreen({
    super.key,
    required this.transferScreenParams,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TransferCubit(),
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          if (state is TransferLoadingState) {
            return const LoadingScreen(
              title: "",
            );
          }

          if (state is TransferInitialState) {
            return TransferInitialScreen(
              state: state,
            );
          }

          if (state is TransferSetAmountState) {
            return TransferSetAmountScreen(
              state: state,
            );
          }

          if (state is TransferConfirmState) {
            return TransferConfirmScreen(
              state: state,
            );
          }

          if (state is TransferConfirmTanState) {
            return TransferConfirmTanScreen(
              state: state,
            );
          }

          if (state is TransferConfirmedState) {
            return const TransferConfirmedScreen();
          }

          return const Text('Unknown state');
        },
      ),
    );
  }
}

enum TransferType { person, business }

class TransferScreenParams {
  final TransferType transferType;

  const TransferScreenParams({
    required this.transferType,
  });
}
