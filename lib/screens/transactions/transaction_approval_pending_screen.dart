import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_approval_presenter.dart';
import 'package:solarisdemo/models/amount_value.dart';
import 'package:solarisdemo/models/categories/category.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
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
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/transaction_listing_item.dart';

class TransactionApprovalPendingScreen extends StatelessWidget {
  static const routeName = '/transactionApprovalPendingScreen';

  const TransactionApprovalPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        child: StoreConnector<AppState, TransactionApprovalViewModel>(
            onInit: (store) {
              if (store.state.notificationState is NotificationTransactionApprovalState) {
                store.dispatch(
                  GetBankCardCommandAction(
                    user: user,
                    cardId: (store.state.notificationState as NotificationTransactionApprovalState).message.cardId,
                    forceReloadCardData: true,
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
          onPressed: () async {
            showBottomModal(
              context: context,
              title: 'Reject this payment',
              textWidget: Text(
                "Are you sure you want to reject this payment?",
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
              ),
              content: _RejectPopUp(
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
    final cardMaskedPan = viewModel.bankCard.representation?.maskedPan ?? "";

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
                  onCompleted: () async {
                    final bottomSheet = await showBottomModal(
                      context: context,
                      title: "Payment confirmation timed out",
                      textWidget: Text(
                        "The payment has been automatically rejected.",
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                      content: const _TimeoutPopUp(),
                    );

                    final isDismissed = bottomSheet == null;

                    if (isDismissed) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    }
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
                  category: const Category(id: "transactionApproval", name: "Transaction Approval"),
                  recordedAt: viewModel.message.dateTime,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("Card details", style: ClientConfig.getTextStyleScheme().labelLarge),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CardListItem(
                cardNumber: "\u2217\u2217\u2217\u2217 ${cardMaskedPan.substring(cardMaskedPan.length - 4)}",
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

class _TimeoutPopUp extends StatelessWidget {
  const _TimeoutPopUp();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'OK',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class _RejectPopUp extends StatelessWidget {
  final void Function() onConfirm;
  const _RejectPopUp({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            text: 'Cancel',
            borderWidth: 2,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Button(
            text: 'Yes, reject',
            color: const Color(0xFFCC0000),
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
        ),
      ],
    );
  }
}
