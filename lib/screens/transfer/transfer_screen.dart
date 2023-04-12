import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/amount_information.dart';
import '../../widgets/account_select.dart';
import '../../widgets/payee_information.dart';
import '../../widgets/screen.dart';
import '../../themes/default_theme.dart';
import '../../router/routing_constants.dart';
import '../../widgets/sticky_bottom_content.dart';
import '../../widgets/tan_input.dart';
import '../../widgets/transfer_details.dart';
import '../../widgets/transfer_succesful.dart';
import '../../cubits/transfer/transfer_cubit.dart';

class TransferScreen extends StatelessWidget {
  final TransferScreenParams transferScreenParams;
  final GlobalKey<PayeeInformationState> payeeInformationKey = GlobalKey();
  final GlobalKey<AmountInformationState> amountInformationKey = GlobalKey();

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
          TransferCubit transferCubit = context.read<TransferCubit>();

          if (state is TransferLoadingState) {
            return const LoadingScreen(
              title: "",
            );
          }

          if (state is TransferInitialState) {
            return Screen(
              title: transferRoute.title,
              hideBottomNavbar: true,
              bottomStickyWidget: BottomStickyWidget(
                child: StickyBottomContent(
                  onContinueCallback: () {
                    context.read<TransferCubit>().setBasicData(
                          iban: payeeInformationKey
                              .currentState!.ibanController.text,
                          name: payeeInformationKey
                              .currentState!.nameController.text,
                          savePayee:
                              payeeInformationKey.currentState!.savePayee,
                        );
                  },
                ),
              ),
              child: Padding(
                padding: defaultScreenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AccountSelect(title: "Send from"),
                    PayeeInformation(
                      key: payeeInformationKey,
                      iban: state.iban,
                      name: state.name,
                      savePayee: state.savePayee,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TransferStateSetAmount) {
            return Screen(
              customBackButtonCallback: () {
                context.read<TransferCubit>().setInitState(
                      name: state.name,
                      iban: state.iban,
                      savePayee: state.savePayee,
                    );
              },
              title: transferRoute.title,
              hideBottomNavbar: true,
              bottomStickyWidget: BottomStickyWidget(
                child: StickyBottomContent(
                  buttonText: "Send money",
                  onContinueCallback: () {
                    final amount = double.tryParse(amountInformationKey
                        .currentState!.amountController.text);
                    if (amount != null) {
                      context.read<TransferCubit>().setAmount(amount: amount);
                    }
                  },
                ),
              ),
              child: Padding(
                padding: defaultScreenPadding,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AmountInformation(
                        key: amountInformationKey,
                        amount: state.amount,
                      )
                    ]),
              ),
            );
          }

          if (state is TransferStateConfirm) {
            return Screen(
              customBackButtonCallback: () {
                context.read<TransferCubit>().setBasicData(
                      name: state.name,
                      iban: state.iban,
                      savePayee: state.savePayee,
                      amount: state.amount,
                    );
              },
              title: "Transaction confirmation",
              hideBottomNavbar: true,
              bottomStickyWidget: BottomStickyWidget(
                child: StickyBottomContent(
                  buttonText: "Confirm and send",
                  onContinueCallback: () {
                    context.read<TransferCubit>().confirmTransfer(
                          name: state.name,
                          iban: state.iban,
                          savePayee: state.savePayee,
                          amount: state.amount,
                        );
                  },
                ),
              ),
              child: Padding(
                padding: defaultScreenPadding,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AccountSelect(),
                      TransferDetails(
                        iban: state.iban!,
                        amount: state.amount!,
                        name: state.name!,
                      ),
                    ]),
              ),
            );
          }

          if (state is TransferStateConfirmTan) {
            return Screen(
              customBackButtonCallback: () {
                context.read<TransferCubit>().setBasicData(
                      name: state.name,
                      iban: state.iban,
                      savePayee: state.savePayee,
                      amount: state.amount,
                    );
              },
              title: "Transaction confirmation",
              hideBottomNavbar: true,
              child: Center(
                child: Padding(
                  padding: defaultScreenPadding,
                  child: TanInput(
                    length: 6,
                    onCompleted: (String tan) {
                      context.read<TransferCubit>().confirmTan(tan);
                    },
                  ),
                ),
              ),
            );
          }

          if (state is TransactionStateConfirmed) {
            return Screen(
              title: '',
              hideBackButton: true,
              hideBottomNavbar: true,
              bottomStickyWidget: BottomStickyWidget(
                child: StickyBottomContent(
                  buttonText: "OK, got it",
                  onContinueCallback: () {
                    context.go(homeRoute.path);
                  },
                ),
              ),
              child: Padding(
                padding: defaultScreenPadding,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      TransferSuccessful(),
                    ]),
              ),
            );
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
