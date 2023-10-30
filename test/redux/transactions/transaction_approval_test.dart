import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

import '../../setup/authentication_helper.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import '../auth/auth_mocks.dart';
import 'transaction_mocks.dart';

void main() {
  final authState = AuthStatePlaceholder.loggedInState();

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
          authState: authState,
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState = store.onChange
          .firstWhere((element) => element.transactionApprovalState is TransactionApprovalAuthorizedState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalFailedState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState = store.onChange
          .firstWhere((element) => element.transactionApprovalState is TransactionApprovalDeviceNotBoundedState);

      // when
      store.dispatch(
        AuthorizeTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);

      // when
      store.dispatch(ConfirmTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalSucceededState);

      // when
      store.dispatch(ConfirmTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalFailedState);

      // when
      store.dispatch(ConfirmTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalRejectedState);

      // when
      store.dispatch(RejectTransactionCommandAction(
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalFailedState);

      // when
      store.dispatch(RejectTransactionCommandAction(
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
