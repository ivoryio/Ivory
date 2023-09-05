import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_approval_presenter.dart';
import 'package:solarisdemo/models/amount_value.dart';
import 'package:solarisdemo/models/categories/category.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_failed_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_rejected_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_success_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/card_list_item.dart';
import 'package:solarisdemo/widgets/circular_countdown_progress_widget.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/transaction_listing_item.dart';

class TransactionApprovalPendingScreen extends StatelessWidget {
  static const routeName = '/transactionApprovalPendingScreen';

  const TransactionApprovalPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: StoreConnector<AppState, TransactionApprovalViewModel>(
            onInit: (store) {
              if (store.state.notificationState is NotificationTransactionApprovalState) {
                store.dispatch(
                  GetBankCardCommandAction(
                    user: user,
                    cardId: (store.state.notificationState as NotificationTransactionApprovalState).message.cardId,
                  ),
                );
              }
            },
            converter: (store) => TransactionApprovalPresenter.present(
                  bankCardState: store.state.bankCardState,
                  notificationState: store.state.notificationState,
                  transactionApprovalState: store.state.transactionApprovalState,
                ),
            distinct: true,
            onWillChange: (previousViewModel, newViewModel) {
              if (newViewModel is TransactionApprovalSucceededViewModel) {
                Navigator.pushReplacementNamed(context, TransactionApprovalSuccessScreen.routeName);
              } else if (newViewModel is TransactionApprovalFailedViewModel) {
                Navigator.pushReplacementNamed(context, TransactionApprovalFailedScreen.routeName);
              } else if (newViewModel is TransactionApprovalRejectedViewModel) {
                Navigator.pushReplacementNamed(context, TransactionApprovalRejectedScreen.routeName);
              }
            },
            builder: (context, viewModel) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Appbar(),
                    ...(viewModel is WithApprovalChallengeViewModel && !viewModel.isLoading)
                        ? _buildPageContent(context, user, viewModel)
                        : [const Expanded(child: Center(child: CircularProgressIndicator()))],
                    const SizedBox(height: 16),
                  ],
                )),
      ),
    );
  }

  List<Widget> _buildPageContent(
    BuildContext context,
    AuthenticatedUser user,
    WithApprovalChallengeViewModel viewModel,
  ) {
    return [
      _buildPaymentInfo(context, user, viewModel),
      SizedBox(
        width: double.infinity,
        child: SecondaryButton(
          text: "Reject",
          borderWidth: 2,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _RejectionAlertDialog(
                onConfirm: () => StoreProvider.of<AppState>(context).dispatch(
                  RejectTransactionCommandAction(
                    user: user.cognito,
                    declineChangeRequestId: viewModel.message.declineChangeRequestId,
                    deviceData: viewModel.deviceData,
                    deviceId: viewModel.deviceId,
                    stringToSign: viewModel.stringToSign,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          text: "Authorize",
          onPressed: () async {
            StoreProvider.of<AppState>(context).dispatch(
              ConfirmTransactionCommandAction(
                user: user.cognito,
                changeRequestId: viewModel.changeRequestId,
                deviceData: viewModel.deviceData,
                deviceId: viewModel.deviceId,
                stringToSign: viewModel.stringToSign,
              ),
            );
          },
        ),
      )
    ];
  }

  Widget _buildPaymentInfo(
    BuildContext context,
    AuthenticatedUser user,
    WithApprovalChallengeViewModel viewModel,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: Text("Authorize your online payment", style: ClientConfig.getTextStyleScheme().heading2),
              ),
              SizedBox(
                height: 70,
                width: 70,
                child: CircularCountdownProgress(
                  duration: const Duration(minutes: 4),
                  onCompleted: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      useRootNavigator: true,
                      builder: (context) => const _TimeoutAlertDialog(),
                    );
                  },
                ),
              )
            ]),
            const SizedBox(height: 24),
            Text("Payment details", style: ClientConfig.getTextStyleScheme().labelLarge),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TransactionListItem(
                isClickable: false,
                transaction: Transaction(
                  recipientName: viewModel.message.merchantName,
                  description: "",
                  amount: AmountValue(
                    value: (double.tryParse(viewModel.message.amountValue) ?? 0) / 100 * -1,
                    currency: "EUR",
                    unit: "cents",
                  ),
                  category: const Category(id: "other", name: "Other"),
                  recordedAt: viewModel.message.dateTime,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("Card details", style: ClientConfig.getTextStyleScheme().labelLarge),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CardListItem(
                cardNumber: viewModel.bankCard.representation?.maskedPan ?? "",
                expiryDate: viewModel.bankCard.representation?.formattedExpirationDate ?? "",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Appbar extends StatelessWidget {
  const _Appbar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset("assets/icons/default/appbar_logo.svg"),
          SvgPicture.asset("assets/icons/visa_logo_gradient_bg.svg"),
        ],
      ),
    );
  }
}

class _TimeoutAlertDialog extends StatelessWidget {
  const _TimeoutAlertDialog();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(
          "Payment confirmation timed out",
          style: ClientConfig.getTextStyleScheme().heading4,
        ),
        content: const Text("The payment has been automatically rejected"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class _RejectionAlertDialog extends StatelessWidget {
  final void Function() onConfirm;

  const _RejectionAlertDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Reject this payment",
        style: ClientConfig.getTextStyleScheme().heading4,
      ),
      content: const Text("Are you sure you want to reject this payment?"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: ClientConfig.getTextStyleScheme()
                .heading4
                .copyWith(fontWeight: FontWeight.w400, color: ClientConfig.getColorScheme().secondary),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            "Yes",
            style: ClientConfig.getTextStyleScheme()
                .heading4
                .copyWith(fontWeight: FontWeight.w400, color: ClientConfig.getColorScheme().secondary),
          ),
        ),
      ],
    );
  }
}
