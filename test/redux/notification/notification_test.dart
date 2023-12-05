import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/redux/notification/notification_action.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import '../auth/auth_mocks.dart';
import '../transactions/transaction_mocks.dart';

void main() {
  final message = NotificationTransactionMessage(
    cardId: "cardId",
    amountValue: "32",
    amountUnit: "cents",
    merchantName: "KFC",
    amountCurrency: "EUR",
    dateTime: DateTime.now(),
    changeRequestId: "changeRequestId",
    declineChangeRequestId: "declineChangeRequestId",
  );

  test("When using the reset command the state should reset to initial", () async {
    // given
    final store = createTestStore(
      deviceService: FakeDeviceService(),
      biometricsService: FakeBiometricsService(),
      changeRequestService: FakeChangeRequestService(),
      initialState: createAppState(
        notificationState: NotificationTransactionApprovalState(message: message),
      ),
    );
    final appState = store.onChange.firstWhere(
      (element) => element.notificationState is NotificationInitialState,
    );

    // when
    store.dispatch(ResetNotificationCommandAction());

    // then
    expect((await appState).notificationState, isA<NotificationInitialState>());
  });

  group("Receiving a notification", () {
    test(
        "When a transaction approval notification is received, the transaction approval state and notification state should change ",
        () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        changeRequestService: FakeChangeRequestService(),
        initialState: createAppState(
          notificationState: NotificationInitialState(),
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );

      final appState = store.onChange.firstWhere(
        (element) => element.notificationState is NotificationTransactionApprovalState,
      );
      final transactionApprovalState = store.onChange.firstWhere(
        (element) => element.transactionApprovalState is TransactionApprovalLoadingState,
      );

      // when
      store.dispatch(ReceivedTransactionApprovalNotificationEventAction(user: MockUser(), message: message));

      // then
      expect((await appState).notificationState, isA<NotificationTransactionApprovalState>());
      expect((await transactionApprovalState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
    });

    test("When a scoring successful notification is received, the state should change", () async {
      // given
      final store = createTestStore(
        initialState: createAppState(
          notificationState: NotificationInitialState(),
        ),
      );
      final appState = store.onChange.firstWhere(
        (element) => element.notificationState is NotificationScoringSuccessfulState,
      );

      // when
      store.dispatch(ReceivedScoringSuccessfulNotificationEventAction());

      // then
      expect((await appState).notificationState, isA<NotificationScoringSuccessfulState>());
    });

    test("When a scoring failed notification is received, the state should change", () async {
      // given
      final store = createTestStore(
        initialState: createAppState(
          notificationState: NotificationInitialState(),
        ),
      );
      final appState = store.onChange.firstWhere(
        (element) => element.notificationState is NotificationScoringFailedState,
      );

      // when
      store.dispatch(ReceivedScoringFailedNotificationEventAction());

      // then
      expect((await appState).notificationState, isA<NotificationScoringFailedState>());
    });

    test("When a scoring in progress notification is received, the state should change", () async {
      // given
      final store = createTestStore(
        initialState: createAppState(
          notificationState: NotificationInitialState(),
        ),
      );
      final appState = store.onChange.firstWhere(
        (element) => element.notificationState is NotificationScoringInProgressState,
      );

      // when
      store.dispatch(ReceivedScoringInProgressNotificationEventAction());

      // then
      expect((await appState).notificationState, isA<NotificationScoringInProgressState>());
    });
  });
}
