import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/currency/currency.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/redux/transfer/transfer_action.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

import '../../infrastructure/bank_card/bank_card_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'transfer_mocks.dart';

void main() {
  const transfer = ReferenceAccountTransfer(
    description: "transfer description",
    amount: ReferenceAccountTransferAmount(
      value: 100,
      currency: Currency.euro,
    ),
  );

  group("Creating the transfer", () {
    test("When is sending a transfer the state should change to loading", () async {
      //given
      final store = createTestStore(
        transferService: FakeTransferService(),
        changeRequestService: FakeChangeRequestService(),
        initialState: createAppState(
          transferState: TransferInitialState(),
        ),
      );

      final appState = store.onChange.firstWhere((state) => state.transferState is TransferLoadingState);

      //when
      store.dispatch(TransferCommandAction(user: MockUser(), transfer: transfer));

      //then
      expect((await appState).transferState, isA<TransferLoadingState>());
    });

    test("When sending a transfer successfully the state should change to need confirmation state", () async {
      //given
      final store = createTestStore(
        transferService: FakeTransferService(),
        changeRequestService: FakeChangeRequestService(),
        initialState: createAppState(
          transferState: TransferInitialState(),
        ),
      );

      final appState = store.onChange.firstWhere((state) => state.transferState is TransferNeedConfirmationState);

      //when
      store.dispatch(TransferCommandAction(user: MockUser(), transfer: transfer));

      //then
      expect((await appState).transferState, isA<TransferNeedConfirmationState>());
    });

    test("When failed sending a transfer the state should change to failed", () async {
      //given
      final store = createTestStore(
        transferService: FakeFailingTransferService(),
        changeRequestService: FakeChangeRequestService(),
        initialState: createAppState(
          transferState: TransferInitialState(),
        ),
      );

      final appState = store.onChange.firstWhere((state) => state.transferState is TransferFailedState);

      //when
      store.dispatch(TransferCommandAction(user: MockUser(), transfer: transfer));

      //then
      expect((await appState).transferState, isA<TransferFailedState>());
    });
  });
  group("Confirming the transfer", () {
    test("When is confirming a transfer the state should change to loading", () {
      //given
      final store = createTestStore(
        transferService: FakeTransferService(),
        changeRequestService: FakeChangeRequestService(),
        initialState: createAppState(
          transferState: TransferNeedConfirmationState(),
        ),
      );

      //when
      store.dispatch(ConfirmTransferCommandAction(
        user: MockUser(),
        changeRequestId: "changeRequestId",
        tan: "tan",
      ));

      //then
      expect(store.state.transferState, isA<TransferConfirmationLoadingState>());
    });

    test("When is confirming a transfer successfully the state should change to confirmed", () async {
      //given
      final store = createTestStore(
        transferService: FakeTransferService(),
        changeRequestService: FakeChangeRequestService(),
        initialState: createAppState(
          transferState: TransferNeedConfirmationState(),
        ),
      );

      final appState = store.onChange.firstWhere((state) => state.transferState is TransferConfirmedState);

      //when
      store.dispatch(ConfirmTransferCommandAction(
        user: MockUser(),
        changeRequestId: "changeRequestId",
        tan: "tan",
      ));

      //then
      expect((await appState).transferState, isA<TransferConfirmedState>());
    });

    test("When is failed confirming a transfer the state should change to failed", () async {
      //given
      final store = createTestStore(
        transferService: FakeTransferService(),
        changeRequestService: FakeFailingChangeRequestService(),
        initialState: createAppState(
          transferState: TransferNeedConfirmationState(),
        ),
      );

      final appState = store.onChange.firstWhere((state) => state.transferState is TransferFailedState);

      //when
      store.dispatch(ConfirmTransferCommandAction(
        user: MockUser(),
        changeRequestId: "changeRequestId",
        tan: "tan",
      ));

      //then
      expect((await appState).transferState, isA<TransferFailedState>());
    });
  });
}
