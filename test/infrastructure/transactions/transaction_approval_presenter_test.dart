import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_approval_presenter.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

import '../bank_card/bank_card_presenter_test.dart';

void main() {
  final notificationMessage = NotificationTransactionMessage(
    cardId: "cardId",
    amountValue: "23",
    amountUnit: "cents",
    amountCurrency: "EUR",
    merchantName: "AMAZON",
    dateTime: DateTime.now(),
    changeRequestId: "changeRequestId",
    declineChangeRequestId: "declineChangeRequestId",
  );

  final bankCard = BankCard(
    id: "inactive-card-id",
    accountId: "62a8f478184ae7cba59c633373c53286cacc",
    status: BankCardStatus.ACTIVE,
    type: BankCardType.VIRTUAL_VISA_CREDIT,
    representation: BankCardRepresentation(
      line1: "ACTIVE JOE",
      line2: "ACTIVE JOE",
      maskedPan: '493441******9641',
      formattedExpirationDate: '06/26',
    ),
  );

  test("when notification state is initial should return initial", () {
    // given
    final notificationState = NotificationInitialState();
    final transactionApprovalState = TransactionApprovalInitialState();
    final bankCardState = BankCardInitialState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(viewModel, isA<TransactionApprovalInitialViewModel>());
  });

  test("when approval state is loading should return loading", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalLoadingState();
    final bankCardState = BankCardInitialState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(viewModel, WithMessageViewModel(message: notificationMessage, isLoading: true));
  });

  test("when bank card state is loading should return loading", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalInitialState();
    final bankCardState = BankCardLoadingState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(viewModel, WithMessageViewModel(message: notificationMessage, isLoading: true));
  });

  test("when transaction approval state is rejected should return rejected", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalRejectedState();
    final bankCardState = BankCardInitialState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(viewModel, isA<TransactionApprovalRejectedViewModel>());
  });

  test("when device is not bounded should return failed", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalDeviceNotBoundedState();
    final bankCardState = BankCardInitialState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(
      viewModel,
      TransactionApprovalFailedViewModel(errorType: TransactionApprovalErrorType.unboundedDeviceError),
    );
  });

  test("when approval state is failed should return failed", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalFailedState();
    final bankCardState = BankCardInitialState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(
      viewModel,
      TransactionApprovalFailedViewModel(errorType: TransactionApprovalErrorType.unknownError),
    );
  });

  test("when card state is error should return failed", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalInitialState();
    final bankCardState = BankCardErrorState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(
      viewModel,
      TransactionApprovalFailedViewModel(errorType: TransactionApprovalErrorType.unknownError),
    );
  });

  test("when approval state is authorized and card is fetched", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalAuthorizedState(
      stringToSign: "stringToSign",
      deviceId: "deviceId",
      deviceData: "deviceData",
      changeRequestId: "changeRequestId",
    );
    final bankCardState = BankCardFetchedState(bankCard, MockAuthenticatedUser());

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(
      viewModel,
      WithApprovalChallengeViewModel(
        isLoading: false,
        bankCard: bankCardState.bankCard,
        message: notificationState.message,
        deviceId: transactionApprovalState.deviceId,
        deviceData: transactionApprovalState.deviceData,
        stringToSign: transactionApprovalState.stringToSign,
        changeRequestId: transactionApprovalState.changeRequestId,
      ),
    );
  });

  test("when transaction approval is succeeded should return succeded", () {
    // given
    final notificationState = NotificationTransactionApprovalState(
      message: notificationMessage,
    );
    final transactionApprovalState = TransactionApprovalSucceededState();
    final bankCardState = BankCardInitialState();

    // when
    final viewModel = TransactionApprovalPresenter.present(
      notificationState: notificationState,
      transactionApprovalState: transactionApprovalState,
      bankCardState: bankCardState,
    );

    // then
    expect(viewModel, isA<TransactionApprovalSucceededViewModel>());
  });
}
