import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

import '../../infrastructure/repayments/more_credit/more_credit_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'transaction_mocks.dart';

void main() {
  group("Authorization", () {
    test("When requesting transaction approval challenge the state should change to loading", () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
          user: MockUser(),
          changeRequestId: "changeRequestId",
        ),
      );

      // then
      expect((await appState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
    });

    test("When transaction approval challenge is successfully authorized", () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState = store.onChange
          .firstWhere((element) => element.transactionApprovalState is TransactionApprovalAuthorizedState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
          user: MockUser(),
          changeRequestId: "changeRequestId",
        ),
      );

      // then
      expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
      expect((await appState).transactionApprovalState, isA<TransactionApprovalAuthorizedState>());
    });

    test("When transaction approval challenge failed authorization", () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeFailingChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalFailedState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
          user: MockUser(),
          changeRequestId: "changeRequestId",
        ),
      );

      // then
      expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
      expect((await appState).transactionApprovalState, isA<TransactionApprovalFailedState>());
    });

    test("When requesting for transaction approval and device is not bounded", () async {
      // given
      final store = createTestStore(
        changeRequestService: FakeChangeRequestService(),
        deviceService: FakeFailingDeviceService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState = store.onChange
          .firstWhere((element) => element.transactionApprovalState is TransactionApprovalDeviceNotBoundedState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
          user: MockUser(),
          changeRequestId: "changeRequestId",
        ),
      );

      // then
      expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
      expect((await appState).transactionApprovalState, isA<TransactionApprovalDeviceNotBoundedState>());
    });
  });
  group("Confirmation", () {
    test("When requesting for transaction challenge confirmation the state should change to loading first", () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);

      // when
      store.dispatch(ConfirmTransactionCommandAction(
        user: MockUser(),
        changeRequestId: "changeRequestId",
        deviceData: "deviceData",
        deviceId: "deviceId",
        stringToSign: "stringToSign",
      ));

      // then
      expect((await appState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
    });

    test("When transaction challenge is confirmed successfully", () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalSucceededState);

      // when
      store.dispatch(ConfirmTransactionCommandAction(
        user: MockUser(),
        changeRequestId: "changeRequestId",
        deviceData: "deviceData",
        deviceId: "deviceId",
        stringToSign: "stringToSign",
      ));

      // then
      expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
      expect((await appState).transactionApprovalState, isA<TransactionApprovalSucceededState>());
    });

    test("When transaction challenge failed confirmation", () async {
      // given
      final transactionApprovalAuthorizedState = TransactionApprovalAuthorizedState(
          changeRequestId: "changeRequestId",
          deviceData: "deviceData",
          deviceId: "deviceId",
          stringToSign: "stringToSign");

      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeFailingConfirmChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: transactionApprovalAuthorizedState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalFailedState);

      // when
      store.dispatch(ConfirmTransactionCommandAction(
        user: MockUser(),
        changeRequestId: "changeRequestId",
        deviceData: "deviceData",
        deviceId: "deviceId",
        stringToSign: "stringToSign",
      ));

      // then
      expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
      expect((await appState).transactionApprovalState, isA<TransactionApprovalFailedState>());
    });
  });

  group("Declining", () {
    test("When declining transaction challenge", () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalRejectedState);

      // when
      store.dispatch(RejectTransactionCommandAction(
        user: MockUser(),
        declineChangeRequestId: "declineChangeRequestId",
        deviceData: "deviceData",
        deviceId: "deviceId",
        stringToSign: "stringToSign",
      ));

      // then
      expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
      expect((await appState).transactionApprovalState, isA<TransactionApprovalRejectedState>());
    });

    test("When failed declining transaction challenge", () async {
      // given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        biometricsService: FakeBiometricsService(),
        changeRequestService: FakeFailingChangeRequestService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          transactionApprovalState: TransactionApprovalInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalFailedState);

      // when
      store.dispatch(RejectTransactionCommandAction(
        user: MockUser(),
        declineChangeRequestId: "declineChangeRequestId",
        deviceData: "deviceData",
        deviceId: "deviceId",
        stringToSign: "stringToSign",
      ));

      // then
      expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
      expect((await appState).transactionApprovalState, isA<TransactionApprovalFailedState>());
    });
  });
}
