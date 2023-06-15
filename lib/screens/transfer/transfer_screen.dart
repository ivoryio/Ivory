import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/screens/transfer/transfer_confirm_screen.dart';
import 'package:solarisdemo/services/backoffice_services.dart';
import 'package:solarisdemo/services/change_request_service.dart';
import 'package:solarisdemo/services/transaction_service.dart';

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
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return BlocProvider.value(
      value: TransferCubit(
        transactionService: TransactionService(user: user.cognito),
        changeRequestService: ChangeRequestService(user: user.cognito),
        backOfficeServices: BackOfficeServices(user: user.cognito),
      ),
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          if (state is TransferLoadingState) {
            return const LoadingScreen(
              title: "",
            );
          }

          if (state is TransferErrorState) {
            return ErrorScreen(
              title: "",
              message: state.message,
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

          return TransferInitialScreen(
            state: state,
          );
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
