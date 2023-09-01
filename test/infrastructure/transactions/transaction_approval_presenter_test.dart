import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_approval_presenter.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

void main() {
  const notificationMessage = NotificationTransactionMessage(
    changeRequestId: "changeRequestId",
    declineChangeRequestId: "declineChangeRequestId",
    merchantName: "AMAZON",
    amountValue: "23",
    amountUnit: "cents",
    amountCurrency: "EUR",
  );

  test("present notification with details about the transaction", () {
    // given
    final notificationState = NotificationTransactionApprovalState(message: notificationMessage);
    final transactionApprovalState = TransactionApprovalInitialState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
    );

    // then
    expect(viewModel, TransactionApprovalWithMessageViewModel(message: notificationMessage));
  });
}
