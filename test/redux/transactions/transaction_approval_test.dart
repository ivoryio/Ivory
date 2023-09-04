import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

import '../../infrastructure/repayments/more_credit/more_credit_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'transactions_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setMockInitialValues({
    'device_consent_id': 'consentId',
    'device_id': 'deviceId',
  });

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('com.thinslices.solarisdemo/native'),
    (call) async {
      return 'deviceData';
    },
  );

  test("When requesting transaction approval challenge the state should change to loading", () async {
    // given
    final store = createTestStore(
      initialState: createAppState(
        transactionApprovalState: TransactionApprovalInitialState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);

    // when
    store.dispatch(
      AuthorizeTransactionApprovalChallengeCommandAction(
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
      changeRequestService: FakeChangeRequestService(),
      initialState: createAppState(
        transactionApprovalState: TransactionApprovalInitialState(),
      ),
    );
    final loadingState =
        store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
    final appState =
        store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalAuthorizedState);

    // when
    store.dispatch(
      AuthorizeTransactionApprovalChallengeCommandAction(
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
      changeRequestService: FakeFailingChangeRequestService(),
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
      AuthorizeTransactionApprovalChallengeCommandAction(
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
    SharedPreferences.setMockInitialValues({});

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.thinslices.solarisdemo/native'),
      (call) async => '',
    );

    final store = createTestStore(
      changeRequestService: FakeChangeRequestService(),
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
      AuthorizeTransactionApprovalChallengeCommandAction(
        user: MockUser(),
        changeRequestId: "changeRequestId",
      ),
    );

    // then
    expect((await loadingState).transactionApprovalState, isA<TransactionApprovalLoadingState>());
    expect((await appState).transactionApprovalState, isA<TransactionApprovalDeviceNotBoundedState>());
  });

  test("When requesting for transaction challenge confirmation the state should change to loading first", () async {
    // given
    final store = createTestStore(
      changeRequestService: FakeChangeRequestService(),
      initialState: createAppState(
        transactionApprovalState: TransactionApprovalInitialState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);

    // when
    store.dispatch(ConfirmTransactionApprovalChallengeCommandAction(
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
    print("this test is running");

    final store = createTestStore(
      changeRequestService: FakeChangeRequestService(),
      initialState: createAppState(
        transactionApprovalState: TransactionApprovalInitialState(),
      ),
    );
    final loadingState =
        store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalLoadingState);
    final appState =
        store.onChange.firstWhere((element) => element.transactionApprovalState is TransactionApprovalSucceededState);

    // when
    store.dispatch(ConfirmTransactionApprovalChallengeCommandAction(
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
}
