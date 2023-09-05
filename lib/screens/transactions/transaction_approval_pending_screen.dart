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
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_failed_screen.dart';
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
    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: StoreConnector<AppState, TransactionApprovalViewModel>(
          converter: (store) => TransactionApprovalPresenter.present(
            notificationState: store.state.notificationState,
            transactionApprovalState: store.state.transactionApprovalState,
          ),
          distinct: true,
          onWillChange: (previousViewModel, newViewModel) {
            if (newViewModel is TransactionApprovalSucceededViewModel) {
              Navigator.pushReplacementNamed(context, TransactionApprovalSuccessScreen.routeName);
            } else if (newViewModel is TransactionApprovalFailedViewModel) {
              Navigator.pushReplacementNamed(context, TransactionApprovalFailedScreen.routeName);
            }
          },
          builder: (context, viewModel) => viewModel is TransactionApprovalWithMessageViewModel
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Appbar(),
                    ...viewModel.isLoading
                        ? [const Expanded(child: Center(child: CircularProgressIndicator()))]
                        : _buildPageContent(context, viewModel),
                    const SizedBox(height: 16),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  List<Widget> _buildPageContent(BuildContext context, TransactionApprovalWithMessageViewModel viewModel) {
    return [
      _buildPaymentInfo(context, viewModel),
      SizedBox(
        width: double.infinity,
        child: SecondaryButton(
          text: "Reject",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const _RejectionAlertDialog(),
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
            AuthenticatedUser user = context.read<AuthCubit>().state.user!;

            if (viewModel is TransactionApprovalWithChallengeViewModel) {
              StoreProvider.of<AppState>(context).dispatch(
                ConfirmTransactionApprovalChallengeCommandAction(
                  user: user.cognito,
                  changeRequestId: viewModel.changeRequestId,
                  deviceData: viewModel.deviceData,
                  deviceId: viewModel.deviceId,
                  stringToSign: viewModel.stringToSign,
                ),
              );
            }
          },
        ),
      )
    ];
  }

  Widget _buildPaymentInfo(BuildContext context, TransactionApprovalWithMessageViewModel viewModel) {
    print("_buildPaymentInfo");
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
                  duration: const Duration(minutes: 10),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CardListItem(cardNumber: "*** 4573", expiryDate: "10/27"),
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
  const _RejectionAlertDialog();

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
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: ClientConfig.getTextStyleScheme()
                .heading4
                .copyWith(fontWeight: FontWeight.w400, color: ClientConfig.getColorScheme().secondary),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, TransactionApprovalFailedScreen.routeName, (route) => false);
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
